/// User profile model for the app user's personal information
class UserProfile {
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;
  final DateTime? dateOfBirth;
  final String? favoriteTeam;
  final String? role; // Player, Coach, Umpire, Scorer, Fan
  final String? bio;
  final String? profileImagePath;

  // Playing Style
  final String? battingStyle; // Right-hand, Left-hand
  final String? bowlingStyle; // Right-arm fast, Left-arm spin, etc.

  // Career Statistics
  final int matchesPlayed;
  final int totalRuns;
  final int totalWickets;
  final double battingAverage;
  final double bowlingAverage;
  final int centuries;
  final int halfCenturies;
  final int fiveWicketHauls;
  final int highestScore;
  final String? bestBowling;

  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.dateOfBirth,
    this.favoriteTeam,
    this.role,
    this.bio,
    this.profileImagePath,
    this.battingStyle,
    this.bowlingStyle,
    this.matchesPlayed = 0,
    this.totalRuns = 0,
    this.totalWickets = 0,
    this.battingAverage = 0.0,
    this.bowlingAverage = 0.0,
    this.centuries = 0,
    this.halfCenturies = 0,
    this.fiveWicketHauls = 0,
    this.highestScore = 0,
    this.bestBowling,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? favoriteTeam,
    String? role,
    String? bio,
    String? profileImagePath,
    String? battingStyle,
    String? bowlingStyle,
    int? matchesPlayed,
    int? totalRuns,
    int? totalWickets,
    double? battingAverage,
    double? bowlingAverage,
    int? centuries,
    int? halfCenturies,
    int? fiveWicketHauls,
    int? highestScore,
    String? bestBowling,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      favoriteTeam: favoriteTeam ?? this.favoriteTeam,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      battingStyle: battingStyle ?? this.battingStyle,
      bowlingStyle: bowlingStyle ?? this.bowlingStyle,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      totalRuns: totalRuns ?? this.totalRuns,
      totalWickets: totalWickets ?? this.totalWickets,
      battingAverage: battingAverage ?? this.battingAverage,
      bowlingAverage: bowlingAverage ?? this.bowlingAverage,
      centuries: centuries ?? this.centuries,
      halfCenturies: halfCenturies ?? this.halfCenturies,
      fiveWicketHauls: fiveWicketHauls ?? this.fiveWicketHauls,
      highestScore: highestScore ?? this.highestScore,
      bestBowling: bestBowling ?? this.bestBowling,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get age {
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
