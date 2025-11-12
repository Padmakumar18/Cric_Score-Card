/// Match post model for posting and discovering cricket matches
class MatchPost {
  final String id;
  final String teamName;
  final int totalPlayers;
  final String venue;
  final int totalOvers;
  final BallType ballType;
  final DateTime matchTiming;
  final MatchType matchType;
  final String creatorId;
  final MatchPostStatus status;
  final DateTime createdAt;
  final List<String> approachRequestIds;

  const MatchPost({
    required this.id,
    required this.teamName,
    required this.totalPlayers,
    required this.venue,
    required this.totalOvers,
    required this.ballType,
    required this.matchTiming,
    required this.matchType,
    required this.creatorId,
    required this.status,
    required this.createdAt,
    this.approachRequestIds = const [],
  });

  MatchPost copyWith({
    String? id,
    String? teamName,
    int? totalPlayers,
    String? venue,
    int? totalOvers,
    BallType? ballType,
    DateTime? matchTiming,
    MatchType? matchType,
    String? creatorId,
    MatchPostStatus? status,
    DateTime? createdAt,
    List<String>? approachRequestIds,
  }) {
    return MatchPost(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      venue: venue ?? this.venue,
      totalOvers: totalOvers ?? this.totalOvers,
      ballType: ballType ?? this.ballType,
      matchTiming: matchTiming ?? this.matchTiming,
      matchType: matchType ?? this.matchType,
      creatorId: creatorId ?? this.creatorId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approachRequestIds: approachRequestIds ?? this.approachRequestIds,
    );
  }

  /// Convert MatchPost to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_name': teamName,
      'total_players': totalPlayers,
      'venue': venue,
      'total_overs': totalOvers,
      'ball_type': ballType.toJson(),
      'match_timing': matchTiming.toIso8601String(),
      'match_type': matchType.toJson(),
      'creator_id': creatorId,
      'status': status.toJson(),
      'created_at': createdAt.toIso8601String(),
      'approach_request_ids': approachRequestIds,
    };
  }

  /// Create MatchPost from JSON
  factory MatchPost.fromJson(Map<String, dynamic> json) {
    return MatchPost(
      id: json['id'] as String,
      teamName: json['team_name'] as String,
      totalPlayers: json['total_players'] as int,
      venue: json['venue'] as String,
      totalOvers: json['total_overs'] as int,
      ballType: BallTypeExtension.fromJson(json['ball_type'] as String),
      matchTiming: DateTime.parse(json['match_timing'] as String),
      matchType: MatchTypeExtension.fromJson(json['match_type'] as String),
      creatorId: json['creator_id'] as String,
      status: MatchPostStatusExtension.fromJson(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      approachRequestIds:
          (json['approach_request_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

/// Ball type enum for cricket matches
enum BallType { redBall, stitchBall, tennisBall }

/// Extension for BallType enum
extension BallTypeExtension on BallType {
  String toJson() {
    switch (this) {
      case BallType.redBall:
        return 'red_ball';
      case BallType.stitchBall:
        return 'stitch_ball';
      case BallType.tennisBall:
        return 'tennis_ball';
    }
  }

  String get displayName {
    switch (this) {
      case BallType.redBall:
        return 'Red Ball';
      case BallType.stitchBall:
        return 'Stitch Ball';
      case BallType.tennisBall:
        return 'Tennis Ball';
    }
  }

  String get emoji {
    switch (this) {
      case BallType.redBall:
        return '🏏';
      case BallType.stitchBall:
        return '🧵';
      case BallType.tennisBall:
        return '🎾';
    }
  }

  static BallType fromJson(String json) {
    switch (json) {
      case 'red_ball':
        return BallType.redBall;
      case 'stitch_ball':
        return BallType.stitchBall;
      case 'tennis_ball':
        return BallType.tennisBall;
      default:
        throw ArgumentError('Invalid ball type: $json');
    }
  }
}

/// Match type enum
enum MatchType { betMatch, friendlyMatch }

/// Extension for MatchType enum
extension MatchTypeExtension on MatchType {
  String toJson() {
    switch (this) {
      case MatchType.betMatch:
        return 'bet_match';
      case MatchType.friendlyMatch:
        return 'friendly_match';
    }
  }

  String get displayName {
    switch (this) {
      case MatchType.betMatch:
        return 'Bet Match';
      case MatchType.friendlyMatch:
        return 'Friendly Match';
    }
  }

  String get emoji {
    switch (this) {
      case MatchType.betMatch:
        return '💰';
      case MatchType.friendlyMatch:
        return '🏆';
    }
  }

  static MatchType fromJson(String json) {
    switch (json) {
      case 'bet_match':
        return MatchType.betMatch;
      case 'friendly_match':
        return MatchType.friendlyMatch;
      default:
        throw ArgumentError('Invalid match type: $json');
    }
  }
}

/// Match post status enum
enum MatchPostStatus { open, pending, confirmed, cancelled }

/// Extension for MatchPostStatus enum
extension MatchPostStatusExtension on MatchPostStatus {
  String toJson() {
    switch (this) {
      case MatchPostStatus.open:
        return 'open';
      case MatchPostStatus.pending:
        return 'pending';
      case MatchPostStatus.confirmed:
        return 'confirmed';
      case MatchPostStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case MatchPostStatus.open:
        return 'Open';
      case MatchPostStatus.pending:
        return 'Pending';
      case MatchPostStatus.confirmed:
        return 'Confirmed';
      case MatchPostStatus.cancelled:
        return 'Cancelled';
    }
  }

  static MatchPostStatus fromJson(String json) {
    switch (json) {
      case 'open':
        return MatchPostStatus.open;
      case 'pending':
        return MatchPostStatus.pending;
      case 'confirmed':
        return MatchPostStatus.confirmed;
      case 'cancelled':
        return MatchPostStatus.cancelled;
      default:
        throw ArgumentError('Invalid match post status: $json');
    }
  }
}
