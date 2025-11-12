import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_profile_provider.dart';
import '../models/player_profile.dart';
import '../theme/app_theme.dart';
import 'player_profile_form_screen.dart';

class PlayerProfilesScreen extends StatefulWidget {
  const PlayerProfilesScreen({super.key});

  @override
  State<PlayerProfilesScreen> createState() => _PlayerProfilesScreenState();
}

class _PlayerProfilesScreenState extends State<PlayerProfilesScreen> {
  String _searchQuery = '';
  String _selectedRole = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Player',
            onPressed: () => _navigateToAddPlayer(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Consumer<PlayerProfileProvider>(
              builder: (context, provider, child) {
                var players = provider.players;

                if (_searchQuery.isNotEmpty) {
                  players = provider.searchPlayers(_searchQuery);
                }

                if (_selectedRole != 'All') {
                  players = players
                      .where((p) => p.role == _selectedRole)
                      .toList();
                }

                if (players.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return _buildPlayerCard(context, players[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search players...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Batsman'),
                _buildFilterChip('Bowler'),
                _buildFilterChip('All-rounder'),
                _buildFilterChip('Wicket-keeper'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String role) {
    final isSelected = _selectedRole == role;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(role),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedRole = role;
          });
        },
        selectedColor: AppTheme.successGreen.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, PlayerProfile player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToPlayerDetails(context, player),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getRoleColor(player.role),
                    child: Text(
                      player.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              _getRoleIcon(player.role),
                              size: 16,
                              color: _getRoleColor(player.role),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              player.role,
                              style: TextStyle(
                                color: _getRoleColor(player.role),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _navigateToEditPlayer(context, player),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Matches',
                      player.matchesPlayed.toString(),
                      Icons.sports_cricket,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Runs',
                      player.totalRuns.toString(),
                      Icons.trending_up,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Wickets',
                      player.totalWickets.toString(),
                      Icons.close,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Avg',
                      player.battingAverage.toStringAsFixed(1),
                      Icons.analytics,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.infoBlue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white38
                : Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No players found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first player profile',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddPlayer(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Player'),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Batsman':
        return AppTheme.infoBlue;
      case 'Bowler':
        return AppTheme.errorRed;
      case 'All-rounder':
        return AppTheme.successGreen;
      case 'Wicket-keeper':
        return AppTheme.warningOrange;
      default:
        return AppTheme.infoBlue;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Batsman':
        return Icons.sports_cricket;
      case 'Bowler':
        return Icons.sports;
      case 'All-rounder':
        return Icons.star;
      case 'Wicket-keeper':
        return Icons.sports_baseball;
      default:
        return Icons.person;
    }
  }

  void _navigateToAddPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PlayerProfileFormScreen()),
    );
  }

  void _navigateToEditPlayer(BuildContext context, PlayerProfile player) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerProfileFormScreen(player: player),
      ),
    );
  }

  void _navigateToPlayerDetails(BuildContext context, PlayerProfile player) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PlayerProfileFormScreen(player: player, isViewOnly: true),
      ),
    );
  }
}
