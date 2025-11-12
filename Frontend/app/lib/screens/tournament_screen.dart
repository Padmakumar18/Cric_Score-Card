import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tournament_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'tournament_create_screen.dart';
import 'tournament_dashboard_screen.dart';
import 'auth_screen.dart';

/// Tournament screen for managing tournaments
class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournaments'), centerTitle: true),
      body: Consumer<TournamentProvider>(
        builder: (context, tournamentProvider, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Tournament
                    if (tournamentProvider.currentTournament != null) ...[
                      _buildCurrentTournamentSection(
                        context,
                        tournamentProvider,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Create Tournament Card
                    _buildCreateTournamentCard(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentTournamentSection(
    BuildContext context,
    TournamentProvider tournamentProvider,
  ) {
    final tournament = tournamentProvider.currentTournament!;

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
                  Icons.emoji_events,
                  color: AppTheme.successGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'My Tournament',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.successGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tournament.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '${tournament.teams.length} teams • ${tournament.matches.length} matches',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _navigateToTournamentDashboard(context),
              icon: const Icon(Icons.leaderboard),
              label: const Text('View Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateTournamentCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToTournamentCreate(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(Icons.emoji_events, size: 80, color: AppTheme.successGreen),
              const SizedBox(height: 16),
              Text(
                'Create Tournament',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Multi-team tournament with fixtures and points table',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _navigateToTournamentCreate(context),
                icon: const Icon(Icons.add),
                label: const Text('Create New Tournament'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: AppTheme.successGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTournamentCreate(BuildContext context) {
    if (!_checkAuth(context)) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TournamentCreateScreen()),
    );
  }

  void _navigateToTournamentDashboard(BuildContext context) {
    if (!_checkAuth(context)) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TournamentDashboardScreen(),
      ),
    );
  }

  bool _checkAuth(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isGuest) {
      _showAuthRequiredDialog(context);
      return false;
    }
    return true;
  }

  void _showAuthRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text(
          'This feature is only available for registered users. Please create an account or login to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            child: const Text('Login / Sign Up'),
          ),
        ],
      ),
    );
  }
}
