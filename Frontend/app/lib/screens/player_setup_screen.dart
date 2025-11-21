import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import 'scoreboard_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  final String battingTeam;
  final String bowlingTeam;

  const PlayerSetupScreen({
    super.key,
    required this.battingTeam,
    required this.bowlingTeam,
  });

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _batsman1Controller = TextEditingController();
  final _batsman2Controller = TextEditingController();
  final _bowlerController = TextEditingController();

  @override
  void dispose() {
    _batsman1Controller.dispose();
    _batsman2Controller.dispose();
    _bowlerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldPop = await _showBackConfirmation(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await _showBackConfirmation(context);
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            tooltip: 'Go Back',
          ),
          title: const Text('Player Setup'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Opening Batsmen (${widget.battingTeam})'),
                const SizedBox(height: 16),
                _buildBatsmanInputs(),
                const SizedBox(height: 32),
                _buildSectionTitle('Opening Bowler (${widget.bowlingTeam})'),
                const SizedBox(height: 16),
                _buildBowlerInput(),
                const SizedBox(height: 48),
                _buildStartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showBackConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Cancel Match Setup?',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Going back will cancel the match setup. Do you want to continue?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MatchProvider>().resetMatch();
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
    return result ?? false;
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

  Widget _buildBatsmanInputs() {
    return Column(
      children: [
        TextFormField(
          controller: _batsman1Controller,
          decoration: const InputDecoration(
            labelText: 'Batsman 1 (On Strike)',
            prefixIcon: Icon(Icons.sports_cricket),
            hintText: 'Enter batsman name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter batsman 1 name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _batsman2Controller,
          decoration: const InputDecoration(
            labelText: 'Batsman 2 (Non-Striker)',
            prefixIcon: Icon(Icons.sports_cricket),
            hintText: 'Enter batsman name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter batsman 2 name';
            }
            if (value.trim() == _batsman1Controller.text.trim()) {
              return 'Batsmen names must be different';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBowlerInput() {
    return TextFormField(
      controller: _bowlerController,
      decoration: const InputDecoration(
        labelText: 'Bowler Name',
        prefixIcon: Icon(Icons.sports),
        hintText: 'Enter bowler name',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter bowler name';
        }
        return null;
      },
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _startInnings,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Innings'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _startInnings() {
    if (!_formKey.currentState!.validate()) return;

    final batsman1 = _batsman1Controller.text.trim();
    final batsman2 = _batsman2Controller.text.trim();
    final bowler = _bowlerController.text.trim();

    final matchProvider = context.read<MatchProvider>();

    // Start innings with entered players
    matchProvider.startFirstInnings([batsman1, batsman2], [bowler]);

    // Set the bowler as current bowler
    matchProvider.changeBowler(bowler);

    // Navigate to scoreboard (replace to skip player setup when going back)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ScoreboardScreen()),
    );
  }
}
