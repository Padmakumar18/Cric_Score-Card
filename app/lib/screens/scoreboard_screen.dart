import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/modern_score_display.dart';
import '../widgets/modern_batsmen_card.dart';
import '../widgets/modern_bowler_card.dart';
import '../widgets/modern_score_buttons.dart';
import '../widgets/modern_action_buttons.dart';
import '../widgets/player_dialogs.dart';
import '../constants/app_constants.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  bool _isDialogShowing = false;
  int _lastCheckedBalls = -1;
  int _lastCheckedWickets = -1;
  bool _hasShownResultDialog = false;
  String? _lastShownWicket;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForDialogs();
    });
  }

  void _checkForDialogs() {
    final provider = context.read<MatchProvider>();
    final match = provider.currentMatch;

    if (match == null) return;

    // Check for wicket notification
    if (provider.lastWicketInfo != null &&
        provider.lastWicketInfo != _lastShownWicket) {
      _lastShownWicket = provider.lastWicketInfo;
      _showWicketNotification(provider.lastWicketInfo!);
      // Clear the wicket info after showing
      Future.delayed(const Duration(milliseconds: 100), () {
        provider.clearLastWicketInfo();
      });
    }

    // Debug: Print match status
    debugPrint('Match status: ${match.status}');
    debugPrint('Has shown result dialog: $_hasShownResultDialog');

    // Check if match is completed and show result dialog (highest priority)
    if (match.status == AppConstants.statusCompleted &&
        !_hasShownResultDialog) {
      debugPrint('Showing match result dialog');
      _hasShownResultDialog = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          debugPrint('Displaying result: ${match.result}');
          _showMatchResultDialog(context, match.result ?? 'Match completed');
        }
      });
      return;
    }

    // Don't show other dialogs if one is already showing or match is completed
    if (_isDialogShowing || match.status == AppConstants.statusCompleted) {
      return;
    }

    final currentBalls = match.currentInnings?.ballsBowled ?? 0;
    final currentWickets = match.currentInnings?.wickets ?? 0;

    // Check if first innings is complete and need to start second innings
    if (match.isFirstInningsComplete &&
        match.status == AppConstants.statusFirstInnings) {
      _isDialogShowing = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isDialogShowing)
          return; // Double-check dialog isn't already dismissed
        PlayerDialogs.showInningsSwitchDialog(context, provider).then((_) {
          if (mounted) {
            setState(() {
              _isDialogShowing = false;
              _lastCheckedBalls = currentBalls;
              _lastCheckedWickets = currentWickets;
            });
          }
        });
      });
    }
    // Check if new bowler is needed
    else if (provider.needsNewBowler && _lastCheckedBalls != currentBalls) {
      _lastCheckedBalls =
          currentBalls; // Update immediately to prevent duplicate
      _isDialogShowing = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isDialogShowing)
          return; // Double-check dialog isn't already dismissed
        PlayerDialogs.showNewBowlerDialog(context, provider).then((_) {
          if (mounted) {
            setState(() {
              _isDialogShowing = false;
              _lastCheckedBalls = currentBalls;
            });
          }
        });
      });
    }
    // Check if new batsman is needed (check wickets instead of balls)
    else if (provider.needsNewBatsman &&
        _lastCheckedWickets != currentWickets) {
      _lastCheckedWickets =
          currentWickets; // Update immediately to prevent duplicate
      _isDialogShowing = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isDialogShowing)
          return; // Double-check dialog isn't already dismissed
        PlayerDialogs.showNewBatsmanDialog(context, provider).then((_) {
          if (mounted) {
            setState(() {
              _isDialogShowing = false;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.sports_cricket, size: 24),
            const SizedBox(width: 8),
            Consumer<MatchProvider>(
              builder: (context, provider, child) {
                final match = provider.currentMatch;
                if (match == null) return const Text('Cricket Scoreboard');
                return Text('${match.team1} vs ${match.team2}');
              },
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<MatchProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  Icons.undo,
                  color: provider.canUndo ? Colors.white : Colors.white38,
                ),
                onPressed: provider.canUndo ? provider.undoLastBall : null,
                tooltip: 'Undo Last Ball',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog(context);
            },
            tooltip: 'Reset Match',
          ),
        ],
      ),
      body: Consumer<MatchProvider>(
        builder: (context, provider, child) {
          final match = provider.currentMatch;

          if (match == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_cricket,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No match in progress',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          // Check for dialogs after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkForDialogs();
          });

          return ResponsiveLayout(
            mobile: _buildMobileLayout(context),
            tablet: _buildTabletLayout(context),
            desktop: _buildDesktopLayout(context),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      child: Column(
        children: [
          const ModernScoreDisplay(),
          SizedBox(height: isSmallScreen ? 8 : 12),
          // Combined Controls Card
          _buildCombinedControlsCard(isSmallScreen),
          SizedBox(height: isSmallScreen ? 8 : 12),
          // Combined Players Card
          _buildCombinedPlayersCard(isSmallScreen),
          SizedBox(height: isSmallScreen ? 8 : 16), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildCombinedPlayersCard(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        border: Border.all(
          color: AppTheme.textTertiary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const ModernBatsmenCard(),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Divider(
            color: AppTheme.textTertiary.withValues(alpha: 0.3),
            thickness: 1,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          const ModernBowlerCard(),
        ],
      ),
    );
  }

  Widget _buildCombinedControlsCard(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        border: Border.all(
          color: AppTheme.textTertiary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const ModernActionButtons(),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Divider(
            color: AppTheme.textTertiary.withValues(alpha: 0.3),
            thickness: 1,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          const ModernScoreButtons(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeTablet = screenWidth >= 900;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeTablet ? 32 : 20,
        vertical: isLargeTablet ? 24 : 16,
      ),
      child: Column(
        children: [
          const ModernScoreDisplay(),
          SizedBox(height: isLargeTablet ? 20 : 16),
          // Combined Controls Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isLargeTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.textTertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: ModernActionButtons()),
                SizedBox(width: isLargeTablet ? 20 : 16),
                Container(
                  width: 1,
                  height: 200,
                  color: AppTheme.textTertiary.withValues(alpha: 0.3),
                ),
                SizedBox(width: isLargeTablet ? 20 : 16),
                const Expanded(child: ModernScoreButtons()),
              ],
            ),
          ),
          SizedBox(height: isLargeTablet ? 20 : 16),
          // Combined Players Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isLargeTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.textTertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: ModernBatsmenCard()),
                SizedBox(width: isLargeTablet ? 20 : 16),
                Container(
                  width: 1,
                  height: 200,
                  color: AppTheme.textTertiary.withValues(alpha: 0.3),
                ),
                SizedBox(width: isLargeTablet ? 20 : 16),
                const Expanded(child: ModernBowlerCard()),
              ],
            ),
          ),
          const SizedBox(height: 16), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const ModernScoreDisplay(),
          const SizedBox(height: 24),
          // Combined Controls Card
          Container(
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
              children: [
                const ModernActionButtons(),
                const SizedBox(height: 20),
                Divider(
                  color: AppTheme.textTertiary.withValues(alpha: 0.3),
                  thickness: 1,
                ),
                const SizedBox(height: 20),
                const ModernScoreButtons(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Combined Players Card
          Container(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: ModernBatsmenCard()),
                const SizedBox(width: 24),
                Container(
                  width: 1,
                  height: 200,
                  color: AppTheme.textTertiary.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 24),
                const Expanded(child: ModernBowlerCard()),
              ],
            ),
          ),
          const SizedBox(height: 16), // Bottom padding
        ],
      ),
    );
  }

  void _showMatchResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppTheme.successGreen,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Match Completed!',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  result,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '🎉 Congratulations! 🎉',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<MatchProvider>().resetMatch();
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.home),
                label: const Text(
                  'Go to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWicketNotification(String wicketInfo) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'WICKET!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wicketInfo,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          title: const Text(
            'Reset Match',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: const Text(
            'Are you sure you want to reset the current match? This action cannot be undone.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<MatchProvider>().resetMatch();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
