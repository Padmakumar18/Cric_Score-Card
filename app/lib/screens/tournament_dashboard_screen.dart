import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tournament_provider.dart';
import '../providers/match_provider.dart';
import '../models/tournament.dart';
import '../theme/app_theme.dart';
import 'player_setup_screen.dart';

class TournamentDashboardScreen extends StatelessWidget {
  const TournamentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Tournament Info',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'All tournament matches, fixtures, and standings are managed here',
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TournamentProvider>(
        builder: (context, provider, child) {
          final tournament = provider.currentTournament;
          if (tournament == null) {
            return const Center(child: Text('No tournament selected'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(context, tournament),
              const SizedBox(height: 24),
              _buildNextMatch(context, provider),
              const SizedBox(height: 24),
              _buildPointsTable(context, tournament),
              const SizedBox(height: 24),
              _buildPastMatches(context, provider),
              const SizedBox(height: 24),
              _buildFixtures(context, tournament),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Tournament tournament) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.emoji_events,
              size: 32,
              color: AppTheme.successGreen,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '${tournament.teams.length} Teams • ${tournament.format == TournamentFormat.roundRobin ? "Round Robin" : "Knockout"}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsTable(BuildContext context, Tournament tournament) {
    final sortedTeams = tournament.standings.values.toList()
      ..sort((a, b) => b.points.compareTo(a.points));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Points Table', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Theme.of(context).dividerColor),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkSurface
                        : Colors.grey.shade200,
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Team',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'P',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'W',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'L',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Pts',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...sortedTeams.map(
                  (stats) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(stats.teamName),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          stats.played.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          stats.won.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          stats.lost.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          stats.points.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextMatch(BuildContext context, TournamentProvider provider) {
    final nextMatch = provider.nextMatch;
    if (nextMatch == null) {
      return Card(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: AppTheme.successGreen),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'All matches completed!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle, color: AppTheme.infoBlue),
                const SizedBox(width: 8),
                Text(
                  'Next Match',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.infoBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.infoBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          nextMatch.team1,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          nextMatch.team2,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Start tournament match
                      provider.startTournamentMatch(nextMatch.id);

                      // Create match with tournament teams
                      final matchProvider = context.read<MatchProvider>();
                      matchProvider.createMatch(
                        team1: nextMatch.team1,
                        team2: nextMatch.team2,
                        oversPerInnings: 20,
                        totalPlayers: 11,
                        tossWinner: nextMatch.team1,
                        tossDecision: 'bat',
                      );

                      // Navigate to player setup with team names
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlayerSetupScreen(
                            battingTeam: nextMatch.team1,
                            bowlingTeam: nextMatch.team2,
                          ),
                        ),
                      );

                      // After match completes, check if we need to update tournament
                      if (matchProvider.currentMatch?.result != null) {
                        final result = matchProvider.currentMatch!.result!;
                        final winner = result.contains(nextMatch.team1)
                            ? nextMatch.team1
                            : nextMatch.team2;
                        final team1Score =
                            matchProvider
                                .currentMatch!
                                .firstInnings
                                ?.totalRuns ??
                            0;
                        final team2Score =
                            matchProvider
                                .currentMatch!
                                .secondInnings
                                ?.totalRuns ??
                            0;

                        provider.updateMatchResult(
                          matchId: nextMatch.id,
                          winner: winner,
                          team1Score: team1Score,
                          team2Score: team2Score,
                        );
                      }

                      provider.clearTournamentMatch();
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Match'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastMatches(BuildContext context, TournamentProvider provider) {
    final completedMatches = provider.completedMatches;
    if (completedMatches.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: AppTheme.warningOrange),
                const SizedBox(width: 8),
                Text(
                  'Past Matches (${completedMatches.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...completedMatches.reversed.map(
              (match) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.05),
                  border: Border.all(
                    color: AppTheme.successGreen.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.team1,
                            style: TextStyle(
                              fontWeight: match.winner == match.team1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          '${match.team1Score} - ${match.team2Score}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            match.team2,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: match.winner == match.team2
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 14,
                          color: AppTheme.successGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Winner: ${match.winner}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixtures(BuildContext context, Tournament tournament) {
    final upcomingMatches = tournament.matches
        .where((m) => !m.isComplete)
        .toList();
    if (upcomingMatches.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Fixtures (${upcomingMatches.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...upcomingMatches.map(
              (match) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(match.team1)),
                    const Text(
                      'vs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(match.team2, textAlign: TextAlign.right),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
