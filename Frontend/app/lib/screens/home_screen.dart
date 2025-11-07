import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/tournament_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'match_setup_screen.dart';
import 'scoreboard_screen.dart';
import 'tournament_create_screen.dart';
import 'tournament_dashboard_screen.dart';
import 'settings_screen.dart';
import 'user_profile_screen.dart';
import 'auth_screen.dart';
import '../widgets/responsive_layout.dart';

/// Home screen with navigation to different app sections
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
                  Text(
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
              return PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle),
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'user',
                    enabled: false,
                    child: Text(authProvider.currentUser?.name ?? 'User'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    authProvider.logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  }
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
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
              // _buildWelcomeSection(context),
              // const SizedBox(height: 32),

              // Current match status
              if (matchProvider.currentMatch != null) ...[
                _buildCurrentMatchSection(context, matchProvider),
                const SizedBox(height: 32),
              ],

              // Action buttons
              Expanded(
                child: Consumer<TournamentProvider>(
                  builder: (context, tournamentProvider, child) {
                    final cards = <Widget>[
                      _buildActionCard(
                        context,
                        title: 'Quick Match',
                        subtitle: '2 teams • Single match',
                        icon: Icons.sports_cricket,
                        color: AppTheme.primaryGreen,
                        onTap: () => _navigateToMatchSetup(context),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Create Tournament',
                        subtitle: 'Multi-team tournament with fixtures',
                        icon: Icons.emoji_events,
                        color: AppTheme.successGreen,
                        onTap: () => _navigateToTournamentCreate(context),
                      ),
                    ];

                    if (tournamentProvider.currentTournament != null) {
                      cards.add(
                        _buildActionCard(
                          context,
                          title: 'My Tournament',
                          subtitle: 'Fixtures • Points Table • Matches',
                          icon: Icons.leaderboard,
                          color: AppTheme.warningOrange,
                          onTap: () => _navigateToTournamentDashboard(context),
                        ),
                      );
                    }

                    if (matchProvider.currentMatch != null) {
                      cards.add(
                        _buildActionCard(
                          context,
                          title: 'Continue Match',
                          subtitle: 'Resume ongoing match',
                          icon: Icons.play_arrow,
                          color: AppTheme.accentSaffron,
                          onTap: () => _navigateToScoreboard(context),
                        ),
                      );
                    }

                    cards.add(
                      _buildActionCard(
                        context,
                        title: 'My Profile',
                        subtitle: 'Personal details & preferences',
                        icon: Icons.person,
                        color: AppTheme.infoBlue,
                        onTap: () => _navigateToUserProfile(context),
                      ),
                    );

                    cards.add(
                      _buildActionCard(
                        context,
                        title: 'Settings',
                        subtitle: 'App preferences',
                        icon: Icons.settings,
                        color: AppTheme.darkBrown,
                        onTap: () => _navigateToSettings(context),
                      ),
                    );

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: cards,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
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

  void _navigateToTournamentCreate(BuildContext context) {
    if (!_checkAuth(context, 'tournament')) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TournamentCreateScreen()),
    );
  }

  void _navigateToTournamentDashboard(BuildContext context) {
    if (!_checkAuth(context, 'tournament')) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TournamentDashboardScreen(),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  void _navigateToUserProfile(BuildContext context) {
    if (!_checkAuth(context, 'profile')) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const UserProfileScreen()));
  }

  bool _checkAuth(BuildContext context, String feature) {
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
