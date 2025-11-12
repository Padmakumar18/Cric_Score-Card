import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';

class ModernBatsmenCard extends StatelessWidget {
  const ModernBatsmenCard({super.key});

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

        final currentBatsmen = innings.currentBatsmen;

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 6 : 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.sports_cricket,
                      color: AppTheme.accentBlue,
                      size: isMobile ? 16 : 20,
                    ),
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'Batsman',
                    style: TextStyle(
                      fontSize: isMobile ? (isSmallScreen ? 15 : 16) : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? (isSmallScreen ? 10 : 12) : 16),

              // Batsmen Stats Header
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? (isSmallScreen ? 6 : 7) : 8,
                  horizontal: isMobile ? (isSmallScreen ? 8 : 10) : 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        '',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'R',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isMobile ? (isSmallScreen ? 10 : 11) : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'B',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isMobile ? (isSmallScreen ? 10 : 11) : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '4s',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isMobile ? (isSmallScreen ? 10 : 11) : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '6s',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isMobile ? (isSmallScreen ? 10 : 11) : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'SR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isMobile ? (isSmallScreen ? 10 : 11) : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isMobile ? (isSmallScreen ? 6 : 7) : 8),

              // Current Batsmen
              ...currentBatsmen.map(
                (batsman) => Container(
                  margin: EdgeInsets.symmetric(vertical: isMobile ? 3 : 4),
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? (isSmallScreen ? 8 : 10) : 12,
                    horizontal: isMobile ? (isSmallScreen ? 8 : 10) : 12,
                  ),
                  decoration: BoxDecoration(
                    color: batsman.isOnStrike
                        ? AppTheme.warningOrange.withValues(alpha: 0.1)
                        : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: batsman.isOnStrike
                        ? Border.all(
                            color: AppTheme.warningOrange.withValues(
                              alpha: 0.5,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            if (batsman.isOnStrike)
                              Container(
                                margin: EdgeInsets.only(
                                  right: isMobile ? 6 : 8,
                                ),
                                padding: EdgeInsets.all(isMobile ? 3 : 4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.warningOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: isMobile ? 10 : 12,
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    batsman.name.length > (isMobile ? 10 : 12)
                                        ? '${batsman.name.substring(0, isMobile ? 10 : 12)}...'
                                        : batsman.name,
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontWeight: batsman.isOnStrike
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: isMobile
                                          ? (isSmallScreen ? 12 : 13)
                                          : 14,
                                    ),
                                  ),
                                  if (batsman.isOut &&
                                      batsman.dismissalType != null)
                                    Text(
                                      batsman.dismissalType!,
                                      style: TextStyle(
                                        color: AppTheme.errorRed,
                                        fontSize: isMobile
                                            ? (isSmallScreen ? 9 : 10)
                                            : 11,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          batsman.runs.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          batsman.ballsFaced.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          batsman.fours.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          batsman.sixes.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          batsman.strikeRate.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getStrikeRateColor(batsman.strikeRate),
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStrikeRateColor(double strikeRate) {
    if (strikeRate >= 150) return AppTheme.successGreen;
    if (strikeRate >= 100) return AppTheme.warningOrange;
    return AppTheme.textSecondary;
  }
}
