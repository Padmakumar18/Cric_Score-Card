import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_profile_provider.dart';
import '../models/player_profile.dart';
import '../theme/app_theme.dart';

class PlayerProfileFormScreen extends StatefulWidget {
  final PlayerProfile? player;
  final bool isViewOnly;

  const PlayerProfileFormScreen({
    super.key,
    this.player,
    this.isViewOnly = false,
  });

  @override
  State<PlayerProfileFormScreen> createState() =>
      _PlayerProfileFormScreenState();
}

class _PlayerProfileFormScreenState extends State<PlayerProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _teamController;
  late TextEditingController _nationalityController;
  late TextEditingController _matchesController;
  late TextEditingController _runsController;
  late TextEditingController _wicketsController;
  late TextEditingController _battingAvgController;
  late TextEditingController _bowlingAvgController;
  late TextEditingController _centuriesController;
  late TextEditingController _halfCenturiesController;
  late TextEditingController _fiveWicketsController;
  late TextEditingController _highestScoreController;
  late TextEditingController _bestBowlingController;
  late TextEditingController _notesController;

  String _selectedRole = 'Batsman';
  String _selectedBattingStyle = 'Right-hand';
  String _selectedBowlingStyle = 'Right-arm medium';
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    final player = widget.player;
    _nameController = TextEditingController(text: player?.name ?? '');
    _teamController = TextEditingController(text: player?.team ?? '');
    _nationalityController = TextEditingController(
      text: player?.nationality ?? '',
    );
    _matchesController = TextEditingController(
      text: player?.matchesPlayed.toString() ?? '0',
    );
    _runsController = TextEditingController(
      text: player?.totalRuns.toString() ?? '0',
    );
    _wicketsController = TextEditingController(
      text: player?.totalWickets.toString() ?? '0',
    );
    _battingAvgController = TextEditingController(
      text: player?.battingAverage.toString() ?? '0.0',
    );
    _bowlingAvgController = TextEditingController(
      text: player?.bowlingAverage.toString() ?? '0.0',
    );
    _centuriesController = TextEditingController(
      text: player?.centuries.toString() ?? '0',
    );
    _halfCenturiesController = TextEditingController(
      text: player?.halfCenturies.toString() ?? '0',
    );
    _fiveWicketsController = TextEditingController(
      text: player?.fiveWicketHauls.toString() ?? '0',
    );
    _highestScoreController = TextEditingController(
      text: player?.highestScore.toString() ?? '0',
    );
    _bestBowlingController = TextEditingController(
      text: player?.bestBowling ?? '',
    );
    _notesController = TextEditingController(text: player?.notes ?? '');

    if (player != null) {
      _selectedRole = player.role;
      _selectedBattingStyle = player.battingStyle;
      _selectedBowlingStyle = player.bowlingStyle;
      _dateOfBirth = player.dateOfBirth;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teamController.dispose();
    _nationalityController.dispose();
    _matchesController.dispose();
    _runsController.dispose();
    _wicketsController.dispose();
    _battingAvgController.dispose();
    _bowlingAvgController.dispose();
    _centuriesController.dispose();
    _halfCenturiesController.dispose();
    _fiveWicketsController.dispose();
    _highestScoreController.dispose();
    _bestBowlingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isViewOnly
              ? 'Player Details'
              : widget.player == null
              ? 'Add Player'
              : 'Edit Player',
        ),
        actions: widget.isViewOnly
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _savePlayer,
                ),
              ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildStylesSection(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
            const SizedBox(height: 24),
            _buildNotesSection(),
            if (!widget.isViewOnly) ...[
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
            if (widget.player != null && !widget.isViewOnly) ...[
              const SizedBox(height: 12),
              _buildDeleteButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Player Name *',
                prefixIcon: Icon(Icons.person),
              ),
              enabled: !widget.isViewOnly,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter player name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role *',
                prefixIcon: Icon(Icons.sports_cricket),
              ),
              items: ['Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper']
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
              onChanged: widget.isViewOnly
                  ? null
                  : (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _teamController,
              decoration: const InputDecoration(
                labelText: 'Team',
                prefixIcon: Icon(Icons.groups),
              ),
              enabled: !widget.isViewOnly,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nationalityController,
              decoration: const InputDecoration(
                labelText: 'Nationality',
                prefixIcon: Icon(Icons.flag),
              ),
              enabled: !widget.isViewOnly,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cake),
              title: Text(
                _dateOfBirth == null
                    ? 'Date of Birth'
                    : 'DOB: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
              ),
              trailing: widget.isViewOnly
                  ? null
                  : const Icon(Icons.calendar_today),
              onTap: widget.isViewOnly ? null : _selectDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStylesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Playing Style',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBattingStyle,
              decoration: const InputDecoration(
                labelText: 'Batting Style',
                prefixIcon: Icon(Icons.sports_cricket),
              ),
              items: ['Right-hand', 'Left-hand']
                  .map(
                    (style) =>
                        DropdownMenuItem(value: style, child: Text(style)),
                  )
                  .toList(),
              onChanged: widget.isViewOnly
                  ? null
                  : (value) {
                      setState(() {
                        _selectedBattingStyle = value!;
                      });
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBowlingStyle,
              decoration: const InputDecoration(
                labelText: 'Bowling Style',
                prefixIcon: Icon(Icons.sports),
              ),
              items:
                  [
                        'Right-arm fast',
                        'Right-arm medium',
                        'Right-arm spin',
                        'Left-arm fast',
                        'Left-arm medium',
                        'Left-arm spin',
                      ]
                      .map(
                        (style) =>
                            DropdownMenuItem(value: style, child: Text(style)),
                      )
                      .toList(),
              onChanged: widget.isViewOnly
                  ? null
                  : (value) {
                      setState(() {
                        _selectedBowlingStyle = value!;
                      });
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Career Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _matchesController,
                    decoration: const InputDecoration(
                      labelText: 'Matches',
                      prefixIcon: Icon(Icons.sports_cricket),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _runsController,
                    decoration: const InputDecoration(
                      labelText: 'Total Runs',
                      prefixIcon: Icon(Icons.trending_up),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _wicketsController,
                    decoration: const InputDecoration(
                      labelText: 'Wickets',
                      prefixIcon: Icon(Icons.close),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _battingAvgController,
                    decoration: const InputDecoration(
                      labelText: 'Bat Avg',
                      prefixIcon: Icon(Icons.analytics),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _centuriesController,
                    decoration: const InputDecoration(
                      labelText: '100s',
                      prefixIcon: Icon(Icons.star),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _halfCenturiesController,
                    decoration: const InputDecoration(
                      labelText: '50s',
                      prefixIcon: Icon(Icons.star_half),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _highestScoreController,
                    decoration: const InputDecoration(
                      labelText: 'Highest Score',
                      prefixIcon: Icon(Icons.emoji_events),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _fiveWicketsController,
                    decoration: const InputDecoration(
                      labelText: '5 Wickets',
                      prefixIcon: Icon(Icons.military_tech),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !widget.isViewOnly,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bestBowlingController,
              decoration: const InputDecoration(
                labelText: 'Best Bowling (e.g., 5/23)',
                prefixIcon: Icon(Icons.sports),
              ),
              enabled: !widget.isViewOnly,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Notes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional information...',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 4,
              enabled: !widget.isViewOnly,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _savePlayer,
      icon: const Icon(Icons.save),
      label: Text(widget.player == null ? 'Add Player' : 'Update Player'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return OutlinedButton.icon(
      onPressed: _deletePlayer,
      icon: const Icon(Icons.delete),
      label: const Text('Delete Player'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.errorRed,
        side: const BorderSide(color: AppTheme.errorRed),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _savePlayer() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<PlayerProfileProvider>();
      final player = PlayerProfile(
        id:
            widget.player?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        role: _selectedRole,
        battingStyle: _selectedBattingStyle,
        bowlingStyle: _selectedBowlingStyle,
        dateOfBirth: _dateOfBirth,
        team: _teamController.text.trim().isEmpty
            ? null
            : _teamController.text.trim(),
        nationality: _nationalityController.text.trim().isEmpty
            ? null
            : _nationalityController.text.trim(),
        matchesPlayed: int.tryParse(_matchesController.text) ?? 0,
        totalRuns: int.tryParse(_runsController.text) ?? 0,
        totalWickets: int.tryParse(_wicketsController.text) ?? 0,
        battingAverage: double.tryParse(_battingAvgController.text) ?? 0.0,
        bowlingAverage: double.tryParse(_bowlingAvgController.text) ?? 0.0,
        centuries: int.tryParse(_centuriesController.text) ?? 0,
        halfCenturies: int.tryParse(_halfCenturiesController.text) ?? 0,
        fiveWicketHauls: int.tryParse(_fiveWicketsController.text) ?? 0,
        highestScore: int.tryParse(_highestScoreController.text) ?? 0,
        bestBowling: _bestBowlingController.text.trim().isEmpty
            ? null
            : _bestBowlingController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: widget.player?.createdAt,
      );

      if (widget.player == null) {
        provider.addPlayer(player);
      } else {
        provider.updatePlayer(player);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.player == null
                ? 'Player added successfully'
                : 'Player updated successfully',
          ),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  void _deletePlayer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Player'),
        content: Text(
          'Are you sure you want to delete ${widget.player!.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PlayerProfileProvider>().deletePlayer(
                widget.player!.id,
              );
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Player deleted successfully'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
