import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'match_post_form_screen.dart';

/// Match Browser screen for exploring and posting matches
class MatchBrowserScreen extends StatelessWidget {
  const MatchBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Matches'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Match Card
                _buildPostMatchCard(context),
                const SizedBox(height: 24),

                // Browse Matches Section
                Text(
                  'Available Matches',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildEmptyState(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostMatchCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToPostMatch(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(Icons.post_add, size: 80, color: AppTheme.accentSaffron),
              const SizedBox(height: 16),
              Text(
                'Post a Match',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Find teams to play with • Share match details',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _navigateToPostMatch(context),
                icon: const Icon(Icons.add),
                label: const Text('Post New Match'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: AppTheme.accentSaffron,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No matches available yet',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to post a match and find teams to play with!',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPostMatch(BuildContext context) {
    if (!_checkAuth(context)) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MatchPostFormScreen()),
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
            },
            child: const Text('Login / Sign Up'),
          ),
        ],
      ),
    );
  }
}
