import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../models/ball_event.dart';
import '../theme/app_theme.dart';

class CurrentOverDisplay extends StatelessWidget {
  const CurrentOverDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final innings = provider.currentMatch?.currentInnings;

        if (innings == null || innings.overs.isEmpty) {
          return const SizedBox.shrink();
        }

        final currentOver = innings.overs.last;
        final balls = currentOver.balls;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.textTertiary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Over ${currentOver.overNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${currentOver.runsScored} runs',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < 6; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildBallChip(
                        context,
                        i < balls.length ? balls[i] : null,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBallChip(BuildContext context, BallEvent? ball) {
    if (ball == null) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.pitchTan.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.textTertiary.withValues(alpha: 0.3),
          ),
        ),
        child: const Center(
          child: Text(
            '-',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    Color backgroundColor;
    Color textColor = Colors.white;
    String displayText = ball.displayString;

    if (ball.isWicket) {
      backgroundColor = AppTheme.wicketColor;
    } else if (ball.runs == 6) {
      backgroundColor = AppTheme.sixColor;
    } else if (ball.runs == 4) {
      backgroundColor = AppTheme.boundaryColor;
    } else if (ball.isWide) {
      backgroundColor = AppTheme.wideColor;
      displayText = 'WD';
    } else if (ball.isNoBall) {
      backgroundColor = AppTheme.noBallColor;
      displayText = 'NB';
    } else if (ball.isBye || ball.isLegBye) {
      backgroundColor = AppTheme.byeColor;
    } else if (ball.runs == 0) {
      backgroundColor = AppTheme.dotBallColor;
    } else {
      backgroundColor = AppTheme.lightGreen;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
