/// Authentication user model
class AuthUser {
  final String id;
  final String email;
  final String name;
  final bool isGuest;
  final DateTime createdAt;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.isGuest = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    bool? isGuest,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
