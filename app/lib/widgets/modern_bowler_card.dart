import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';

class ModernBowlerCard extends StatelessWidget {
  const ModernBowlerCard({super.key});

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

        final currentBowler = innings.currentBowler;

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
                      color: AppTheme.successGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.sports_baseball,
                      color: AppTheme.successGreen,
                      size: isMobile ? 16 : 20,
                    ),
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'Bowler',
                    style: TextStyle(
                      fontSize: isMobile ? (isSmallScreen ? 15 : 16) : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? (isSmallScreen ? 10 : 12) : 16),

              // Bowler Stats Header
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
                        'O',
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
                        'M',
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
                        'W',
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
                        'Econ',
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

              // Current Bowler
              if (currentBowler != null)
                Container(
                  margin: EdgeInsets.symmetric(vertical: isMobile ? 3 : 4),
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? (isSmallScreen ? 8 : 10) : 12,
                    horizontal: isMobile ? (isSmallScreen ? 8 : 10) : 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.successGreen.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                              padding: EdgeInsets.all(isMobile ? 3 : 4),
                              decoration: const BoxDecoration(
                                color: AppTheme.successGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.sports_baseball,
                                color: Colors.white,
                                size: isMobile ? 10 : 12,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                currentBowler.name.length > (isMobile ? 10 : 12)
                                    ? '${currentBowler.name.substring(0, isMobile ? 10 : 12)}...'
                                    : currentBowler.name,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile
                                      ? (isSmallScreen ? 12 : 13)
                                      : 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          currentBowler.oversString,
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
                          currentBowler.maidens.toString(),
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
                          currentBowler.runsConceded.toString(),
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
                          currentBowler.wickets.toString(),
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
                          currentBowler.economyRate.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getEconomyRateColor(
                              currentBowler.economyRate,
                            ),
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.all(
                    isMobile ? (isSmallScreen ? 12 : 14) : 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'No bowler selected',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: isMobile ? (isSmallScreen ? 12 : 13) : 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getEconomyRateColor(double economyRate) {
    if (economyRate <= 6.0) return AppTheme.successGreen;
    if (economyRate <= 8.0) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }
}
