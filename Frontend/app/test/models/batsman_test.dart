import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_scoreboard/models/batsman.dart';

void main() {
  group('Batsman', () {
    test('should create batsman with default values', () {
      const batsman = Batsman(name: 'Test Player');

      expect(batsman.name, 'Test Player');
      expect(batsman.runs, 0);
      expect(batsman.ballsFaced, 0);
      expect(batsman.fours, 0);
      expect(batsman.sixes, 0);
      expect(batsman.isOut, false);
      expect(batsman.isOnStrike, false);
      expect(batsman.strikeRate, 0.0);
      expect(batsman.statusString, 'not out');
      expect(batsman.scoreString, '0 (0)');
    });

    test('should calculate strike rate correctly', () {
      const batsman = Batsman(name: 'Test Player', runs: 50, ballsFaced: 40);

      expect(batsman.strikeRate, 125.0);
    });

    test('should handle zero balls faced for strike rate', () {
      const batsman = Batsman(name: 'Test Player', runs: 10, ballsFaced: 0);

      expect(batsman.strikeRate, 0.0);
    });

    test('should add runs correctly', () {
      const batsman = Batsman(name: 'Test Player');

      final updatedBatsman = batsman.addRuns(4, true, false, true);

      expect(updatedBatsman.runs, 4);
      expect(updatedBatsman.ballsFaced, 1);
      expect(updatedBatsman.fours, 1);
      expect(updatedBatsman.sixes, 0);
    });

    test('should add six correctly', () {
      const batsman = Batsman(name: 'Test Player');

      final updatedBatsman = batsman.addRuns(6, false, true, true);

      expect(updatedBatsman.runs, 6);
      expect(updatedBatsman.ballsFaced, 1);
      expect(updatedBatsman.fours, 0);
      expect(updatedBatsman.sixes, 1);
    });

    test('should not increment balls faced for extras', () {
      const batsman = Batsman(name: 'Test Player');

      final updatedBatsman = batsman.addRuns(1, false, false, false);

      expect(updatedBatsman.runs, 1);
      expect(updatedBatsman.ballsFaced, 0);
    });

    test('should mark batsman as out correctly', () {
      const batsman = Batsman(
        name: 'Test Player',
        runs: 25,
        ballsFaced: 20,
        isOnStrike: true,
      );

      final outBatsman = batsman.markOut('Bowled');

      expect(outBatsman.isOut, true);
      expect(outBatsman.dismissalType, 'Bowled');
      expect(outBatsman.isOnStrike, false);
      expect(outBatsman.statusString, 'Bowled');
      expect(outBatsman.runs, 25); // Runs should remain same
    });

    test('should create correct score string', () {
      const batsman = Batsman(name: 'Test Player', runs: 45, ballsFaced: 32);

      expect(batsman.scoreString, '45 (32)');
    });
  });
}
