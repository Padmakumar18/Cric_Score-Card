/// Approach request model for requesting to participate in a match
class ApproachRequest {
  final String id;
  final String matchPostId;
  final String requestingUserId;
  final String requestingTeamName;
  final ApproachRequestStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const ApproachRequest({
    required this.id,
    required this.matchPostId,
    required this.requestingUserId,
    required this.requestingTeamName,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  ApproachRequest copyWith({
    String? id,
    String? matchPostId,
    String? requestingUserId,
    String? requestingTeamName,
    ApproachRequestStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return ApproachRequest(
      id: id ?? this.id,
      matchPostId: matchPostId ?? this.matchPostId,
      requestingUserId: requestingUserId ?? this.requestingUserId,
      requestingTeamName: requestingTeamName ?? this.requestingTeamName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  /// Convert ApproachRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_post_id': matchPostId,
      'requesting_user_id': requestingUserId,
      'requesting_team_name': requestingTeamName,
      'status': status.toJson(),
      'created_at': createdAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
    };
  }

  /// Create ApproachRequest from JSON
  factory ApproachRequest.fromJson(Map<String, dynamic> json) {
    return ApproachRequest(
      id: json['id'] as String,
      matchPostId: json['match_post_id'] as String,
      requestingUserId: json['requesting_user_id'] as String,
      requestingTeamName: json['requesting_team_name'] as String,
      status: ApproachRequestStatusExtension.fromJson(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'] as String)
          : null,
    );
  }
}

/// Approach request status enum
enum ApproachRequestStatus { pending, accepted, rejected }

/// Extension for ApproachRequestStatus enum
extension ApproachRequestStatusExtension on ApproachRequestStatus {
  String toJson() {
    switch (this) {
      case ApproachRequestStatus.pending:
        return 'pending';
      case ApproachRequestStatus.accepted:
        return 'accepted';
      case ApproachRequestStatus.rejected:
        return 'rejected';
    }
  }

  String get displayName {
    switch (this) {
      case ApproachRequestStatus.pending:
        return 'Pending';
      case ApproachRequestStatus.accepted:
        return 'Accepted';
      case ApproachRequestStatus.rejected:
        return 'Rejected';
    }
  }

  static ApproachRequestStatus fromJson(String json) {
    switch (json) {
      case 'pending':
        return ApproachRequestStatus.pending;
      case 'accepted':
        return ApproachRequestStatus.accepted;
      case 'rejected':
        return ApproachRequestStatus.rejected;
      default:
        throw ArgumentError('Invalid approach request status: $json');
    }
  }
}
