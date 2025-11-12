import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import 'player_setup_screen.dart';

/// Screen for setting up a new cricket match
class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _team1Controller = TextEditingController(
    text: AppConstants.defaultTeam1,
  );
  final _team2Controller = TextEditingController(
    text: AppConstants.defaultTeam2,
  );

  int _oversPerInnings = AppConstants.defaultOversPerInnings;
  int _totalPlayers = 11;
  String _tossWinner = AppConstants.defaultTeam1;
  String _tossDecision = AppConstants.tossDecisionBat;

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match Setup'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Team Details'),
              const SizedBox(height: 16),
              _buildTeamInputs(),

              const SizedBox(height: 32),
              _buildSectionTitle('Match Format'),
              const SizedBox(height: 16),
              _buildMatchFormat(),

              const SizedBox(height: 32),
              _buildSectionTitle('Team Size'),
              const SizedBox(height: 16),
              _buildTeamSize(),

              const SizedBox(height: 32),
              _buildSectionTitle('Toss Details'),
              const SizedBox(height: 16),
              _buildTossDetails(),

              const SizedBox(height: 48),
              _buildStartMatchButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppTheme.accentBlue,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTeamInputs() {
    return Column(
      children: [
        TextFormField(
          controller: _team1Controller,
          decoration: const InputDecoration(
            labelText: 'Team 1 Name',
            prefixIcon: Icon(Icons.group),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter team 1 name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _team2Controller,
          decoration: const InputDecoration(
            labelText: 'Team 2 Name',
            prefixIcon: Icon(Icons.group),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter team 2 name';
            }
            if (value.trim() == _team1Controller.text.trim()) {
              return 'Team names must be different';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMatchFormat() {
    final oversController = TextEditingController(
      text: _oversPerInnings.toString(),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overs per Innings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Predefined Overs Options
            Wrap(
              spacing: 8,
              children: [5, 10, 15, 20, 25, 50].map((overs) {
                return ChoiceChip(
                  label: Text('$overs overs'),
                  selected: _oversPerInnings == overs,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _oversPerInnings = overs;
                        oversController.text = overs.toString();
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: oversController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter custom number of overs',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.sports_cricket),
              ),
              onChanged: (value) {
                final enteredValue = int.tryParse(value);
                if (enteredValue != null && enteredValue > 0) {
                  setState(() {
                    _oversPerInnings = enteredValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSize() {
    final playersController = TextEditingController(
      text: _totalPlayers.toString(),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Players per Team',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Predefined Players Options
            Wrap(
              spacing: 8,
              children: [5, 7, 9, 11].map((players) {
                return ChoiceChip(
                  label: Text('$players players'),
                  selected: _totalPlayers == players,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _totalPlayers = players;
                        playersController.text = players.toString();
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: playersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter custom number of players',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.people),
                helperText: 'Innings ends when (players - 1) wickets fall',
              ),
              onChanged: (value) {
                final enteredValue = int.tryParse(value);
                if (enteredValue != null &&
                    enteredValue > 1 &&
                    enteredValue <= 11) {
                  setState(() {
                    _totalPlayers = enteredValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTossDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toss Winner', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text(
                      _team1Controller.text.isNotEmpty
                          ? _team1Controller.text
                          : 'Team 1',
                    ),
                    value: _team1Controller.text.isNotEmpty
                        ? _team1Controller.text
                        : AppConstants.defaultTeam1,
                    groupValue: _tossWinner,
                    onChanged: (value) {
                      setState(() {
                        _tossWinner = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text(
                      _team2Controller.text.isNotEmpty
                          ? _team2Controller.text
                          : 'Team 2',
                    ),
                    value: _team2Controller.text.isNotEmpty
                        ? _team2Controller.text
                        : AppConstants.defaultTeam2,
                    groupValue: _tossWinner,
                    onChanged: (value) {
                      setState(() {
                        _tossWinner = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Toss Decision',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Bat First'),
                    value: AppConstants.tossDecisionBat,
                    groupValue: _tossDecision,
                    onChanged: (value) {
                      setState(() {
                        _tossDecision = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Bowl First'),
                    value: AppConstants.tossDecisionBowl,
                    groupValue: _tossDecision,
                    onChanged: (value) {
                      setState(() {
                        _tossDecision = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartMatchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _startMatch,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Match'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _startMatch() {
    if (!_formKey.currentState!.validate()) return;

    final team1 = _team1Controller.text.trim();
    final team2 = _team2Controller.text.trim();

    // Update toss winner if team names changed
    if (_tossWinner == AppConstants.defaultTeam1) {
      _tossWinner = team1;
    } else if (_tossWinner == AppConstants.defaultTeam2) {
      _tossWinner = team2;
    }

    final matchProvider = context.read<MatchProvider>();

    // Create match
    matchProvider.createMatch(
      team1: team1,
      team2: team2,
      oversPerInnings: _oversPerInnings,
      totalPlayers: _totalPlayers,
      tossWinner: _tossWinner,
      tossDecision: _tossDecision,
    );

    // Navigate to player setup screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PlayerSetupScreen(
          battingTeam: matchProvider.currentMatch!.currentBattingTeam,
          bowlingTeam: matchProvider.currentMatch!.currentBowlingTeam,
        ),
      ),
    );
  }
}
