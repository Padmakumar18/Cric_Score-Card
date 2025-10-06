import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';

class ModernActionButtons extends StatelessWidget {
  const ModernActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final innings = provider.currentMatch?.currentInnings;

        if (innings == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.textTertiary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // First Row - Retire, Swap, End Over, Undo
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Retire',
                      Icons.exit_to_app,
                      AppTheme.textTertiary,
                      () => _showRetireDialog(context, provider),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Swap striker',
                      Icons.swap_horiz,
                      AppTheme.accentBlue,
                      () => provider.switchStrike(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'End over',
                      Icons.skip_next,
                      AppTheme.warningOrange,
                      () => _showEndOverDialog(context, provider),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Undo',
                      Icons.undo,
                      provider.canUndo
                          ? AppTheme.undoColor
                          : AppTheme.textTertiary,
                      provider.canUndo ? () => provider.undoLastBall() : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Second Row - Wide, No ball, Byes, Leg byes
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Wide',
                      Icons.open_in_full,
                      AppTheme.wideColor,
                      () => provider.addBallEvent(runs: 1, isWide: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'No ball',
                      Icons.block,
                      AppTheme.noBallColor,
                      () => provider.addBallEvent(runs: 1, isNoBall: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Byes',
                      Icons.directions_run,
                      AppTheme.byeColor,
                      () => _showByesDialog(context, provider, false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Leg byes',
                      Icons.sports_cricket,
                      AppTheme.byeColor,
                      () => _showByesDialog(context, provider, true),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Third Row - Wicket, Run out
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Wicket',
                      Icons.close,
                      AppTheme.wicketColor,
                      () => _showWicketDialog(context, provider),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Run out',
                      Icons.directions_run_outlined,
                      AppTheme.wicketColor,
                      () => _showRunOutDialog(context, provider),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(child: SizedBox()), // Empty space
                  const SizedBox(width: 8),
                  const Expanded(child: SizedBox()), // Empty space
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showRetireDialog(BuildContext context, MatchProvider provider) {
    // Implementation for retire dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Retire feature coming soon!')),
    );
  }

  void _showEndOverDialog(BuildContext context, MatchProvider provider) {
    // Implementation for end over dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('End over feature coming soon!')),
    );
  }

  void _showByesDialog(
    BuildContext context,
    MatchProvider provider,
    bool isLegBye,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          isLegBye ? 'Leg Byes' : 'Byes',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How many runs?',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3, 4]
                  .map(
                    (runs) => ElevatedButton(
                      onPressed: () {
                        provider.addBallEvent(
                          runs: runs,
                          isBye: !isLegBye,
                          isLegBye: isLegBye,
                        );
                        if (runs % 2 == 1) provider.switchStrike();
                        Navigator.of(context).pop();
                      },
                      child: Text(runs.toString()),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showWicketDialog(BuildContext context, MatchProvider provider) {
    final wicketTypes = ['Bowled', 'Caught', 'LBW', 'Stumped', 'Hit Wicket'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Wicket Type',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: wicketTypes
              .map(
                (type) => ListTile(
                  title: Text(
                    type,
                    style: const TextStyle(color: AppTheme.textPrimary),
                  ),
                  onTap: () {
                    provider.addBallEvent(
                      runs: 0,
                      isWicket: true,
                      wicketType: type,
                    );
                    provider.addNewBatsman(
                      'New Batsman ${provider.currentMatch!.currentInnings!.batsmen.length + 1}',
                    );
                    Navigator.of(context).pop();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showRunOutDialog(BuildContext context, MatchProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Run Out',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How many runs before run out?',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [0, 1, 2, 3]
                  .map(
                    (runs) => ElevatedButton(
                      onPressed: () {
                        provider.addBallEvent(
                          runs: runs,
                          isWicket: true,
                          wicketType: 'Run Out',
                        );
                        provider.addNewBatsman(
                          'New Batsman ${provider.currentMatch!.currentInnings!.batsmen.length + 1}',
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text(runs.toString()),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
