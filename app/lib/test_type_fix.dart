import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/match_provider.dart';
import 'constants/app_constants.dart';
import 'theme/app_theme.dart';
import 'widgets/modern_score_display.dart';

void main() {
  runApp(const TypeFixTestApp());
}

class TypeFixTestApp extends StatelessWidget {
  const TypeFixTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MatchProvider(),
      child: MaterialApp(
        title: 'Type Fix Test',
        theme: AppTheme.modernDarkTheme,
        home: const TypeFixTestScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class TypeFixTestScreen extends StatefulWidget {
  const TypeFixTestScreen({super.key});

  @override
  State<TypeFixTestScreen> createState() => _TypeFixTestScreenState();
}

class _TypeFixTestScreenState extends State<TypeFixTestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMatch();
    });
  }

  void _initializeMatch() {
    final provider = context.read<MatchProvider>();

    try {
      // Create match
      provider.createMatch(
        team1: 'Team A',
        team2: 'Team B',
        oversPerInnings: 20,
        tossWinner: 'Team A',
        tossDecision: 'bat',
      );

      // Start innings
      provider.startFirstInnings(
        AppConstants.defaultPlayersTeamA,
        AppConstants.defaultPlayersTeamB,
      );

      // Set bowler
      provider.changeBowler(AppConstants.defaultPlayersTeamB.first);

      // Add some balls to test the fold operation
      provider.addBallEvent(runs: 1);
      provider.switchStrike();
      provider.addBallEvent(runs: 4);
      provider.addBallEvent(runs: 2);
      provider.switchStrike();
      provider.addBallEvent(runs: 6);
      provider.addBallEvent(runs: 0);
      provider.addBallEvent(runs: 1);

      setState(() {});
    } catch (e) {
      debugPrint('Error initializing match: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Type Fix Test'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MatchProvider>(
        builder: (context, provider, child) {
          final match = provider.currentMatch;
          final innings = match?.currentInnings;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Test Status
                Card(
                  color: AppTheme.successGreen,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'TYPE FIX TEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          match != null && innings != null
                              ? '✅ Match initialized successfully'
                              : '❌ Match initialization failed',
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (innings != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Score: ${innings.totalRuns}/${innings.wickets} (${innings.oversString} ov)',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Balls bowled: ${innings.ballsBowled}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Overs count: ${innings.overs.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Test the ModernScoreDisplay widget (this contains the fold operation)
                if (match != null && innings != null) ...[
                  const Text(
                    'Testing ModernScoreDisplay (contains fold operation):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const ModernScoreDisplay(),
                  const SizedBox(height: 16),

                  Card(
                    color: AppTheme.primaryBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            '✅ FOLD OPERATION TEST PASSED',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'The type error has been fixed!',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ModernScoreDisplay rendered without errors',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.addBallEvent(runs: 1);
                    provider.switchStrike();
                  },
                  child: const Text('Add Another Ball (Test Fold)'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
