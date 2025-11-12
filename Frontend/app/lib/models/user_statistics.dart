import 'match_post.dart';

/// User statistics model for tracking match participation and outcomes
class UserStatistics {
  final String userId;
  final int totalMatchesPosted;
  final int totalMatchesApproached;
  final int totalMatchesPlayed;
  final int totalWins;
  final int totalLosses;
  final int totalDraws;
  final Map<BallType, int> matchesByBallType;
  final DateTime lastUpdated;

  const UserStatistics({
    required this.userId,
    this.totalMatchesPosted = 0,
    this.totalMatchesApproached = 0,
    this.totalMatchesPlayed = 0,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.totalDraws = 0,
    this.matchesByBallType = const {},
    required this.lastUpdated,
  });

  UserStatistics copyWith({
    String? userId,
    int? totalMatchesPosted,
    int? totalMatchesApproached,
    int? totalMatchesPlayed,
    int? totalWins,
    int? totalLosses,
    int? totalDraws,
    Map<BallType, int>? matchesByBallType,
    DateTime? lastUpdated,
  }) {
    return UserStatistics(
      userId: userId ?? this.userId,
      totalMatchesPosted: totalMatchesPosted ?? this.totalMatchesPosted,
      totalMatchesApproached:
          totalMatchesApproached ?? this.totalMatchesApproached,
      totalMatchesPlayed: totalMatchesPlayed ?? this.totalMatchesPlayed,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      totalDraws: totalDraws ?? this.totalDraws,
      matchesByBallType: matchesByBallType ?? this.matchesByBallType,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Calculate win percentage
  double get winPercentage {
    if (totalMatchesPlayed == 0) return 0.0;
    return (totalWins / totalMatchesPlayed) * 100;
  }

  /// Get matches played with specific ball type
  int getMatchesByBallType(BallType ballType) {
    return matchesByBallType[ballType] ?? 0;
  }

  /// Convert UserStatistics to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_matches_posted': totalMatchesPosted,
      'total_matches_approached': totalMatchesApproached,
      'total_matches_played': totalMatchesPlayed,
      'total_wins': totalWins,
      'total_losses': totalLosses,
      'total_draws': totalDraws,
      'matches_by_ball_type': {
        'red_ball': matchesByBallType[BallType.redBall] ?? 0,
        'stitch_ball': matchesByBallType[BallType.stitchBall] ?? 0,
        'tennis_ball': matchesByBallType[BallType.tennisBall] ?? 0,
      },
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  /// Create UserStatistics from JSON
  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    final ballTypeMap = json['matches_by_ball_type'] as Map<String, dynamic>?;

    return UserStatistics(
      userId: json['user_id'] as String,
      totalMatchesPosted: json['total_matches_posted'] as int? ?? 0,
      totalMatchesApproached: json['total_matches_approached'] as int? ?? 0,
      totalMatchesPlayed: json['total_matches_played'] as int? ?? 0,
      totalWins: json['total_wins'] as int? ?? 0,
      totalLosses: json['total_losses'] as int? ?? 0,
      totalDraws: json['total_draws'] as int? ?? 0,
      matchesByBallType: ballTypeMap != null
          ? {
              BallType.redBall: ballTypeMap['red_ball'] as int? ?? 0,
              BallType.stitchBall: ballTypeMap['stitch_ball'] as int? ?? 0,
              BallType.tennisBall: ballTypeMap['tennis_ball'] as int? ?? 0,
            }
          : {},
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}
