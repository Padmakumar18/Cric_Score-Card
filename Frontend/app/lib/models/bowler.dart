/// Represents a bowler's statistics
class Bowler {
  final String name;
  final int ballsBowled;
  final int runsConceded;
  final int wickets;
  final int maidens;
  final bool isCurrentBowler;

  const Bowler({
    required this.name,
    this.ballsBowled = 0,
    this.runsConceded = 0,
    this.wickets = 0,
    this.maidens = 0,
    this.isCurrentBowler = false,
  });

  /// Get overs bowled as a string (e.g., "3.2")
  String get oversString {
    final completeOvers = ballsBowled ~/ 6;
    final remainingBalls = ballsBowled % 6;
    if (remainingBalls == 0) {
      return completeOvers.toString();
    }
    return '$completeOvers.$remainingBalls';
  }

  /// Get overs as double (e.g., 3.33 for 3.2 overs)
  double get overs {
    final completeOvers = ballsBowled ~/ 6;
    final remainingBalls = ballsBowled % 6;
    return completeOvers + (remainingBalls / 6);
  }

  /// Calculate economy rate (runs per over)
  double get economyRate {
    if (ballsBowled == 0) return 0.0;
    return (runsConceded / ballsBowled) * 6;
  }

  /// Get bowling figures string (e.g., "2/25")
  String get figuresString => '$wickets/$runsConceded';

  /// Check if bowler can bowl next over (not more than 4 overs in T20)
  bool canBowlNextOver(int totalOvers) {
    final maxOversPerBowler = (totalOvers / 5).ceil(); // 20% of total overs
    return (ballsBowled ~/ 6) < maxOversPerBowler;
  }

  Bowler copyWith({
    String? name,
    int? ballsBowled,
    int? runsConceded,
    int? wickets,
    int? maidens,
    bool? isCurrentBowler,
  }) {
    return Bowler(
      name: name ?? this.name,
      ballsBowled: ballsBowled ?? this.ballsBowled,
      runsConceded: runsConceded ?? this.runsConceded,
      wickets: wickets ?? this.wickets,
      maidens: maidens ?? this.maidens,
      isCurrentBowler: isCurrentBowler ?? this.isCurrentBowler,
    );
  }

  /// Add a ball to bowler's stats
  Bowler addBall(int runs, bool isWicket) {
    return copyWith(
      ballsBowled: ballsBowled + 1,
      runsConceded: runsConceded + runs,
      wickets: isWicket ? wickets + 1 : wickets,
    );
  }

  /// Add maiden over
  Bowler addMaiden() {
    return copyWith(maidens: maidens + 1);
  }
}
