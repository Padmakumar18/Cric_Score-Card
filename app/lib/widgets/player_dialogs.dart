import 'package:flutter/material.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';

class PlayerDialogs {
  static Future<void> showNewBatsmanDialog(
    BuildContext context,
    MatchProvider provider,
  ) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'New Batsman Required',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'A batsman is out. Enter the new batsman name:',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Batsman Name',
                  prefixIcon: Icon(Icons.sports_cricket),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter batsman name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                provider.addNewBatsman(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add Batsman'),
          ),
        ],
      ),
    );
  }

  static Future<void> showNewBowlerDialog(
    BuildContext context,
    MatchProvider provider,
  ) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final innings = provider.currentMatch?.currentInnings;

    if (innings == null) return;

    // Get list of previous bowlers
    final previousBowlers = innings.bowlers
        .where((b) => !b.isCurrentBowler)
        .map((b) => b.name)
        .toList();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'New Over - Select Bowler',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Over complete. Select or enter new bowler:',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              if (previousBowlers.isNotEmpty) ...[
                const Text(
                  'Previous Bowlers:',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: previousBowlers.map((name) {
                    return ActionChip(
                      label: Text(name),
                      onPressed: () {
                        provider.addNewBowler(name);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'New Bowler Name',
                  prefixIcon: Icon(Icons.sports),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter bowler name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                provider.addNewBowler(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Set Bowler'),
          ),
        ],
      ),
    );
  }

  static Future<void> showInningsSwitchDialog(
    BuildContext context,
    MatchProvider provider,
  ) async {
    final firstInnings = provider.currentMatch?.firstInnings;
    if (firstInnings == null) return;

    final batsman1Controller = TextEditingController();
    final batsman2Controller = TextEditingController();
    final bowlerController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'First Innings Complete',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${firstInnings.battingTeam}: ${firstInnings.totalRuns}/${firstInnings.wickets}',
                  style: const TextStyle(
                    color: AppTheme.accentBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Target: ${firstInnings.totalRuns + 1}',
                  style: const TextStyle(
                    color: AppTheme.warningOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Enter opening batsmen:',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: batsman1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Batsman 1 (On Strike)',
                    prefixIcon: Icon(Icons.sports_cricket),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: batsman2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Batsman 2 (Non-Striker)',
                    prefixIcon: Icon(Icons.sports_cricket),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    if (value.trim() == batsman1Controller.text.trim()) {
                      return 'Must be different';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enter opening bowler:',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: bowlerController,
                  decoration: const InputDecoration(
                    labelText: 'Bowler Name',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                provider.startSecondInnings(
                  [
                    batsman1Controller.text.trim(),
                    batsman2Controller.text.trim(),
                  ],
                  [bowlerController.text.trim()],
                );
                provider.changeBowler(bowlerController.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Start Second Innings'),
          ),
        ],
      ),
    );
  }
}
