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
import '../widgets/current_over_display.dart';
import '../widgets/player_dialogs.dart';
import '../constants/app_constants.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
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

    // Check if first innings is complete and need to start second innings
    if (match.isFirstInningsComplete &&
        match.status == AppConstants.statusFirstInnings) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          PlayerDialogs.showInningsSwitchDialog(context, provider);
        }
      });
    }
    // Check if new bowler is needed
    else if (provider.needsNewBowler) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          PlayerDialogs.showNewBowlerDialog(context, provider);
        }
      });
    }
    // Check if new batsman is needed
    else if (provider.needsNewBatsman) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          PlayerDialogs.showNewBatsmanDialog(context, provider);
        }
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ModernScoreDisplay(),
          const SizedBox(height: 16),
          const CurrentOverDisplay(),
          const SizedBox(height: 16),
          const ModernBatsmenCard(),
          const SizedBox(height: 16),
          const ModernBowlerCard(),
          const SizedBox(height: 16),
          const ModernActionButtons(),
          const SizedBox(height: 16),
          const ModernScoreButtons(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const ModernScoreDisplay(),
          const SizedBox(height: 20),
          const CurrentOverDisplay(),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: ModernBatsmenCard()),
              const SizedBox(width: 20),
              const Expanded(child: ModernBowlerCard()),
            ],
          ),
          const SizedBox(height: 20),
          const ModernActionButtons(),
          const SizedBox(height: 20),
          const ModernScoreButtons(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const ModernScoreDisplay(),
                const SizedBox(height: 24),
                const CurrentOverDisplay(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: ModernBatsmenCard()),
                    const SizedBox(width: 24),
                    const Expanded(child: ModernBowlerCard()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const ModernActionButtons(),
                const SizedBox(height: 24),
                const ModernScoreButtons(),
              ],
            ),
          ),
        ],
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
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.accentBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<MatchProvider>().resetMatch();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
