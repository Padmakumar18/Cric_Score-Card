/// Represents a single ball event in cricket
class BallEvent {
  final int runs;
  final bool isWicket;
  final bool isWide;
  final bool isNoBall;
  final bool isBye;
  final bool isLegBye;
  final String? wicketType;
  final String? dismissedBatsman;
  final DateTime timestamp;

  const BallEvent({
    required this.runs,
    this.isWicket = false,
    this.isWide = false,
    this.isNoBall = false,
    this.isBye = false,
    this.isLegBye = false,
    this.wicketType,
    this.dismissedBatsman,
    required this.timestamp,
  });

  /// Returns true if this ball counts towards the over (not wide/no-ball)
  bool get countsTowardsOver => !isWide && !isNoBall;

  /// Returns the total runs scored from this ball (including extras)
  int get totalRuns {
    int total = runs;
    if (isWide || isNoBall) total += 1; // Extra run for wide/no-ball
    return total;
  }

  /// Returns a display string for this ball
  String get displayString {
    if (isWicket) return 'W';
    if (isWide) return 'Wd';
    if (isNoBall) return 'Nb';
    if (isBye) return 'B$runs';
    if (isLegBye) return 'Lb$runs';
    return runs.toString();
  }

  BallEvent copyWith({
    int? runs,
    bool? isWicket,
    bool? isWide,
    bool? isNoBall,
    bool? isBye,
    bool? isLegBye,
    String? wicketType,
    String? dismissedBatsman,
    DateTime? timestamp,
  }) {
    return BallEvent(
      runs: runs ?? this.runs,
      isWicket: isWicket ?? this.isWicket,
      isWide: isWide ?? this.isWide,
      isNoBall: isNoBall ?? this.isNoBall,
      isBye: isBye ?? this.isBye,
      isLegBye: isLegBye ?? this.isLegBye,
      wicketType: wicketType ?? this.wicketType,
      dismissedBatsman: dismissedBatsman ?? this.dismissedBatsman,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
