import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/match_provider.dart';
import '../providers/tournament_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'user_profile_screen.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0,
            ),
            children: [
              _buildProfileSection(context),
              const SizedBox(height: 24),
              _buildThemeSection(context),
              const SizedBox(height: 24),
              _buildMatchSettingsSection(context),
              const SizedBox(height: 24),
              _buildDataSection(context),
              const SizedBox(height: 24),
              _buildAboutSection(context),
              const SizedBox(height: 24),
              _buildLogoutSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: AppTheme.infoBlue, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryGreen,
                    child: Text(
                      authProvider.currentUser?.name
                              .substring(0, 1)
                              .toUpperCase() ??
                          'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(authProvider.currentUser?.name ?? 'User'),
                  subtitle: Text(
                    authProvider.isGuest
                        ? 'Guest User'
                        : authProvider.currentUser?.email ?? '',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: authProvider.isGuest
                      ? () => _showAuthRequiredDialog(context)
                      : () => _navigateToProfile(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: AppTheme.infoBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Appearance',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: Text(
                        themeProvider.isDarkMode
                            ? 'Black & Green theme'
                            : 'Light Blue & White theme',
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      secondary: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: AppTheme.infoBlue,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchSettingsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sports_cricket,
                  color: AppTheme.successGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Match Settings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Default Overs'),
              subtitle: const Text('20 overs per innings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showComingSoonSnackbar(context, 'Default overs configuration');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Default Players'),
              subtitle: const Text('11 players per team'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showComingSoonSnackbar(
                  context,
                  'Default players configuration',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: AppTheme.warningOrange, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Data Management',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer2<MatchProvider, TournamentProvider>(
              builder: (context, matchProvider, tournamentProvider, child) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.errorRed,
                      ),
                      title: const Text('Clear Current Match'),
                      subtitle: Text(
                        matchProvider.currentMatch != null
                            ? 'Remove ongoing match data'
                            : 'No active match',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      enabled: matchProvider.currentMatch != null,
                      onTap: matchProvider.currentMatch != null
                          ? () => _showClearMatchDialog(context, matchProvider)
                          : null,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_sweep,
                        color: AppTheme.errorRed,
                      ),
                      title: const Text('Clear All Tournaments'),
                      subtitle: Text(
                        tournamentProvider.tournaments.isNotEmpty
                            ? '${tournamentProvider.tournaments.length} tournament(s)'
                            : 'No tournaments',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      enabled: tournamentProvider.tournaments.isNotEmpty,
                      onTap: tournamentProvider.tournaments.isNotEmpty
                          ? () => _showClearTournamentsDialog(
                              context,
                              tournamentProvider,
                            )
                          : null,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: AppTheme.infoBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'About',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.sports_cricket),
              title: const Text('Cricket Scoreboard'),
              subtitle: const Text('Version 1.0.0'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Description'),
              subtitle: const Text(
                'A complete Cricket Scoreboard Flutter application with live scoring, statistics, and match management.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showClearMatchDialog(BuildContext context, MatchProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Current Match'),
        content: const Text(
          'Are you sure you want to clear the current match? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearMatch();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Match cleared successfully'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearTournamentsDialog(
    BuildContext context,
    TournamentProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tournaments'),
        content: Text(
          'Are you sure you want to delete all ${provider.tournaments.length} tournament(s)? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final count = provider.tournaments.length;
              for (var tournament in provider.tournaments.toList()) {
                provider.deleteTournament(tournament.id);
              }
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count tournament(s) cleared successfully'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorRed),
              title: const Text('Logout'),
              subtitle: const Text('Sign out of your account'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLogoutDialog(context, authProvider),
            ),
          ),
        );
      },
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const UserProfileScreen()));
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

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
