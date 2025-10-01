import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_scoreboard/models/bowler.dart';

void main() {
  group('Bowler', () {
    test('should create bowler with default values', () {
      const bowler = Bowler(name: 'Test Bowler');

      expect(bowler.name, 'Test Bowler');
      expect(bowler.ballsBowled, 0);
      expect(bowler.runsConceded, 0);
      expect(bowler.wickets, 0);
      expect(bowler.maidens, 0);
      expect(bowler.isCurrentBowler, false);
      expect(bowler.oversString, '0');
      expect(bowler.overs, 0.0);
      expect(bowler.economyRate, 0.0);
      expect(bowler.figuresString, '0/0');
    });

    test('should calculate overs string correctly for complete overs', () {
      const bowler = Bowler(
        name: 'Test Bowler',
        ballsBowled: 12, // 2 complete overs
      );

      expect(bowler.oversString, '2');
      expect(bowler.overs, 2.0);
    });

    test('should calculate overs string correctly for partial overs', () {
      const bowler = Bowler(
        name: 'Test Bowler',
        ballsBowled: 14, // 2.2 overs
      );

      expect(bowler.oversString, '2.2');
      expect(bowler.overs, closeTo(2.33, 0.01));
    });

    test('should calculate economy rate correctly', () {
      const bowler = Bowler(
        name: 'Test Bowler',
        ballsBowled: 12, // 2 overs
        runsConceded: 15,
      );

      expect(bowler.economyRate, 7.5); // 15 runs in 2 overs = 7.5 per over
    });

    test('should handle zero balls for economy rate', () {
      const bowler = Bowler(
        name: 'Test Bowler',
        ballsBowled: 0,
        runsConceded: 0,
      );

      expect(bowler.economyRate, 0.0);
    });

    test('should add ball correctly', () {
      const bowler = Bowler(name: 'Test Bowler');

      final updatedBowler = bowler.addBall(4, false);

      expect(updatedBowler.ballsBowled, 1);
      expect(updatedBowler.runsConceded, 4);
      expect(updatedBowler.wickets, 0);
    });

    test('should add wicket ball correctly', () {
      const bowler = Bowler(name: 'Test Bowler');

      final updatedBowler = bowler.addBall(0, true);

      expect(updatedBowler.ballsBowled, 1);
      expect(updatedBowler.runsConceded, 0);
      expect(updatedBowler.wickets, 1);
    });

    test('should add maiden correctly', () {
      const bowler = Bowler(name: 'Test Bowler');

      final updatedBowler = bowler.addMaiden();

      expect(updatedBowler.maidens, 1);
    });

    test('should create correct figures string', () {
      const bowler = Bowler(name: 'Test Bowler', wickets: 3, runsConceded: 25);

      expect(bowler.figuresString, '3/25');
    });

    test('should check if bowler can bowl next over in T20', () {
      const bowler = Bowler(
        name: 'Test Bowler',
        ballsBowled: 18, // 3 overs
      );

      expect(bowler.canBowlNextOver(20), true); // Can bowl 4 overs in T20

      const maxedBowler = Bowler(
        name: 'Test Bowler',
        ballsBowled: 24, // 4 overs
      );

      expect(maxedBowler.canBowlNextOver(20), false); // Cannot bowl more than 4
    });
  });
}
