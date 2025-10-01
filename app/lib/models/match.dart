import 'innings.dart';
import 'batsman.dart';
import 'bowler.dart';

/// Represents a complete cricket match
class Match {
  final String team1;
  final String team2;
  final int oversPerInnings;
  final String tossWinner;
  final String tossDecision; // 'bat' or 'bowl'
  final Innings? firstInnings;
  final Innings? secondInnings;
  final bool isFirstInningsComplete;
  final String
  status; // 'not_started', 'first_innings', 'second_innings', 'completed'
  final String? result;

  const Match({
    required this.team1,
    required this.team2,
    this.oversPerInnings = 20,
    required this.tossWinner,
    required this.tossDecision,
    this.firstInnings,
    this.secondInnings,
    this.isFirstInningsComplete = false,
    this.status = 'not_started',
    this.result,
  });

  /// Get current innings being played
  Innings? get currentInnings {
    if (status == 'first_innings') return firstInnings;
    if (status == 'second_innings') return secondInnings;
    return null;
  }

  /// Get batting team name for current innings
  String get currentBattingTeam {
    if (status == 'first_innings') {
      return tossDecision == 'bat' ? tossWinner : getOtherTeam(tossWinner);
    } else if (status == 'second_innings') {
      return tossDecision == 'bat' ? getOtherTeam(tossWinner) : tossWinner;
    }
    return '';
  }

  /// Get bowling team name for current innings
  String get currentBowlingTeam {
    if (status == 'first_innings') {
      return tossDecision == 'bat' ? getOtherTeam(tossWinner) : tossWinner;
    } else if (status == 'second_innings') {
      return tossDecision == 'bat' ? tossWinner : getOtherTeam(tossWinner);
    }
    return '';
  }

  /// Get the other team name
  String getOtherTeam(String team) {
    return team == team1 ? team2 : team1;
  }

  /// Check if match is completed
  bool get isCompleted => status == 'completed';

  /// Get match summary for display
  String get matchSummary {
    if (status == 'not_started') return 'Match not started';
    if (status == 'first_innings' && firstInnings != null) {
      return '${firstInnings!.battingTeam}: ${firstInnings!.totalRuns}/${firstInnings!.wickets} (${firstInnings!.oversString})';
    }
    if (status == 'second_innings' && secondInnings != null) {
      final first = firstInnings!;
      final second = secondInnings!;
      return '${first.battingTeam}: ${first.totalRuns}/${first.wickets} | ${second.battingTeam}: ${second.totalRuns}/${second.wickets} (${second.oversString})';
    }
    return result ?? 'Match in progress';
  }

  Match copyWith({
    String? team1,
    String? team2,
    int? oversPerInnings,
    String? tossWinner,
    String? tossDecision,
    Innings? firstInnings,
    Innings? secondInnings,
    bool? isFirstInningsComplete,
    String? status,
    String? result,
  }) {
    return Match(
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      oversPerInnings: oversPerInnings ?? this.oversPerInnings,
      tossWinner: tossWinner ?? this.tossWinner,
      tossDecision: tossDecision ?? this.tossDecision,
      firstInnings: firstInnings ?? this.firstInnings,
      secondInnings: secondInnings ?? this.secondInnings,
      isFirstInningsComplete:
          isFirstInningsComplete ?? this.isFirstInningsComplete,
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  /// Start first innings
  Match startFirstInnings(
    List<String> battingPlayers,
    List<String> bowlingPlayers,
  ) {
    final batsmen = battingPlayers
        .take(2)
        .map(
          (name) => Batsman(
            name: name,
            isOnStrike: battingPlayers.indexOf(name) == 0,
          ),
        )
        .toList();

    final bowlers = bowlingPlayers.map((name) => Bowler(name: name)).toList();

    final innings = Innings(
      battingTeam: currentBattingTeam,
      bowlingTeam: currentBowlingTeam,
      batsmen: batsmen,
      bowlers: bowlers,
    );

    return copyWith(firstInnings: innings, status: 'first_innings');
  }

  /// Start second innings
  Match startSecondInnings(
    List<String> battingPlayers,
    List<String> bowlingPlayers,
  ) {
    if (firstInnings == null) return this;

    final target = firstInnings!.totalRuns + 1;
    final batsmen = battingPlayers
        .take(2)
        .map(
          (name) => Batsman(
            name: name,
            isOnStrike: battingPlayers.indexOf(name) == 0,
          ),
        )
        .toList();

    final bowlers = bowlingPlayers.map((name) => Bowler(name: name)).toList();

    final innings = Innings(
      battingTeam: currentBattingTeam,
      bowlingTeam: currentBowlingTeam,
      batsmen: batsmen,
      bowlers: bowlers,
      target: target,
    );

    return copyWith(
      secondInnings: innings,
      status: 'second_innings',
      isFirstInningsComplete: true,
    );
  }
}
