import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../models/ball_event.dart';
import '../theme/app_theme.dart';

/// Widget showing the last 6 balls summary
class OverSummary extends StatelessWidget {
  const OverSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        final currentInnings = matchProvider.currentMatch?.currentInnings;

        if (currentInnings == null) {
          return const SizedBox.shrink();
        }

        final lastSixBalls = currentInnings.lastSixBalls;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      color: AppTheme.primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last 6 Balls',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Over ${currentInnings.currentOverNumber}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (lastSixBalls.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.pitchTan.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Text('No balls bowled yet')),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Show last 6 balls, fill with empty if less than 6
                      for (int i = 0; i < 6; i++)
                        _buildBallWidget(
                          context,
                          i < lastSixBalls.length
                              ? lastSixBalls[i].displayString
                              : '',
                          i < lastSixBalls.length ? lastSixBalls[i] : null,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBallWidget(
    BuildContext context,
    String ballText,
    BallEvent? ballEvent,
  ) {
    Color backgroundColor;
    Color textColor = Colors.white;

    if (ballEvent == null) {
      backgroundColor = AppTheme.pitchTan.withValues(alpha: 0.3);
      textColor = AppTheme.textSecondary;
    } else if (ballEvent.isWicket) {
      backgroundColor = AppTheme.wicketColor;
    } else if (ballEvent.runs == 6) {
      backgroundColor = AppTheme.sixColor;
    } else if (ballEvent.runs == 4) {
      backgroundColor = AppTheme.boundaryColor;
    } else if (ballEvent.isWide || ballEvent.isNoBall) {
      backgroundColor = ballEvent.isWide
          ? AppTheme.wideColor
          : AppTheme.noBallColor;
    } else if (ballEvent.isBye || ballEvent.isLegBye) {
      backgroundColor = AppTheme.byeColor;
    } else if (ballEvent.runs == 0) {
      backgroundColor = AppTheme.dotBallColor;
    } else {
      backgroundColor = AppTheme.lightGreen;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: ballEvent == null
            ? Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.3))
            : null,
      ),
      child: Center(
        child: Text(
          ballText,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
