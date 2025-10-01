import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import 'match_setup_screen.dart';
import 'scoreboard_screen.dart';
import '../widgets/responsive_layout.dart';

/// Home screen with navigation to different app sections
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket Scoreboard'),
        centerTitle: true,
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _buildContent(context, crossAxisCount: 1);
  }

  Widget _buildTabletLayout(BuildContext context) {
    return _buildContent(context, crossAxisCount: 2);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return _buildContent(context, crossAxisCount: 3);
  }

  Widget _buildContent(BuildContext context, {required int crossAxisCount}) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              _buildWelcomeSection(context),
              const SizedBox(height: 32),

              // Current match status
              if (matchProvider.currentMatch != null) ...[
                _buildCurrentMatchSection(context, matchProvider),
                const SizedBox(height: 32),
              ],

              // Action buttons
              Expanded(
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildActionCard(
                      context,
                      title: 'New Match',
                      subtitle: 'Start a new cricket match',
                      icon: Icons.sports_cricket,
                      color: AppTheme.primaryGreen,
                      onTap: () => _navigateToMatchSetup(context),
                    ),
                    if (matchProvider.currentMatch != null)
                      _buildActionCard(
                        context,
                        title: 'Continue Match',
                        subtitle: 'Resume current match',
                        icon: Icons.play_arrow,
                        color: AppTheme.accentSaffron,
                        onTap: () => _navigateToScoreboard(context),
                      ),
                    _buildActionCard(
                      context,
                      title: 'Match History',
                      subtitle: 'View past matches',
                      icon: Icons.history,
                      color: AppTheme.lightGreen,
                      onTap: () => _showComingSoon(context),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Settings',
                      subtitle: 'App preferences',
                      icon: Icons.settings,
                      color: AppTheme.darkBrown,
                      onTap: () => _showComingSoon(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Cricket Scoreboard',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your cricket matches with professional scoring',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCurrentMatchSection(
    BuildContext context,
    MatchProvider matchProvider,
  ) {
    final match = matchProvider.currentMatch!;

    return Card(
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
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(match.status.replaceAll('_', ' ').toUpperCase()),
                  backgroundColor: _getStatusColor(match.status),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _navigateToScoreboard(context),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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

  void _navigateToMatchSetup(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const MatchSetupScreen()));
  }

  void _navigateToScoreboard(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ScoreboardScreen()));
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
