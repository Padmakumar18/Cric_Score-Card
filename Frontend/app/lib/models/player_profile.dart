/// Player profile model with qualifications and statistics
class PlayerProfile {
  final String id;
  final String name;
  final String role; // Batsman, Bowler, All-rounder, Wicket-keeper
  final String battingStyle; // Right-hand, Left-hand
  final String bowlingStyle; // Right-arm fast, Left-arm spin, etc.
  final DateTime? dateOfBirth;
  final String? team;
  final String? nationality;

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

  // Additional Info
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlayerProfile({
    required this.id,
    required this.name,
    this.role = 'Batsman',
    this.battingStyle = 'Right-hand',
    this.bowlingStyle = 'Right-arm medium',
    this.dateOfBirth,
    this.team,
    this.nationality,
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
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  PlayerProfile copyWith({
    String? id,
    String? name,
    String? role,
    String? battingStyle,
    String? bowlingStyle,
    DateTime? dateOfBirth,
    String? team,
    String? nationality,
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
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      battingStyle: battingStyle ?? this.battingStyle,
      bowlingStyle: bowlingStyle ?? this.bowlingStyle,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      team: team ?? this.team,
      nationality: nationality ?? this.nationality,
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
      notes: notes ?? this.notes,
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
}
