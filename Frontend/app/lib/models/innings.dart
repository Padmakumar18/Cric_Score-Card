import 'batsman.dart';
import 'bowler.dart';
import 'over.dart';
import 'ball_event.dart';

/// Represents a cricket innings
class Innings {
  final String battingTeam;
  final String bowlingTeam;
  final List<Batsman> batsmen;
  final List<Bowler> bowlers;
  final List<Over> overs;
  final int totalRuns;
  final int wickets;
  final int ballsBowled;
  final int extras;
  final int target; // 0 if batting first
  final bool isComplete;

  const Innings({
    required this.battingTeam,
    required this.bowlingTeam,
    this.batsmen = const [],
    this.bowlers = const [],
    this.overs = const [],
    this.totalRuns = 0,
    this.wickets = 0,
    this.ballsBowled = 0,
    this.extras = 0,
    this.target = 0,
    this.isComplete = false,
  });

  /// Get current over number (1-based)
  int get currentOverNumber => (ballsBowled ~/ 6) + 1;

  /// Get balls in current over
  int get ballsInCurrentOver => ballsBowled % 6;

  /// Get overs completed as string (e.g., "15.3")
  String get oversString {
    final completeOvers = ballsBowled ~/ 6;
    final remainingBalls = ballsBowled % 6;
    if (remainingBalls == 0 && completeOvers > 0) {
      return completeOvers.toString();
    }
    return '$completeOvers.$remainingBalls';
  }

  /// Get current run rate
  double get runRate {
    if (ballsBowled == 0) return 0.0;
    return (totalRuns / ballsBowled) * 6;
  }

  /// Get required run rate (for chasing team) with total overs
  double getRequiredRunRate(int totalOvers) {
    if (target == 0) return 0.0;
    final remainingRuns = target - totalRuns;
    final totalBalls = totalOvers * 6;
    final remainingBalls = totalBalls - ballsBowled;
    if (remainingBalls <= 0) return 0.0;
    return (remainingRuns / remainingBalls) * 6;
  }

  /// Get required run rate (for chasing team) - default T20
  double get requiredRunRate {
    if (target == 0) return 0.0;
    final remainingRuns = target - totalRuns;
    final remainingBalls = (20 * 6) - ballsBowled; // Assuming T20
    if (remainingBalls <= 0) return 0.0;
    return (remainingRuns / remainingBalls) * 6;
  }

  /// Get remaining balls in innings (needs total overs from match)
  int getRemainingBalls(int totalOvers) {
    final totalBalls = totalOvers * 6;
    return totalBalls - ballsBowled;
  }

  /// Get projected total (needs total overs from match)
  int getProjectedTotal(int totalOvers) {
    if (ballsBowled == 0) return 0;
    final totalBalls = totalOvers * 6;
    return ((totalRuns / ballsBowled) * totalBalls).round();
  }

  /// Get projected total (default T20)
  int get projectedTotal {
    if (ballsBowled == 0) return 0;
    return ((totalRuns / ballsBowled) * (20 * 6)).round(); // Assuming T20
  }

  /// Get current batsmen (on strike and non-striker)
  List<Batsman> get currentBatsmen {
    return batsmen.where((b) => !b.isOut).take(2).toList();
  }

  /// Get batsman on strike
  Batsman? get strikerBatsman {
    try {
      return batsmen.firstWhere((b) => b.isOnStrike && !b.isOut);
    } catch (e) {
      return null;
    }
  }

  /// Get non-striker batsman
  Batsman? get nonStrikerBatsman {
    try {
      return batsmen.firstWhere((b) => !b.isOnStrike && !b.isOut);
    } catch (e) {
      return null;
    }
  }

  /// Get current bowler
  Bowler? get currentBowler {
    try {
      return bowlers.firstWhere((b) => b.isCurrentBowler);
    } catch (e) {
      return null;
    }
  }

  /// Get last 6 balls
  List<BallEvent> get lastSixBalls {
    final allBalls = <BallEvent>[];
    for (final over in overs.reversed) {
      allBalls.addAll(over.balls.reversed);
      if (allBalls.length >= 6) break;
    }
    return allBalls.take(6).toList();
  }

  Innings copyWith({
    String? battingTeam,
    String? bowlingTeam,
    List<Batsman>? batsmen,
    List<Bowler>? bowlers,
    List<Over>? overs,
    int? totalRuns,
    int? wickets,
    int? ballsBowled,
    int? extras,
    int? target,
    bool? isComplete,
  }) {
    return Innings(
      battingTeam: battingTeam ?? this.battingTeam,
      bowlingTeam: bowlingTeam ?? this.bowlingTeam,
      batsmen: batsmen ?? this.batsmen,
      bowlers: bowlers ?? this.bowlers,
      overs: overs ?? this.overs,
      totalRuns: totalRuns ?? this.totalRuns,
      wickets: wickets ?? this.wickets,
      ballsBowled: ballsBowled ?? this.ballsBowled,
      extras: extras ?? this.extras,
      target: target ?? this.target,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
