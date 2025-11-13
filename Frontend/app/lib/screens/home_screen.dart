import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'match_setup_screen.dart';
import 'scoreboard_screen.dart';

/// Home screen - Quick Match only
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cricket Scoreboard'),
                if (authProvider.isGuest)
                  const Text(
                    'Guest Mode',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
              ],
            );
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  authProvider.logout();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<MatchProvider>(
        builder: (context, matchProvider, child) {
          // If there's a current match, show it
          if (matchProvider.currentMatch != null) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0,
                  ),
                  child: _buildCurrentMatchSection(context, matchProvider),
                ),
              ),
            );
          }

          // Otherwise, show match setup directly
          return const MatchSetupScreen();
        },
      ),
    );
  }

  Widget _buildCurrentMatchSection(
    BuildContext context,
    MatchProvider matchProvider,
  ) {
    final match = matchProvider.currentMatch!;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sports_cricket,
                  color: AppTheme.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Match',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${match.team1} vs ${match.team2}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              match.matchSummary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(match.status.replaceAll('_', ' ').toUpperCase()),
                  backgroundColor: _getStatusColor(match.status),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      _showDeleteMatchDialog(context, matchProvider),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete Match',
                  color: AppTheme.wicketColor,
                ),
                ElevatedButton.icon(
                  onPressed: () => _navigateToScoreboard(context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'not_started':
        return AppTheme.pitchTan;
      case 'first_innings':
      case 'second_innings':
        return AppTheme.accentSaffron;
      case 'completed':
        return AppTheme.successGreen;
      default:
        return AppTheme.pitchTan;
    }
  }

  void _navigateToScoreboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ScoreboardScreen()));
  }

  void _showDeleteMatchDialog(
    BuildContext context,
    MatchProvider matchProvider,
  ) {
    final match = matchProvider.currentMatch;
    if (match == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Match'),
        content: Text(
          'Are you sure you want to delete the match between ${match.team1} and ${match.team2}?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              matchProvider.clearMatch();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Match deleted successfully'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.wicketColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
