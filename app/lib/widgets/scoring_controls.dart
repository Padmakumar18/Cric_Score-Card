import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// Widget with scoring controls and buttons
class ScoringControls extends StatelessWidget {
  const ScoringControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        final currentInnings = matchProvider.currentMatch?.currentInnings;

        if (currentInnings == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context),
                const SizedBox(height: 16),
                _buildRunButtons(context, matchProvider),
                const SizedBox(height: 16),
                _buildExtrasButtons(context, matchProvider),
                const SizedBox(height: 16),
                _buildActionButtons(context, matchProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Text(
      'Scoring Controls',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryGreen,
      ),
    );
  }

  Widget _buildRunButtons(BuildContext context, MatchProvider matchProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Runs',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.runButtons.map((runs) {
            return _buildRunButton(context, runs, matchProvider);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRunButton(
    BuildContext context,
    int runs,
    MatchProvider matchProvider,
  ) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (runs) {
      case 0:
        backgroundColor = AppTheme.dotBallColor;
        break;
      case 4:
        backgroundColor = AppTheme.boundaryColor;
        break;
      case 6:
        backgroundColor = AppTheme.sixColor;
        break;
      default:
        backgroundColor = AppTheme.lightGreen;
        break;
    }

    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _addRuns(matchProvider, runs),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          runs.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExtrasButtons(
    BuildContext context,
    MatchProvider matchProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Extras',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildExtraButton(
              context,
              'Wide',
              AppTheme.wideColor,
              () => _addWide(matchProvider),
            ),
            _buildExtraButton(
              context,
              'No Ball',
              AppTheme.noBallColor,
              () => _addNoBall(matchProvider),
            ),
            _buildExtraButton(
              context,
              'Bye',
              AppTheme.byeColor,
              () => _addBye(matchProvider),
            ),
            _buildExtraButton(
              context,
              'Leg Bye',
              AppTheme.byeColor,
              () => _addLegBye(matchProvider),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExtraButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    MatchProvider matchProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () => _addWicket(context, matchProvider),
              icon: const Icon(Icons.close),
              label: const Text('Wicket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.wicketColor,
                foregroundColor: Colors.white,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _switchStrike(matchProvider),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Switch Strike'),
            ),
            OutlinedButton.icon(
              onPressed: () => _showAddBatsmanDialog(context, matchProvider),
              icon: const Icon(Icons.person_add),
              label: const Text('New Batsman'),
            ),
          ],
        ),
      ],
    );
  }

  void _addRuns(MatchProvider matchProvider, int runs) {
    matchProvider.addBallEvent(runs: runs);

    // Switch strike for odd runs
    if (runs % 2 == 1) {
      matchProvider.switchStrike();
    }
  }

  void _addWide(MatchProvider matchProvider) {
    matchProvider.addBallEvent(runs: 0, isWide: true);
  }

  void _addNoBall(MatchProvider matchProvider) {
    matchProvider.addBallEvent(runs: 0, isNoBall: true);
  }

  void _addBye(MatchProvider matchProvider) {
    // For simplicity, assuming 1 bye. In real app, you'd ask for runs
    matchProvider.addBallEvent(runs: 1, isBye: true);
    matchProvider.switchStrike();
  }

  void _addLegBye(MatchProvider matchProvider) {
    // For simplicity, assuming 1 leg bye. In real app, you'd ask for runs
    matchProvider.addBallEvent(runs: 1, isLegBye: true);
    matchProvider.switchStrike();
  }

  void _addWicket(BuildContext context, MatchProvider matchProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wicket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select dismissal type:'),
            const SizedBox(height: 16),
            ...AppConstants.dismissalTypes.map(
              (type) => ListTile(
                title: Text(type),
                onTap: () {
                  matchProvider.addBallEvent(
                    runs: 0,
                    isWicket: true,
                    wicketType: type,
                  );
                  Navigator.of(context).pop();
                  _showAddBatsmanDialog(context, matchProvider);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _switchStrike(MatchProvider matchProvider) {
    matchProvider.switchStrike();
  }

  void _showAddBatsmanDialog(
    BuildContext context,
    MatchProvider matchProvider,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Batsman'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Batsman Name',
            hintText: 'Enter batsman name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                matchProvider.addNewBatsman(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
