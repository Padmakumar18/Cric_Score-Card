import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../models/ball_event.dart';
import '../theme/app_theme.dart';

class CurrentOverDisplay extends StatelessWidget {
  const CurrentOverDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    final isSmallScreen = screenHeight < 700;

    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final innings = provider.currentMatch?.currentInnings;

        if (innings == null || innings.overs.isEmpty) {
          return const SizedBox.shrink();
        }

        final lastOver = innings.overs.last;
        final currentOver = lastOver;

        // If over is complete, show 6 empty balls, otherwise show actual balls
        final isOverComplete = lastOver.isComplete;
        final balls = isOverComplete ? <BallEvent>[] : currentOver.balls;
        final validBalls = isOverComplete ? 0 : currentOver.validBalls;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? (isSmallScreen ? 12 : 14) : 16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
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
                    style: TextStyle(
                      fontSize: isMobile ? (isSmallScreen ? 14 : 15) : 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$validBalls/6 balls',
                        style: TextStyle(
                          fontSize: isMobile ? (isSmallScreen ? 11 : 12) : 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      Text(
                        '${currentOver.runsScored} runs',
                        style: TextStyle(
                          fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: isMobile ? (isSmallScreen ? 8 : 10) : 12),
              // Show all balls in a wrap to handle overflow
              Wrap(
                spacing: isMobile ? (isSmallScreen ? 6 : 7) : 8,
                runSpacing: isMobile ? (isSmallScreen ? 6 : 7) : 8,
                children: [
                  // Show all balls that have been bowled
                  for (int i = 0; i < balls.length; i++)
                    _buildBallChip(context, balls[i], isMobile, isSmallScreen),
                  // Show remaining valid balls needed (if less than 6 valid balls)
                  if (validBalls < 6)
                    for (int i = 0; i < (6 - validBalls); i++)
                      _buildBallChip(context, null, isMobile, isSmallScreen),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBallChip(
    BuildContext context,
    BallEvent? ball,
    bool isMobile,
    bool isSmallScreen,
  ) {
    final chipSize = isMobile ? (isSmallScreen ? 32.0 : 34.0) : 36.0;
    final fontSize = isMobile ? (isSmallScreen ? 11.0 : 12.0) : 12.0;

    if (ball == null) {
      return Container(
        width: chipSize,
        height: chipSize,
        decoration: BoxDecoration(
          color: AppTheme.pitchTan.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.textTertiary.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            '-',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: fontSize,
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
      width: chipSize,
      height: chipSize,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
