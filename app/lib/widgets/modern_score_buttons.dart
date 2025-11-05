import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';

class ModernScoreButtons extends StatelessWidget {
  const ModernScoreButtons({super.key});

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

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score Runs',
                style: TextStyle(
                  fontSize: isMobile ? (isSmallScreen ? 15 : 16) : 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: isMobile ? (isSmallScreen ? 10 : 12) : 16),

              // First Row - 0, 1, 2, 3
              Row(
                children: [
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      '0',
                      AppTheme.dotBallColor,
                      () => _handleScore(provider, 0),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      '1',
                      AppTheme.lightBlue,
                      () => _handleScore(provider, 1),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      '2',
                      AppTheme.lightBlue,
                      () => _handleScore(provider, 2),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      '3',
                      AppTheme.lightBlue,
                      () => _handleScore(provider, 3),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                ],
              ),

              SizedBox(height: isMobile ? (isSmallScreen ? 8 : 10) : 12),

              // Second Row - 4, 5, 6, More
              Row(
                children: [
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      '4',
                      AppTheme.boundaryColor,
                      () => _handleScore(provider, 4),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      '5',
                      AppTheme.lightBlue,
                      () => _handleScore(provider, 5),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      '6',
                      AppTheme.sixColor,
                      () => _handleScore(provider, 6),
                      isMobile,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isMobile ? (isSmallScreen ? 6 : 7) : 8),
                  Expanded(
                    child: _buildScoreButton(
                      context,
                      'More',
                      AppTheme.accentBlue,
                      () => _showMoreRunsDialog(context, provider),
                      isMobile,
                      isSmallScreen,
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

  Widget _buildScoreButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onPressed,
    bool isMobile,
    bool isSmallScreen,
  ) {
    return SizedBox(
      height: isMobile ? (isSmallScreen ? 50 : 55) : 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: color.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          ),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? (isSmallScreen ? 16 : 17) : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleScore(MatchProvider provider, int runs) {
    provider.addBallEvent(runs: runs);

    // Switch strike on odd runs
    if (runs % 2 == 1) {
      provider.switchStrike();
    }

    // Haptic feedback for better UX
    HapticFeedback.lightImpact();
  }

  void _showMoreRunsDialog(BuildContext context, MatchProvider provider) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: AppTheme.accentBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Enter Runs',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter the number of runs scored (more than 6):',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., 7, 8, 9...',
                  hintStyle: const TextStyle(color: AppTheme.textTertiary),
                  filled: true,
                  fillColor: AppTheme.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.accentBlue,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
              ),
              const SizedBox(height: 16),

              // Quick buttons for common high scores
              const Text(
                'Quick select:',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [7, 8, 9, 10, 12]
                    .map(
                      (runs) => SizedBox(
                        width: 50,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.text = runs.toString();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentBlue.withValues(
                              alpha: 0.2,
                            ),
                            foregroundColor: AppTheme.accentBlue,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            runs.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final runsText = controller.text.trim();
                if (runsText.isNotEmpty) {
                  final runs = int.tryParse(runsText);
                  if (runs != null && runs > 6) {
                    _handleScore(provider, runs);
                    Navigator.of(context).pop();
                  } else {
                    // Show error for invalid input
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid number greater than 6',
                        ),
                        backgroundColor: AppTheme.errorRed,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Runs',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
