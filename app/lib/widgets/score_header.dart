import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';

/// Header widget showing current score and match statistics
class ScoreHeader extends StatelessWidget {
  const ScoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        final match = matchProvider.currentMatch;
        final currentInnings = match?.currentInnings;

        if (match == null || currentInnings == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildTeamScore(context, currentInnings),
                const SizedBox(height: 16),
                _buildMatchStats(context, currentInnings),
                if (currentInnings.target > 0) ...[
                  const SizedBox(height: 12),
                  _buildTargetInfo(context, currentInnings),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamScore(BuildContext context, currentInnings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              currentInnings.battingTeam,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${currentInnings.totalRuns}/${currentInnings.wickets}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '(${currentInnings.oversString} ov)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMatchStats(BuildContext context, currentInnings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          context,
          'Run Rate',
          currentInnings.runRate.toStringAsFixed(2),
          Icons.speed,
        ),
        if (currentInnings.target > 0)
          _buildStatItem(
            context,
            'Required RR',
            currentInnings.requiredRunRate.toStringAsFixed(2),
            Icons.my_location,
          )
        else
          _buildStatItem(
            context,
            'Projected',
            currentInnings.projectedTotal.toString(),
            Icons.trending_up,
          ),
        _buildStatItem(
          context,
          'Extras',
          currentInnings.extras.toString(),
          Icons.add_circle_outline,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentSaffron, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTargetInfo(BuildContext context, currentInnings) {
    final remainingRuns = currentInnings.target - currentInnings.totalRuns;
    final remainingBalls =
        (20 * 6) - currentInnings.ballsBowled; // Assuming T20

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accentSaffron.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        remainingRuns > 0
            ? 'Need $remainingRuns runs in $remainingBalls balls'
            : 'Target achieved!',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.accentSaffron,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
