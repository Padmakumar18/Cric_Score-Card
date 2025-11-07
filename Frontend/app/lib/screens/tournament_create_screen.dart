import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tournament_provider.dart';
import '../models/tournament.dart';
import '../theme/app_theme.dart';

class TournamentCreateScreen extends StatefulWidget {
  const TournamentCreateScreen({super.key});

  @override
  State<TournamentCreateScreen> createState() => _TournamentCreateScreenState();
}

class _TournamentCreateScreenState extends State<TournamentCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<TextEditingController> _teamControllers = [];
  int _numberOfTeams = 4;
  TournamentFormat _format = TournamentFormat.roundRobin;
  bool _shuffleTeams = false;

  @override
  void initState() {
    super.initState();
    _initializeTeamControllers();
  }

  void _initializeTeamControllers() {
    _teamControllers.clear();
    for (var i = 0; i < _numberOfTeams; i++) {
      _teamControllers.add(TextEditingController(text: 'Team ${i + 1}'));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _createTournament() {
    if (_formKey.currentState!.validate()) {
      final teams = _teamControllers.map((c) => c.text.trim()).toList();

      context.read<TournamentProvider>().createTournament(
        name: _nameController.text.trim(),
        teams: teams,
        format: _format,
        shuffleTeams: _shuffleTeams,
      );

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tournament "${_nameController.text}" created!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Tournament')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.infoBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.infoBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: AppTheme.infoBlue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tournament includes: Auto-generated fixtures, points table, and match tracking',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tournament Name',
                prefixIcon: Icon(Icons.emoji_events),
              ),
              validator: (value) => value?.trim().isEmpty ?? true
                  ? 'Enter tournament name'
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              'Number of Teams: $_numberOfTeams',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _numberOfTeams.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              label: _numberOfTeams.toString(),
              onChanged: (value) {
                setState(() {
                  _numberOfTeams = value.toInt();
                  _initializeTeamControllers();
                });
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Tournament Format',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<TournamentFormat>(
              segments: const [
                ButtonSegment(
                  value: TournamentFormat.roundRobin,
                  label: Text('Round Robin'),
                  icon: Icon(Icons.repeat),
                ),
                ButtonSegment(
                  value: TournamentFormat.knockout,
                  label: Text('Knockout'),
                  icon: Icon(Icons.sports_kabaddi),
                ),
              ],
              selected: {_format},
              onSelectionChanged: (Set<TournamentFormat> newSelection) {
                setState(() => _format = newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            Text('Team Names', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Auto-shuffle teams'),
              subtitle: const Text('Randomly arrange teams for fixtures'),
              value: _shuffleTeams,
              onChanged: (value) {
                setState(() => _shuffleTeams = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 12),
            ..._teamControllers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: 'Team ${entry.key + 1}',
                    prefixIcon: const Icon(Icons.groups),
                  ),
                  validator: (value) =>
                      value?.trim().isEmpty ?? true ? 'Enter team name' : null,
                ),
              );
            }),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _createTournament,
              icon: const Icon(Icons.add),
              label: const Text('Create Tournament'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
