import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import '../models/innings.dart';

class ScorecardScreen extends StatelessWidget {
  const ScorecardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.list_alt, size: 22),
            SizedBox(width: 8),
            Text('Match Scorecard'),
          ],
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<MatchProvider>(
        builder: (context, provider, child) {
          final match = provider.currentMatch;

          if (match == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.sports_cricket,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No match data available',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              isMobile
                  ? 12
                  : isTablet
                  ? 20
                  : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Match Header
                _buildMatchHeader(
                  match.team1,
                  match.team2,
                  match.result,
                  isMobile,
                ),
                const SizedBox(height: 20),

                // First Innings
                if (match.firstInnings != null) ...[
                  _buildInningsCard(
                    match.firstInnings!,
                    'First Innings',
                    match.oversPerInnings,
                    context,
                    isMobile,
                  ),
                  const SizedBox(height: 20),
                ],

                // Second Innings
                if (match.secondInnings != null) ...[
                  _buildInningsCard(
                    match.secondInnings!,
                    'Second Innings',
                    match.oversPerInnings,
                    context,
                    isMobile,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchHeader(
    String team1,
    String team2,
    String? result,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryBlue, AppTheme.lightBlue],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  team1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  team2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInningsCard(
    Innings innings,
    String title,
    int totalOvers,
    BuildContext context,
    bool isMobile,
  ) {
    final currentOver = innings.overs.isNotEmpty ? innings.overs.last : null;
    final currentOverRuns = currentOver?.runsScored ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.textTertiary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Innings Header with Score
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.15),
                  AppTheme.accentBlue.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentBlue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              title.toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.accentBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            innings.battingTeam,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: isMobile ? 20 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${innings.totalRuns}',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: isMobile ? 32 : 36,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            Text(
                              '/${innings.wickets}',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: isMobile ? 20 : 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '(${innings.oversString}/$totalOvers ov)',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats Row
                _buildStatsRow(innings, currentOverRuns, totalOvers, isMobile),
              ],
            ),
          ),

          // Batting Section
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.sports_cricket,
                      size: 18,
                      color: AppTheme.accentBlue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'BATTING',
                      style: TextStyle(
                        color: AppTheme.accentBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildBattingTable(innings, isMobile),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.textTertiary.withValues(alpha: 0.1),
          ),

          // Bowling Section
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.sports, size: 18, color: AppTheme.successGreen),
                    SizedBox(width: 8),
                    Text(
                      'BOWLING',
                      style: TextStyle(
                        color: AppTheme.successGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildBowlingTable(innings, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    Innings innings,
    int currentOverRuns,
    int totalOvers,
    bool isMobile,
  ) {
    final rrr = innings.getRequiredRunRate(totalOvers);
    final projected = innings.getProjectedTotal(totalOvers);

    return Wrap(
      spacing: isMobile ? 8 : 12,
      runSpacing: 8,
      children: [
        _buildStatCard(
          'Run Rate',
          innings.runRate.toStringAsFixed(2),
          AppTheme.accentBlue,
          Icons.speed,
          isMobile,
        ),
        if (innings.target > 0) ...[
          _buildStatCard(
            'Required RR',
            rrr > 0 ? rrr.toStringAsFixed(2) : '-',
            AppTheme.errorRed,
            Icons.trending_up,
            isMobile,
          ),
          _buildStatCard(
            'Target',
            innings.target.toString(),
            AppTheme.warningOrange,
            Icons.flag,
            isMobile,
          ),
        ] else ...[
          _buildStatCard(
            'Projected',
            projected.toString(),
            AppTheme.successGreen,
            Icons.analytics,
            isMobile,
          ),
        ],
        _buildStatCard(
          'This Over',
          currentOverRuns.toString(),
          AppTheme.primaryBlue,
          Icons.circle,
          isMobile,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 12,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBattingTable(Innings innings, bool isMobile) {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 10 : 12,
            horizontal: isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.surfaceBlue.withValues(alpha: 0.8),
                AppTheme.surfaceBlue.withValues(alpha: 0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text(
                  'Batsman',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'R',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'B',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  '4s',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  '6s',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'SR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Batsmen Rows
        ...innings.batsmen.map((batsman) {
          final isCurrentlyBatting =
              !batsman.isOut &&
              innings.batsmen.where((b) => !b.isOut).take(2).contains(batsman);

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: batsman.isOut
                  ? AppTheme.surfaceDark
                  : isCurrentlyBatting
                  ? AppTheme.successGreen.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isCurrentlyBatting
                  ? Border.all(
                      color: AppTheme.successGreen.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isCurrentlyBatting) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: batsman.isOnStrike
                                    ? AppTheme.successGreen
                                    : AppTheme.accentBlue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 6,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    batsman.isOnStrike ? 'LIVE' : 'BAT',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              batsman.name,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                                fontWeight: isCurrentlyBatting
                                    ? FontWeight.w600
                                    : batsman.isOut
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (batsman.isOut) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              size: 12,
                              color: AppTheme.errorRed.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                batsman.dismissalInfo ?? 'out',
                                style: TextStyle(
                                  color: AppTheme.errorRed.withValues(
                                    alpha: 0.9,
                                  ),
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    batsman.runs.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    batsman.ballsFaced.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    batsman.fours.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    batsman.sixes.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    batsman.strikeRate.toStringAsFixed(0),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        // Extras
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceBlue.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.textTertiary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.add_circle_outline,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Extras',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                innings.extras.toString(),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Total
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue.withValues(alpha: 0.15),
                AppTheme.accentBlue.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${innings.totalRuns}/${innings.wickets} (${innings.oversString} ov)',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBowlingTable(Innings innings, bool isMobile) {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 10 : 12,
            horizontal: isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.surfaceBlue.withValues(alpha: 0.8),
                AppTheme.surfaceBlue.withValues(alpha: 0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Bowler',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'O',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'M',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'R',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 35,
                child: Text(
                  'W',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 45,
                child: Text(
                  'Econ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Bowlers Rows
        ...innings.bowlers.map((bowler) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: bowler.isCurrentBowler
                  ? AppTheme.successGreen.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    bowler.name,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: bowler.isCurrentBowler
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    bowler.oversString,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    bowler.maidens.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    bowler.runsConceded.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    bowler.wickets.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 45,
                  child: Text(
                    bowler.economyRate.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
