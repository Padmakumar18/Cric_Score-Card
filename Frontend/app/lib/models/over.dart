import 'ball_event.dart';

/// Represents a cricket over with all balls bowled
class Over {
  final int overNumber;
  final String bowlerName;
  final List<BallEvent> balls;
  final int runsScored;
  final int wickets;

  const Over({
    required this.overNumber,
    required this.bowlerName,
    this.balls = const [],
    this.runsScored = 0,
    this.wickets = 0,
  });

  /// Check if over is complete (6 valid balls)
  bool get isComplete {
    return balls.where((ball) => ball.countsTowardsOver).length >= 6;
  }

  /// Get number of valid balls bowled
  int get validBalls {
    return balls.where((ball) => ball.countsTowardsOver).length;
  }

  /// Check if this is a maiden over (no runs scored)
  bool get isMaiden {
    return isComplete && runsScored == 0;
  }

  /// Get last 6 balls for display
  List<BallEvent> get lastSixBalls {
    return balls.take(6).toList();
  }

  /// Get over summary string (e.g., "1 4 6 W 2 1")
  String get summaryString {
    return balls.map((ball) => ball.displayString).join(' ');
  }

  Over copyWith({
    int? overNumber,
    String? bowlerName,
    List<BallEvent>? balls,
    int? runsScored,
    int? wickets,
  }) {
    return Over(
      overNumber: overNumber ?? this.overNumber,
      bowlerName: bowlerName ?? this.bowlerName,
      balls: balls ?? this.balls,
      runsScored: runsScored ?? this.runsScored,
      wickets: wickets ?? this.wickets,
    );
  }

  /// Add a ball to this over
  Over addBall(BallEvent ball) {
    final newBalls = [...balls, ball];
    return copyWith(
      balls: newBalls,
      runsScored: runsScored + ball.totalRuns,
      wickets: ball.isWicket ? wickets + 1 : wickets,
    );
  }

  /// Remove last ball from over
  Over removeLastBall() {
    if (balls.isEmpty) return this;

    final lastBall = balls.last;
    final newBalls = balls.sublist(0, balls.length - 1);

    return copyWith(
      balls: newBalls,
      runsScored: runsScored - lastBall.totalRuns,
      wickets: lastBall.isWicket ? wickets - 1 : wickets,
    );
  }
}
