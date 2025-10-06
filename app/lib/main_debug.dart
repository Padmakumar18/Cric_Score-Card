import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/match_provider.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(const DebugCricketApp());
}

class DebugCricketApp extends StatelessWidget {
  const DebugCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MatchProvider(),
      child: MaterialApp(
        title: 'Debug Cricket Scoreboard',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const DebugScoreboardScreen(),
      ),
    );
  }
}

class DebugScoreboardScreen extends StatefulWidget {
  const DebugScoreboardScreen({super.key});

  @override
  State<DebugScoreboardScreen> createState() => _DebugScoreboardScreenState();
}

class _DebugScoreboardScreenState extends State<DebugScoreboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize match automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MatchProvider>();
      try {
        provider.createMatch(
          team1: 'Team A',
          team2: 'Team B',
          oversPerInnings: 20,
          tossWinner: 'Team A',
          tossDecision: 'bat',
        );
        provider.startFirstInnings(
          AppConstants.defaultPlayersTeamA,
          AppConstants.defaultPlayersTeamB,
        );
        provider.changeBowler(AppConstants.defaultPlayersTeamB.first);
      } catch (e) {
        debugPrint('Error initializing match: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Cricket Scoreboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MatchProvider>(
        builder: (context, provider, child) {
          final match = provider.currentMatch;
          final innings = match?.currentInnings;

          if (match == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Debug Info
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEBUG INFO',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Match Status: ${match.status}'),
                        Text('Current Innings Exists: ${innings != null}'),
                        if (innings != null) ...[
                          Text('Batting Team: ${innings.battingTeam}'),
                          Text('Bowling Team: ${innings.bowlingTeam}'),
                          Text('Batsmen Count: ${innings.batsmen.length}'),
                          Text('Bowlers Count: ${innings.bowlers.length}'),
                          Text(
                            'Score: ${innings.totalRuns}/${innings.wickets}',
                          ),
                          Text('Overs: ${innings.oversString}'),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Score Display
                if (innings != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            innings.battingTeam,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${innings.totalRuns}/${innings.wickets}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('(${innings.oversString} ov)'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Current Batsmen
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Batsmen',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...innings.batsmen
                              .take(2)
                              .map(
                                (batsman) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      if (batsman.isOnStrike)
                                        const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 16,
                                        ),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(batsman.name)),
                                      Text(
                                        '${batsman.runs} (${batsman.ballsFaced})',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Current Bowler
                  if (innings.currentBowler != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Bowler',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(innings.currentBowler!.name),
                                ),
                                Text(
                                  '${innings.currentBowler!.oversString} ov',
                                ),
                                const SizedBox(width: 8),
                                Text(innings.currentBowler!.figuresString),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Scoring Buttons
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Score Runs',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [0, 1, 2, 3, 4, 6]
                                .map(
                                  (runs) => ElevatedButton(
                                    onPressed: () {
                                      try {
                                        debugPrint('Adding $runs runs');
                                        provider.addBallEvent(runs: runs);
                                        if (runs % 2 == 1) {
                                          provider.switchStrike();
                                        }
                                      } catch (e) {
                                        debugPrint('Error adding runs: $e');
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    },
                                    child: Text(runs.toString()),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
