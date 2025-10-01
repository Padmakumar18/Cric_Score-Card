import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/score_header.dart';
import '../widgets/batting_section.dart';
import '../widgets/bowling_section.dart';
import '../widgets/scoring_controls.dart';
import '../widgets/over_summary.dart';
import '../theme/app_theme.dart';

/// Main scoreboard screen showing live match data
class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        final match = matchProvider.currentMatch;

        if (match == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Scoreboard')),
            body: const Center(child: Text('No match in progress')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${match.team1} vs ${match.team2}'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _showResetDialog(context),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'undo',
                    child: Row(
                      children: [
                        Icon(Icons.undo),
                        SizedBox(width: 8),
                        Text('Undo Last Ball'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit Score'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: ResponsiveLayout(
            mobile: _buildMobileLayout(context, match),
            tablet: _buildTabletLayout(context, match),
            desktop: _buildDesktopLayout(context, match),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, match) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ScoreHeader(),
          const SizedBox(height: 16),
          const OverSummary(),
          const SizedBox(height: 16),
          const BattingSection(),
          const SizedBox(height: 16),
          const BowlingSection(),
          const SizedBox(height: 16),
          const ScoringControls(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, match) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ScoreHeader(),
          const SizedBox(height: 16),
          const OverSummary(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: BattingSection()),
              const SizedBox(width: 16),
              const Expanded(child: BowlingSection()),
            ],
          ),
          const SizedBox(height: 16),
          const ScoringControls(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, match) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ScoreHeader(),
                const SizedBox(height: 16),
                const OverSummary(),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: BattingSection()),
                    const SizedBox(width: 16),
                    const Expanded(child: BowlingSection()),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(flex: 1, child: ScoringControls()),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    final matchProvider = context.read<MatchProvider>();

    switch (action) {
      case 'undo':
        matchProvider.undoLastBall();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Last ball undone')));
        break;
      case 'edit':
        _showEditScoreDialog(context);
        break;
    }
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Match'),
        content: const Text(
          'Are you sure you want to reset the match? All data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MatchProvider>().resetMatch();
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to home
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showEditScoreDialog(BuildContext context) {
    // TODO: Implement edit score dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit score feature coming soon!')),
    );
  }
}
