import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../models/bowler.dart';
import '../theme/app_theme.dart';

/// Widget displaying bowling statistics and current bowler
class BowlingSection extends StatelessWidget {
  const BowlingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        final currentInnings = matchProvider.currentMatch?.currentInnings;

        if (currentInnings == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context),
                const SizedBox(height: 16),
                _buildCurrentBowler(context, currentInnings),
                const SizedBox(height: 16),
                _buildBowlingStats(context, currentInnings),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.sports_baseball, color: AppTheme.primaryGreen, size: 24),
        const SizedBox(width: 8),
        Text(
          'Bowling',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => _showChangeBowlerDialog(context),
          icon: const Icon(Icons.swap_horiz),
          label: const Text('Change'),
        ),
      ],
    );
  }

  Widget _buildCurrentBowler(BuildContext context, currentInnings) {
    final currentBowler = currentInnings.currentBowler;

    if (currentBowler == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.pitchTan.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Text('No bowler selected'),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _showChangeBowlerDialog(context),
              child: const Text('Select Bowler'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentSaffron.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentSaffron, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Bowler',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  currentBowler.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${currentBowler.oversString} ov',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Text(
                currentBowler.figuresString,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentSaffron,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Economy: ${currentBowler.economyRate.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlingStats(BuildContext context, currentInnings) {
    final bowlers = currentInnings.bowlers;

    if (bowlers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bowling Statistics',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _buildStatsHeader(context),
        const Divider(),
        ...bowlers.map((bowler) => _buildBowlerStatsRow(context, bowler)),
      ],
    );
  }

  Widget _buildStatsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              'Bowler',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text('Overs', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 2,
            child: Text('Runs', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Wickets',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Economy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlerStatsRow(BuildContext context, Bowler bowler) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              bowler.name,
              style: TextStyle(
                fontWeight: bowler.isCurrentBowler
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: bowler.isCurrentBowler ? AppTheme.accentSaffron : null,
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(bowler.oversString)),
          Expanded(flex: 2, child: Text(bowler.runsConceded.toString())),
          Expanded(flex: 2, child: Text(bowler.wickets.toString())),
          Expanded(flex: 2, child: Text(bowler.economyRate.toStringAsFixed(2))),
        ],
      ),
    );
  }

  void _showChangeBowlerDialog(BuildContext context) {
    final matchProvider = context.read<MatchProvider>();
    final currentInnings = matchProvider.currentMatch?.currentInnings;

    if (currentInnings == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Bowler'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currentInnings.bowlers.length,
            itemBuilder: (context, index) {
              final bowler = currentInnings.bowlers[index];
              return ListTile(
                title: Text(bowler.name),
                subtitle: Text(
                  '${bowler.oversString} ov, ${bowler.figuresString}',
                ),
                trailing: bowler.isCurrentBowler
                    ? const Icon(Icons.check, color: AppTheme.successGreen)
                    : null,
                onTap: () {
                  matchProvider.changeBowler(bowler.name);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
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
}
