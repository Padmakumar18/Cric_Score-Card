import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import 'player_dialogs.dart';

class ModernActionButtons extends StatelessWidget {
  const ModernActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    final isSmallScreen = screenHeight < 700;

    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final innings = provider.currentMatch?.currentInnings;

        if (innings == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? (isSmallScreen ? 12 : 16) : 20),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            border: Border.all(
              color: AppTheme.textTertiary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: isMobile ? (isSmallScreen ? 15 : 16) : 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: isMobile ? (isSmallScreen ? 10 : 12) : 16),

              // First Row - Retire, Swap, End Over, Undo
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Retire',
                      Icons.exit_to_app,
                      AppTheme.textTertiary,
                      () => _showRetireDialog(context, provider),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildActionButton(
                      'Swap',
                      Icons.swap_horiz,
                      AppTheme.accentBlue,
                      () => provider.switchStrike(),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildActionButton(
                      'End over',
                      Icons.skip_next,
                      AppTheme.warningOrange,
                      () => _showEndOverDialog(context, provider),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildActionButton(
                      'Undo',
                      Icons.undo,
                      provider.canUndo
                          ? AppTheme.undoColor
                          : AppTheme.textTertiary,
                      provider.canUndo ? () => provider.undoLastBall() : null,
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                ],
              ),

              SizedBox(height: isMobile ? (isSmallScreen ? 8 : 10) : 12),

              // Second Row - Wide, No ball, Byes, Leg byes
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Wide',
                      Icons.open_in_full,
                      AppTheme.wideColor,
                      () => _showWideDialog(context, provider),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildActionButton(
                      'No ball',
                      Icons.block,
                      AppTheme.noBallColor,
                      () => _showNoBallDialog(context, provider),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildActionButton(
                      'Byes',
                      Icons.directions_run,
                      AppTheme.byeColor,
                      () => _showByesDialog(context, provider, false),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildActionButton(
                      'Leg byes',
                      Icons.sports_cricket,
                      AppTheme.byeColor,
                      () => _showByesDialog(context, provider, true),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                ],
              ),

              SizedBox(height: isMobile ? (isSmallScreen ? 8 : 10) : 12),

              // Third Row - Wicket, Run out
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Wicket',
                      Icons.close,
                      AppTheme.wicketColor,
                      () => _showWicketDialog(context, provider),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildActionButton(
                      'Run out',
                      Icons.directions_run_outlined,
                      AppTheme.wicketColor,
                      () => _showRunOutDialog(context, provider),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  const Expanded(child: SizedBox()), // Empty space
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
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
    bool isMobile,
    bool isSmallScreen,
  ) {
    return SizedBox(
      height: isMobile ? (isSmallScreen ? 42 : 45) : 48,
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
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isMobile ? (isSmallScreen ? 14 : 15) : 16),
            SizedBox(height: isMobile ? 1 : 2),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? (isSmallScreen ? 9 : 9.5) : 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  void _showWideDialog(BuildContext context, MatchProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Wide',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How many runs off the wide?',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [0, 1, 2, 3, 4]
                  .map(
                    (runs) => SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.addBallEvent(runs: runs, isWide: true);
                          if (runs % 2 == 1) provider.switchStrike();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.wideColor,
                        ),
                        child: Text(runs.toString()),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  _showMoreRunsInput(context, provider, 'Wide', isWide: true),
              child: const Text('More runs...'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoBallDialog(BuildContext context, MatchProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'No Ball',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How many runs off the no ball?',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [0, 1, 2, 3, 4]
                  .map(
                    (runs) => SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.addBallEvent(runs: runs, isNoBall: true);
                          if (runs % 2 == 1) provider.switchStrike();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.noBallColor,
                        ),
                        child: Text(runs.toString()),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _showMoreRunsInput(
                context,
                provider,
                'No Ball',
                isNoBall: true,
              ),
              child: const Text('More runs...'),
            ),
          ],
        ),
      ),
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
            Text(
              'How many ${isLegBye ? 'leg byes' : 'byes'}?',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [0, 1, 2, 3, 4]
                  .map(
                    (runs) => SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.addBallEvent(
                            runs: runs,
                            isBye: !isLegBye,
                            isLegBye: isLegBye,
                          );
                          if (runs % 2 == 1) provider.switchStrike();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.byeColor,
                        ),
                        child: Text(runs.toString()),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _showMoreRunsInput(
                context,
                provider,
                isLegBye ? 'Leg Byes' : 'Byes',
                isBye: !isLegBye,
                isLegBye: isLegBye,
              ),
              child: const Text('More runs...'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreRunsInput(
    BuildContext context,
    MatchProvider provider,
    String title, {
    bool isWide = false,
    bool isNoBall = false,
    bool isBye = false,
    bool isLegBye = false,
  }) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          '$title - Enter Runs',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter number of runs:',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g., 5, 6, 7...',
                hintStyle: const TextStyle(color: AppTheme.textTertiary),
                filled: true,
                fillColor: AppTheme.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final runs = int.tryParse(controller.text.trim());
              if (runs != null && runs >= 0) {
                provider.addBallEvent(
                  runs: runs,
                  isWide: isWide,
                  isNoBall: isNoBall,
                  isBye: isBye,
                  isLegBye: isLegBye,
                );
                if (runs % 2 == 1) provider.switchStrike();
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the previous dialog too
              }
            },
            child: const Text('Add'),
          ),
        ],
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
                    Navigator.of(context).pop();
                    // Show new batsman dialog
                    PlayerDialogs.showNewBatsmanDialog(context, provider);
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
                        Navigator.of(context).pop();
                        // Show new batsman dialog
                        PlayerDialogs.showNewBatsmanDialog(context, provider);
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
