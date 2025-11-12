/// Represents a batsman's statistics and status
class Batsman {
  final String name;
  final int runs;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final bool isOut;
  final String? dismissalType;
  final bool isOnStrike;

  const Batsman({
    required this.name,
    this.runs = 0,
    this.ballsFaced = 0,
    this.fours = 0,
    this.sixes = 0,
    this.isOut = false,
    this.dismissalType,
    this.isOnStrike = false,
  });

  /// Calculate strike rate (runs per 100 balls)
  double get strikeRate {
    if (ballsFaced == 0) return 0.0;
    return (runs / ballsFaced) * 100;
  }

  /// Get status string for display
  String get statusString {
    if (isOut) return dismissalType ?? 'out';
    return 'not out';
  }

  /// Get dismissal info for scorecard
  String? get dismissalInfo {
    if (!isOut) return null;
    return dismissalType ?? 'out';
  }

  /// Get display string with runs and balls
  String get scoreString => '$runs ($ballsFaced)';

  Batsman copyWith({
    String? name,
    int? runs,
    int? ballsFaced,
    int? fours,
    int? sixes,
    bool? isOut,
    String? dismissalType,
    bool? isOnStrike,
  }) {
    return Batsman(
      name: name ?? this.name,
      runs: runs ?? this.runs,
      ballsFaced: ballsFaced ?? this.ballsFaced,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      isOut: isOut ?? this.isOut,
      dismissalType: dismissalType ?? this.dismissalType,
      isOnStrike: isOnStrike ?? this.isOnStrike,
    );
  }

  /// Add runs and update stats
  Batsman addRuns(int runsScored, bool isFour, bool isSix, bool facedBall) {
    return copyWith(
      runs: runs + runsScored,
      ballsFaced: facedBall ? ballsFaced + 1 : ballsFaced,
      fours: isFour ? fours + 1 : fours,
      sixes: isSix ? sixes + 1 : sixes,
    );
  }

  /// Mark batsman as out
  Batsman markOut(String dismissalType) {
    return copyWith(
      isOut: true,
      dismissalType: dismissalType,
      isOnStrike: false,
    );
  }
}
