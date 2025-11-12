import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../models/ball_event.dart';
import '../theme/app_theme.dart';
import '../screens/scorecard_screen.dart';

class ModernScoreDisplay extends StatelessWidget {
  const ModernScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    final isSmallScreen = screenHeight < 700;

    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final match = provider.currentMatch;
        final innings = match?.currentInnings;

        if (match == null || innings == null) {
          return const SizedBox.shrink();
        }

        final totalOvers = match.oversPerInnings;
        // Always show current over section, but with empty balls if complete
        final currentOver = innings.overs.isNotEmpty
            ? innings.overs.last
            : null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? (isSmallScreen ? 16 : 20) : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primaryBlue, AppTheme.lightBlue],
            ),
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with Score and Scorecard Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Score
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${innings.totalRuns}',
                          style: TextStyle(
                            fontSize: isMobile ? (isSmallScreen ? 48 : 56) : 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        Text(
                          '/',
                          style: TextStyle(
                            fontSize: isMobile ? (isSmallScreen ? 36 : 42) : 48,
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${innings.wickets}',
                          style: TextStyle(
                            fontSize: isMobile ? (isSmallScreen ? 36 : 42) : 48,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: isMobile ? 12 : 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${innings.oversString}/$totalOvers',
                              style: TextStyle(
                                fontSize: isMobile
                                    ? (isSmallScreen ? 16 : 18)
                                    : 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Overs',
                              style: TextStyle(
                                fontSize: isMobile
                                    ? (isSmallScreen ? 11 : 12)
                                    : 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // View Scorecard Button
                  SizedBox(
                    height: isMobile ? (isSmallScreen ? 32 : 36) : 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ScorecardScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? (isSmallScreen ? 8 : 10) : 12,
                          vertical: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: Icon(
                        Icons.list_alt,
                        size: isMobile ? (isSmallScreen ? 14 : 16) : 18,
                      ),
                      label: Text(
                        'Scorecard',
                        style: TextStyle(
                          fontSize: isMobile ? (isSmallScreen ? 11 : 12) : 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? (isSmallScreen ? 10 : 12) : 16),

              // Target message for second innings
              if (innings.target > 0) ...[
                _buildTargetMessage(innings, match, isMobile, isSmallScreen),
                SizedBox(height: isMobile ? (isSmallScreen ? 10 : 12) : 16),
              ],

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (innings.target > 0) ...[
                    _buildStatChip(
                      'Target',
                      innings.target.toString(),
                      AppTheme.warningOrange,
                      isMobile,
                      isSmallScreen,
                    ),
                    _buildStatChip(
                      'CRR',
                      innings.runRate.toStringAsFixed(2),
                      AppTheme.accentBlue,
                      isMobile,
                      isSmallScreen,
                    ),
                    _buildStatChip(
                      'RRR',
                      innings.getRequiredRunRate(totalOvers).toStringAsFixed(2),
                      AppTheme.errorRed,
                      isMobile,
                      isSmallScreen,
                    ),
                  ] else ...[
                    _buildStatChip(
                      'CRR',
                      innings.runRate.toStringAsFixed(2),
                      AppTheme.accentBlue,
                      isMobile,
                      isSmallScreen,
                    ),
                    _buildStatChip(
                      'Projected',
                      innings.getProjectedTotal(totalOvers).toString(),
                      AppTheme.successGreen,
                      isMobile,
                      isSmallScreen,
                    ),
                    _buildStatChip(
                      'This Over',
                      currentOver != null && !currentOver.isComplete
                          ? currentOver.runsScored.toString()
                          : '-',
                      AppTheme.primaryBlue,
                      isMobile,
                      isSmallScreen,
                    ),
                  ],
                ],
              ),

              // Current Over Display (integrated)
              if (currentOver != null) ...[
                SizedBox(height: isMobile ? (isSmallScreen ? 10 : 12) : 16),
                _buildCurrentOverSection(currentOver, isMobile, isSmallScreen),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatChip(
    String label,
    String value,
    Color color,
    bool isMobile,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? (isSmallScreen ? 8 : 10) : 12,
        vertical: isMobile ? (isSmallScreen ? 4 : 5) : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? (isSmallScreen ? 10 : 11) : 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetMessage(
    innings,
    match,
    bool isMobile,
    bool isSmallScreen,
  ) {
    final runsNeeded = innings.target - innings.totalRuns;
    final totalBalls = match.oversPerInnings * 6;
    final ballsRemaining = totalBalls - innings.ballsBowled;

    if (runsNeeded <= 0) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: AppTheme.successGreen.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.successGreen.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          '🎉 Target Achieved!',
          style: TextStyle(
            fontSize: isMobile ? (isSmallScreen ? 13 : 14) : 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        'Need $runsNeeded runs from $ballsRemaining balls',
        style: TextStyle(
          fontSize: isMobile ? (isSmallScreen ? 13 : 14) : 15,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCurrentOverSection(
    currentOver,
    bool isMobile,
    bool isSmallScreen,
  ) {
    // If over is complete, show 6 empty balls
    final isOverComplete = currentOver.isComplete;
    final balls = isOverComplete ? [] : currentOver.balls;
    final validBalls = isOverComplete ? 0 : currentOver.validBalls;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Over ${currentOver.overNumber}',
              style: TextStyle(
                fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  '$validBalls/6',
                  style: TextStyle(
                    fontSize: isMobile ? (isSmallScreen ? 11 : 12) : 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: isMobile ? 8 : 12),
                Text(
                  '${currentOver.runsScored} runs',
                  style: TextStyle(
                    fontSize: isMobile ? (isSmallScreen ? 11 : 12) : 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: isMobile ? (isSmallScreen ? 6 : 8) : 10),
        Wrap(
          spacing: isMobile ? (isSmallScreen ? 5 : 6) : 7,
          runSpacing: isMobile ? (isSmallScreen ? 5 : 6) : 7,
          children: [
            for (int i = 0; i < balls.length; i++)
              _buildBallChip(balls[i], isMobile, isSmallScreen),
            if (validBalls < 6)
              for (int i = 0; i < (6 - validBalls); i++)
                _buildBallChip(null, isMobile, isSmallScreen),
          ],
        ),
      ],
    );
  }

  Widget _buildBallChip(BallEvent? ball, bool isMobile, bool isSmallScreen) {
    final chipSize = isMobile ? (isSmallScreen ? 28.0 : 30.0) : 32.0;
    final fontSize = isMobile ? (isSmallScreen ? 10.0 : 11.0) : 11.0;

    if (ball == null) {
      return Container(
        width: chipSize,
        height: chipSize,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Text(
            '-',
            style: TextStyle(
              color: Colors.white60,
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
      backgroundColor = Colors.white.withValues(alpha: 0.3);
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.white.withValues(alpha: 0.9);
      textColor = AppTheme.primaryBlue;
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
