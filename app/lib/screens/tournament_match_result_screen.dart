import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tournament_provider.dart';
import '../models/tournament.dart';
import '../theme/app_theme.dart';

class TournamentMatchResultScreen extends StatefulWidget {
  final TournamentMatch match;

  const TournamentMatchResultScreen({super.key, required this.match});

  @override
  State<TournamentMatchResultScreen> createState() =>
      _TournamentMatchResultScreenState();
}

class _TournamentMatchResultScreenState
    extends State<TournamentMatchResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _team1ScoreController = TextEditingController();
  final _team2ScoreController = TextEditingController();
  String? _selectedWinner;

  @override
  void dispose() {
    _team1ScoreController.dispose();
    _team2ScoreController.dispose();
    super.dispose();
  }

  void _submitResult() {
    if (_formKey.currentState!.validate() && _selectedWinner != null) {
      final team1Score = int.parse(_team1ScoreController.text);
      final team2Score = int.parse(_team2ScoreController.text);

      context.read<TournamentProvider>().updateMatchResult(
        matchId: widget.match.id,
        winner: _selectedWinner!,
        team1Score: team1Score,
        team2Score: team2Score,
      );

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match result saved!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Match Result')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${widget.match.team1} vs ${widget.match.team2}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Match ${widget.match.id.replaceAll("match_", "")}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _team1ScoreController,
              decoration: InputDecoration(
                labelText: '${widget.match.team1} Score',
                prefixIcon: const Icon(Icons.scoreboard),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.trim().isEmpty ?? true) return 'Enter score';
                if (int.tryParse(value!) == null) return 'Enter valid number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _team2ScoreController,
              decoration: InputDecoration(
                labelText: '${widget.match.team2} Score',
                prefixIcon: const Icon(Icons.scoreboard),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.trim().isEmpty ?? true) return 'Enter score';
                if (int.tryParse(value!) == null) return 'Enter valid number';
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Winner', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            RadioListTile<String>(
              title: Text(widget.match.team1),
              value: widget.match.team1,
              groupValue: _selectedWinner,
              onChanged: (value) {
                setState(() => _selectedWinner = value);
              },
            ),
            RadioListTile<String>(
              title: Text(widget.match.team2),
              value: widget.match.team2,
              groupValue: _selectedWinner,
              onChanged: (value) {
                setState(() => _selectedWinner = value);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _submitResult,
              icon: const Icon(Icons.check),
              label: const Text('Save Result'),
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
