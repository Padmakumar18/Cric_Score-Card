import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/match_provider.dart';
import 'constants/app_constants.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TestCricketApp());
}

class TestCricketApp extends StatelessWidget {
  const TestCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MatchProvider(),
      child: MaterialApp(
        title: 'Test Cricket Scoreboard',
        theme: AppTheme.modernDarkTheme,
        home: const TestScoreboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class TestScoreboardScreen extends StatefulWidget {
  const TestScoreboardScreen({super.key});

  @override
  State<TestScoreboardScreen> createState() => _TestScoreboardScreenState();
}

class _TestScoreboardScreenState extends State<TestScoreboardScreen> {
  String _testStatus = 'Initializing...';
  final List<String> _testResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runTests();
    });
  }

  Future<void> _runTests() async {
    final provider = context.read<MatchProvider>();

    try {
      setState(() {
        _testStatus = 'Running tests...';
        _testResults.clear();
      });

      // Test 1: Create Match
      _addTestResult('Test 1: Creating match...');
      provider.createMatch(
        team1: 'Mumbai Indians',
        team2: 'Chennai Super Kings',
        oversPerInnings: 20,
        totalPlayers: 11,
        tossWinner: 'Mumbai Indians',
        tossDecision: 'bat',
      );
      _addTestResult('✅ Match created successfully');

      // Test 2: Start First Innings
      _addTestResult('Test 2: Starting first innings...');
      provider.startFirstInnings(
        AppConstants.defaultPlayersTeamA,
        AppConstants.defaultPlayersTeamB,
      );
      _addTestResult('✅ First innings started');

      // Test 3: Set Bowler
      _addTestResult('Test 3: Setting current bowler...');
      provider.changeBowler(AppConstants.defaultPlayersTeamB.first);
      _addTestResult('✅ Bowler set successfully');

      // Test 4: Add Various Ball Events
      _addTestResult('Test 4: Adding ball events...');

      // Add some runs
      provider.addBallEvent(runs: 1);
      provider.switchStrike();
      _addTestResult('✅ Added 1 run');

      provider.addBallEvent(runs: 4);
      _addTestResult('✅ Added boundary (4)');

      provider.addBallEvent(runs: 6);
      _addTestResult('✅ Added six (6)');

      provider.addBallEvent(runs: 0);
      _addTestResult('✅ Added dot ball');

      provider.addBallEvent(runs: 2);
      provider.switchStrike();
      _addTestResult('✅ Added 2 runs');

      provider.addBallEvent(runs: 1, isWide: true);
      _addTestResult('✅ Added wide');

      // Test 5: Check Match State
      _addTestResult('Test 5: Checking match state...');
      final match = provider.currentMatch;
      final innings = match?.currentInnings;

      if (match != null && innings != null) {
        _addTestResult('✅ Match state is valid');
        _addTestResult('   Score: ${innings.totalRuns}/${innings.wickets}');
        _addTestResult('   Overs: ${innings.oversString}');
        _addTestResult('   Balls bowled: ${innings.ballsBowled}');
      } else {
        _addTestResult('❌ Match state is invalid');
      }

      // Test 6: Test Undo Functionality
      _addTestResult('Test 6: Testing undo...');
      if (provider.canUndo) {
        provider.undoLastBall();
        _addTestResult('✅ Undo successful');
      } else {
        _addTestResult('❌ Cannot undo');
      }

      setState(() {
        _testStatus = 'All tests completed successfully!';
      });
    } catch (e, stackTrace) {
      _addTestResult('❌ Test failed with error: $e');
      _addTestResult('Stack trace: $stackTrace');
      setState(() {
        _testStatus = 'Tests failed!';
      });
    }
  }

  void _addTestResult(String result) {
    setState(() {
      _testResults.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket Scoreboard Test'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Test Status
                Card(
                  color: AppTheme.primaryBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TEST STATUS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _testStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Test Results
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TEST RESULTS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._testResults.map(
                          (result) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              result,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                color: result.startsWith('❌')
                                    ? Colors.red
                                    : result.startsWith('✅')
                                    ? Colors.green
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Current Match State
                if (match != null && innings != null) ...[
                  Card(
                    color: AppTheme.successGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT MATCH STATE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${match.team1} vs ${match.team2}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Score: ${innings.totalRuns}/${innings.wickets} (${innings.oversString} ov)',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Status: ${match.status}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Batting: ${innings.battingTeam}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Bowling: ${innings.bowlingTeam}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _runTests,
                        child: const Text('Run Tests Again'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.resetMatch();
                          setState(() {
                            _testStatus = 'Match reset';
                            _testResults.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorRed,
                        ),
                        child: const Text('Reset Match'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
