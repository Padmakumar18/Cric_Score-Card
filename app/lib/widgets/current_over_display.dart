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
        final validBalls = currentOver.validBalls;

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
                  Row(
                    children: [
                      Text(
                        '$validBalls/6 balls',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                ],
              ),
              const SizedBox(height: 12),
              // Show all balls in a wrap to handle overflow
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Show all balls that have been bowled
                  for (int i = 0; i < balls.length; i++)
                    _buildBallChip(context, balls[i]),
                  // Show remaining valid balls needed (if less than 6 valid balls)
                  if (validBalls < 6)
                    for (int i = 0; i < (6 - validBalls); i++)
                      _buildBallChip(context, null),
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
