/// Application constants and configuration
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8000';

  // Match configuration
  static const int defaultOversPerInnings = 20;
  static const int maxPlayersPerTeam = 11;
  static const int maxOversPerBowler = 4; // For T20
  static const int ballsPerOver = 6;

  // Dismissal types
  static const List<String> dismissalTypes = [
    'Bowled',
    'Caught',
    'LBW',
    'Run Out',
    'Stumped',
    'Hit Wicket',
    'Handled Ball',
    'Obstructing Field',
    'Timed Out',
  ];

  // Default team names
  static const String defaultTeam1 = 'Team A';
  static const String defaultTeam2 = 'Team B';

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI constants
  static const double cardPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 32.0;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Default player names for quick setup
  static const List<String> defaultPlayersTeamA = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Player 5',
    'Player 6',
    'Player 7',
    'Player 8',
    'Player 9',
    'Player 10',
    'Player 11',
  ];

  static const List<String> defaultPlayersTeamB = [
    'Player 12',
    'Player 13',
    'Player 14',
    'Player 15',
    'Player 16',
    'Player 17',
    'Player 18',
    'Player 19',
    'Player 20',
    'Player 21',
    'Player 22',
  ];

  // Scoring button configurations
  static const List<int> runButtons = [0, 1, 2, 3, 4, 6];

  // Match status strings
  static const String statusNotStarted = 'not_started';
  static const String statusFirstInnings = 'first_innings';
  static const String statusSecondInnings = 'second_innings';
  static const String statusCompleted = 'completed';

  // Toss decisions
  static const String tossDecisionBat = 'bat';
  static const String tossDecisionBowl = 'bowl';
}
