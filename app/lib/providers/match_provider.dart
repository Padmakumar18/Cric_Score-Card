import 'package:flutter/foundation.dart';
import '../models/match.dart';
import '../models/batsman.dart';
import '../models/ball_event.dart';
import '../models/over.dart';
import '../constants/app_constants.dart';

/// State management for cricket match data and operations
class MatchProvider extends ChangeNotifier {
  Match? _currentMatch;
  final List<BallEvent> _ballHistory = [];
  final List<Match> _matchStateHistory = [];

  Match? get currentMatch => _currentMatch;
  List<BallEvent> get ballHistory => _ballHistory;
  bool get canUndo => _matchStateHistory.isNotEmpty;

  /// Create a new match
  void createMatch({
    required String team1,
    required String team2,
    required int oversPerInnings,
    required String tossWinner,
    required String tossDecision,
  }) {
    _currentMatch = Match(
      team1: team1,
      team2: team2,
      oversPerInnings: oversPerInnings,
      tossWinner: tossWinner,
      tossDecision: tossDecision,
    );
    _ballHistory.clear();
    notifyListeners();
  }

  /// Start first innings with players
  void startFirstInnings(
    List<String> battingPlayers,
    List<String> bowlingPlayers,
  ) {
    if (_currentMatch == null) {
      debugPrint('MatchProvider: Cannot start innings - no current match');
      return;
    }

    debugPrint(
      'MatchProvider: Starting first innings with ${battingPlayers.length} batsmen and ${bowlingPlayers.length} bowlers',
    );
    _currentMatch = _currentMatch!.startFirstInnings(
      battingPlayers,
      bowlingPlayers,
    );
    debugPrint(
      'MatchProvider: Match status after starting innings: ${_currentMatch!.status}',
    );
    debugPrint(
      'MatchProvider: Current innings exists: ${_currentMatch!.currentInnings != null}',
    );
    notifyListeners();
  }

  /// Start second innings
  void startSecondInnings(
    List<String> battingPlayers,
    List<String> bowlingPlayers,
  ) {
    if (_currentMatch == null) return;

    _currentMatch = _currentMatch!.startSecondInnings(
      battingPlayers,
      bowlingPlayers,
    );
    notifyListeners();
  }

  /// Add a ball event to current innings
  void addBallEvent({
    required int runs,
    bool isWicket = false,
    bool isWide = false,
    bool isNoBall = false,
    bool isBye = false,
    bool isLegBye = false,
    String? wicketType,
    String? dismissedBatsman,
  }) {
    if (_currentMatch?.currentInnings == null) {
      debugPrint('MatchProvider: Cannot add ball event - no current innings');
      return;
    }

    try {
      // Save current state for undo functionality
      _saveMatchState();

      final ballEvent = BallEvent(
        runs: runs,
        isWicket: isWicket,
        isWide: isWide,
        isNoBall: isNoBall,
        isBye: isBye,
        isLegBye: isLegBye,
        wicketType: wicketType,
        dismissedBatsman: dismissedBatsman,
        timestamp: DateTime.now(),
      );

      _ballHistory.add(ballEvent);
      _updateInningsWithBall(ballEvent);
      notifyListeners();
    } catch (e) {
      debugPrint('MatchProvider: Error adding ball event: $e');
      rethrow;
    }
  }

  /// Save current match state for undo functionality
  void _saveMatchState() {
    if (_currentMatch != null) {
      _matchStateHistory.add(_currentMatch!.copyWith());
      // Keep only last 10 states to prevent memory issues
      if (_matchStateHistory.length > 10) {
        _matchStateHistory.removeAt(0);
      }
    }
  }

  /// Update innings with ball event
  void _updateInningsWithBall(BallEvent ball) {
    final currentInnings = _currentMatch!.currentInnings!;
    final currentBowler = currentInnings.currentBowler;
    final strikerBatsman = currentInnings.strikerBatsman;

    if (currentBowler == null || strikerBatsman == null) return;

    // Update batsman stats
    final updatedBatsmen = currentInnings.batsmen.map((batsman) {
      if (batsman.name == strikerBatsman.name) {
        return batsman.addRuns(
          ball.runs,
          ball.runs == 4,
          ball.runs == 6,
          ball.countsTowardsOver || ball.isNoBall,
        );
      }
      return batsman;
    }).toList();

    // Update bowler stats
    final updatedBowlers = currentInnings.bowlers.map((bowler) {
      if (bowler.name == currentBowler.name) {
        return bowler.addBall(ball.totalRuns, ball.isWicket);
      }
      return bowler;
    }).toList();

    // Update overs
    final updatedOvers = _updateOvers(
      currentInnings.overs,
      ball,
      currentBowler.name,
    );

    // Calculate new totals
    final newTotalRuns = currentInnings.totalRuns + ball.totalRuns;
    final newWickets = ball.isWicket
        ? currentInnings.wickets + 1
        : currentInnings.wickets;
    final newBallsBowled = ball.countsTowardsOver
        ? currentInnings.ballsBowled + 1
        : currentInnings.ballsBowled;
    final newExtras =
        (ball.isWide || ball.isNoBall || ball.isBye || ball.isLegBye)
        ? currentInnings.extras + 1
        : currentInnings.extras;

    // Update innings
    final updatedInnings = currentInnings.copyWith(
      batsmen: updatedBatsmen,
      bowlers: updatedBowlers,
      overs: updatedOvers,
      totalRuns: newTotalRuns,
      wickets: newWickets,
      ballsBowled: newBallsBowled,
      extras: newExtras,
    );

    // Update match
    if (_currentMatch!.status == AppConstants.statusFirstInnings) {
      _currentMatch = _currentMatch!.copyWith(firstInnings: updatedInnings);
    } else if (_currentMatch!.status == AppConstants.statusSecondInnings) {
      _currentMatch = _currentMatch!.copyWith(secondInnings: updatedInnings);
    }

    // Check for innings completion
    _checkInningsCompletion();
  }

  /// Update overs list with new ball
  List<Over> _updateOvers(List<Over> overs, BallEvent ball, String bowlerName) {
    if (overs.isEmpty) {
      // First over
      return [
        Over(
          overNumber: 1,
          bowlerName: bowlerName,
          balls: [ball],
          runsScored: ball.totalRuns,
          wickets: ball.isWicket ? 1 : 0,
        ),
      ];
    }

    final currentOver = overs.last;
    if (currentOver.isComplete) {
      // Start new over
      return [
        ...overs,
        Over(
          overNumber: currentOver.overNumber + 1,
          bowlerName: bowlerName,
          balls: [ball],
          runsScored: ball.totalRuns,
          wickets: ball.isWicket ? 1 : 0,
        ),
      ];
    } else {
      // Add to current over
      final updatedOver = currentOver.addBall(ball);
      return [...overs.sublist(0, overs.length - 1), updatedOver];
    }
  }

  /// Check if innings should be completed
  void _checkInningsCompletion() {
    final currentInnings = _currentMatch!.currentInnings!;
    final maxOvers = _currentMatch!.oversPerInnings;
    final maxBalls = maxOvers * 6;

    bool shouldComplete = false;
    String? result;

    // Check completion conditions
    if (currentInnings.ballsBowled >= maxBalls) {
      shouldComplete = true;
    } else if (currentInnings.wickets >= 10) {
      shouldComplete = true;
    } else if (currentInnings.target > 0 &&
        currentInnings.totalRuns >= currentInnings.target) {
      shouldComplete = true;
      result =
          '${currentInnings.battingTeam} won by ${10 - currentInnings.wickets} wickets';
    }

    if (shouldComplete) {
      if (_currentMatch!.status == AppConstants.statusFirstInnings) {
        _currentMatch = _currentMatch!.copyWith(
          firstInnings: currentInnings.copyWith(isComplete: true),
          isFirstInningsComplete: true,
        );
      } else if (_currentMatch!.status == AppConstants.statusSecondInnings) {
        if (result == null) {
          final firstInningsRuns = _currentMatch!.firstInnings!.totalRuns;
          final secondInningsRuns = currentInnings.totalRuns;
          if (secondInningsRuns > firstInningsRuns) {
            result =
                '${currentInnings.battingTeam} won by ${10 - currentInnings.wickets} wickets';
          } else if (firstInningsRuns > secondInningsRuns) {
            result =
                '${_currentMatch!.firstInnings!.battingTeam} won by ${firstInningsRuns - secondInningsRuns} runs';
          } else {
            result = 'Match tied';
          }
        }

        _currentMatch = _currentMatch!.copyWith(
          secondInnings: currentInnings.copyWith(isComplete: true),
          status: AppConstants.statusCompleted,
          result: result,
        );
      }
    }
  }

  /// Add new batsman to current innings
  void addNewBatsman(String name) {
    if (_currentMatch?.currentInnings == null) return;

    try {
      final currentInnings = _currentMatch!.currentInnings!;

      // Check if we already have maximum batsmen
      if (currentInnings.batsmen.length >= 11) {
        debugPrint('MatchProvider: Cannot add more batsmen - maximum reached');
        return;
      }

      // Ensure the new batsman comes in as non-striker if there's already a striker
      final hasStriker = currentInnings.batsmen.any(
        (b) => b.isOnStrike && !b.isOut,
      );
      final newBatsman = Batsman(name: name, isOnStrike: !hasStriker);
      final updatedBatsmen = [...currentInnings.batsmen, newBatsman];

      final updatedInnings = currentInnings.copyWith(batsmen: updatedBatsmen);

      if (_currentMatch!.status == AppConstants.statusFirstInnings) {
        _currentMatch = _currentMatch!.copyWith(firstInnings: updatedInnings);
      } else if (_currentMatch!.status == AppConstants.statusSecondInnings) {
        _currentMatch = _currentMatch!.copyWith(secondInnings: updatedInnings);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('MatchProvider: Error adding new batsman: $e');
    }
  }

  /// Change current bowler
  void changeBowler(String bowlerName) {
    if (_currentMatch?.currentInnings == null) return;

    final currentInnings = _currentMatch!.currentInnings!;
    final updatedBowlers = currentInnings.bowlers.map((bowler) {
      return bowler.copyWith(isCurrentBowler: bowler.name == bowlerName);
    }).toList();

    final updatedInnings = currentInnings.copyWith(bowlers: updatedBowlers);

    if (_currentMatch!.status == AppConstants.statusFirstInnings) {
      _currentMatch = _currentMatch!.copyWith(firstInnings: updatedInnings);
    } else if (_currentMatch!.status == AppConstants.statusSecondInnings) {
      _currentMatch = _currentMatch!.copyWith(secondInnings: updatedInnings);
    }

    notifyListeners();
  }

  /// Switch strike between batsmen
  void switchStrike() {
    if (_currentMatch?.currentInnings == null) return;

    try {
      final currentInnings = _currentMatch!.currentInnings!;
      final currentBatsmen = currentInnings.currentBatsmen;

      if (currentBatsmen.length < 2) {
        debugPrint('MatchProvider: Cannot switch strike - not enough batsmen');
        return;
      }

      final updatedBatsmen = currentInnings.batsmen.map((batsman) {
        if (!batsman.isOut && currentBatsmen.contains(batsman)) {
          return batsman.copyWith(isOnStrike: !batsman.isOnStrike);
        }
        return batsman;
      }).toList();

      final updatedInnings = currentInnings.copyWith(batsmen: updatedBatsmen);

      if (_currentMatch!.status == AppConstants.statusFirstInnings) {
        _currentMatch = _currentMatch!.copyWith(firstInnings: updatedInnings);
      } else if (_currentMatch!.status == AppConstants.statusSecondInnings) {
        _currentMatch = _currentMatch!.copyWith(secondInnings: updatedInnings);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('MatchProvider: Error switching strike: $e');
    }
  }

  /// Undo last ball
  void undoLastBall() {
    if (!canUndo) return;

    // Restore previous match state
    _currentMatch = _matchStateHistory.removeLast();

    // Remove last ball from history
    if (_ballHistory.isNotEmpty) {
      _ballHistory.removeLast();
    }

    notifyListeners();
  }

  /// Reset match
  void resetMatch() {
    _currentMatch = null;
    _ballHistory.clear();
    _matchStateHistory.clear();
    notifyListeners();
  }
}
