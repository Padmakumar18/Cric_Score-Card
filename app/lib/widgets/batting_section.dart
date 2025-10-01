import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../models/batsman.dart';
import '../theme/app_theme.dart';

/// Widget displaying batting statistics and current batsmen
class BattingSection extends StatelessWidget {
  const BattingSection({super.key});

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
                _buildCurrentBatsmen(context, currentInnings),
                const SizedBox(height: 16),
                _buildBattingStats(context, currentInnings),
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
        Icon(Icons.sports_cricket, color: AppTheme.primaryGreen, size: 24),
        const SizedBox(width: 8),
        Text(
          'Batting',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentBatsmen(BuildContext context, currentInnings) {
    final currentBatsmen = currentInnings.currentBatsmen;

    if (currentBatsmen.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.pitchTan.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('No batsmen on field'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Batsmen',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...currentBatsmen.map(
          (batsman) => _buildCurrentBatsmanRow(context, batsman),
        ),
      ],
    );
  }

  Widget _buildCurrentBatsmanRow(BuildContext context, Batsman batsman) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: batsman.isOnStrike
            ? AppTheme.accentSaffron.withValues(alpha: 0.1)
            : AppTheme.pitchTan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: batsman.isOnStrike
            ? Border.all(color: AppTheme.accentSaffron, width: 2)
            : null,
      ),
      child: Row(
        children: [
          if (batsman.isOnStrike)
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.accentSaffron,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (batsman.isOnStrike) const SizedBox(width: 8),
          Expanded(
            child: Text(
              batsman.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: batsman.isOnStrike
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          Text(
            batsman.scoreString,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Text(
            'SR: ${batsman.strikeRate.toStringAsFixed(1)}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBattingStats(BuildContext context, currentInnings) {
    final batsmen = currentInnings.batsmen;

    if (batsmen.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Batting Statistics',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _buildStatsHeader(context),
        const Divider(),
        ...batsmen.map((batsman) => _buildBatsmanStatsRow(context, batsman)),
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
              'Batsman',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text('Runs', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 2,
            child: Text('Balls', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 1,
            child: Text('4s', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 1,
            child: Text('6s', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 2,
            child: Text('SR', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatsmanStatsRow(BuildContext context, Batsman batsman) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              batsman.name,
              style: TextStyle(
                fontWeight: batsman.isOnStrike
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: batsman.isOnStrike ? AppTheme.accentSaffron : null,
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(batsman.runs.toString())),
          Expanded(flex: 2, child: Text(batsman.ballsFaced.toString())),
          Expanded(flex: 1, child: Text(batsman.fours.toString())),
          Expanded(flex: 1, child: Text(batsman.sixes.toString())),
          Expanded(flex: 2, child: Text(batsman.strikeRate.toStringAsFixed(1))),
          Expanded(
            flex: 2,
            child: Text(
              batsman.statusString,
              style: TextStyle(
                color: batsman.isOut
                    ? AppTheme.errorRed
                    : AppTheme.successGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
