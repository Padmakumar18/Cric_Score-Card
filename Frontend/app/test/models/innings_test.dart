import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_scoreboard/models/innings.dart';
import 'package:cricket_scoreboard/models/batsman.dart';
import 'package:cricket_scoreboard/models/bowler.dart';

void main() {
  group('Innings', () {
    test('should create innings with default values', () {
      const innings = Innings(battingTeam: 'Team A', bowlingTeam: 'Team B');

      expect(innings.battingTeam, 'Team A');
      expect(innings.bowlingTeam, 'Team B');
      expect(innings.totalRuns, 0);
      expect(innings.wickets, 0);
      expect(innings.ballsBowled, 0);
      expect(innings.extras, 0);
      expect(innings.target, 0);
      expect(innings.isComplete, false);
      expect(innings.currentOverNumber, 1);
      expect(innings.ballsInCurrentOver, 0);
      expect(innings.oversString, '0.0');
      expect(innings.runRate, 0.0);
      expect(innings.requiredRunRate, 0.0);
      expect(innings.projectedTotal, 0);
    });

    test('should calculate current over number correctly', () {
      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        ballsBowled: 13, // 2.1 overs
      );

      expect(innings.currentOverNumber, 3); // Currently bowling 3rd over
      expect(innings.ballsInCurrentOver, 1);
      expect(innings.oversString, '2.1');
    });

    test('should calculate run rate correctly', () {
      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        totalRuns: 60,
        ballsBowled: 60, // 10 overs
      );

      expect(innings.runRate, 6.0); // 60 runs in 10 overs = 6.0 per over
    });

    test('should calculate required run rate correctly', () {
      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        totalRuns: 80,
        ballsBowled: 60, // 10 overs bowled
        target: 150, // Need 150 to win
      );

      // Need 70 runs in 60 balls (10 overs) = 7.0 per over
      expect(innings.requiredRunRate, 7.0);
    });

    test('should calculate projected total correctly', () {
      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        totalRuns: 60,
        ballsBowled: 60, // 10 overs, so 6 runs per over
      );

      // 6 runs per over for 20 overs = 120
      expect(innings.projectedTotal, 120);
    });

    test('should identify current batsmen correctly', () {
      const batsmen = [
        Batsman(name: 'Player 1', isOnStrike: true),
        Batsman(name: 'Player 2', isOnStrike: false),
        Batsman(name: 'Player 3', isOut: true),
      ];

      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        batsmen: batsmen,
      );

      final currentBatsmen = innings.currentBatsmen;
      expect(currentBatsmen.length, 2);
      expect(currentBatsmen[0].name, 'Player 1');
      expect(currentBatsmen[1].name, 'Player 2');
    });

    test('should identify striker batsman correctly', () {
      const batsmen = [
        Batsman(name: 'Player 1', isOnStrike: true),
        Batsman(name: 'Player 2', isOnStrike: false),
      ];

      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        batsmen: batsmen,
      );

      final striker = innings.strikerBatsman;
      expect(striker?.name, 'Player 1');
      expect(striker?.isOnStrike, true);
    });

    test('should identify non-striker batsman correctly', () {
      const batsmen = [
        Batsman(name: 'Player 1', isOnStrike: true),
        Batsman(name: 'Player 2', isOnStrike: false),
      ];

      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        batsmen: batsmen,
      );

      final nonStriker = innings.nonStrikerBatsman;
      expect(nonStriker?.name, 'Player 2');
      expect(nonStriker?.isOnStrike, false);
    });

    test('should identify current bowler correctly', () {
      const bowlers = [
        Bowler(name: 'Bowler 1', isCurrentBowler: false),
        Bowler(name: 'Bowler 2', isCurrentBowler: true),
      ];

      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        bowlers: bowlers,
      );

      final currentBowler = innings.currentBowler;
      expect(currentBowler?.name, 'Bowler 2');
      expect(currentBowler?.isCurrentBowler, true);
    });

    test('should handle no current bowler', () {
      const innings = Innings(battingTeam: 'Team A', bowlingTeam: 'Team B');

      expect(innings.currentBowler, null);
    });

    test('should handle required run rate when target is 0', () {
      const innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        totalRuns: 80,
        ballsBowled: 60,
        target: 0, // Batting first
      );

      expect(innings.requiredRunRate, 0.0);
    });
  });
}
