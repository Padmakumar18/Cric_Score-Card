import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_scoreboard/models/ball_event.dart';

void main() {
  group('BallEvent', () {
    test('should create a normal ball event correctly', () {
      final ball = BallEvent(runs: 4, timestamp: DateTime.now());

      expect(ball.runs, 4);
      expect(ball.isWicket, false);
      expect(ball.isWide, false);
      expect(ball.isNoBall, false);
      expect(ball.countsTowardsOver, true);
      expect(ball.totalRuns, 4);
      expect(ball.displayString, '4');
    });

    test('should handle wide ball correctly', () {
      final ball = BallEvent(runs: 0, isWide: true, timestamp: DateTime.now());

      expect(ball.countsTowardsOver, false);
      expect(ball.totalRuns, 1); // Wide adds 1 extra run
      expect(ball.displayString, 'Wd');
    });

    test('should handle no ball correctly', () {
      final ball = BallEvent(
        runs: 2,
        isNoBall: true,
        timestamp: DateTime.now(),
      );

      expect(ball.countsTowardsOver, false);
      expect(ball.totalRuns, 3); // 2 runs + 1 no ball penalty
      expect(ball.displayString, 'Nb');
    });

    test('should handle wicket correctly', () {
      final ball = BallEvent(
        runs: 0,
        isWicket: true,
        wicketType: 'Bowled',
        timestamp: DateTime.now(),
      );

      expect(ball.isWicket, true);
      expect(ball.wicketType, 'Bowled');
      expect(ball.displayString, 'W');
    });

    test('should handle bye correctly', () {
      final ball = BallEvent(runs: 2, isBye: true, timestamp: DateTime.now());

      expect(ball.isBye, true);
      expect(ball.totalRuns, 2);
      expect(ball.displayString, 'B2');
    });

    test('should handle leg bye correctly', () {
      final ball = BallEvent(
        runs: 1,
        isLegBye: true,
        timestamp: DateTime.now(),
      );

      expect(ball.isLegBye, true);
      expect(ball.totalRuns, 1);
      expect(ball.displayString, 'Lb1');
    });
  });
}
