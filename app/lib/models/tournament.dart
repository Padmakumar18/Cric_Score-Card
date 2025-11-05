/// Tournament model for managing cricket tournaments
class Tournament {
  final String id;
  final String name;
  final List<String> teams;
  final TournamentFormat format;
  final List<TournamentMatch> matches;
  final Map<String, TeamStats> standings;
  final DateTime createdAt;
  final bool isComplete;

  const Tournament({
    required this.id,
    required this.name,
    required this.teams,
    required this.format,
    this.matches = const [],
    this.standings = const {},
    required this.createdAt,
    this.isComplete = false,
  });

  Tournament copyWith({
    String? id,
    String? name,
    List<String>? teams,
    TournamentFormat? format,
    List<TournamentMatch>? matches,
    Map<String, TeamStats>? standings,
    DateTime? createdAt,
    bool? isComplete,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      teams: teams ?? this.teams,
      format: format ?? this.format,
      matches: matches ?? this.matches,
      standings: standings ?? this.standings,
      createdAt: createdAt ?? this.createdAt,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

enum TournamentFormat { roundRobin, knockout }

class TournamentMatch {
  final String id;
  final String team1;
  final String team2;
  final String? winner;
  final int? team1Score;
  final int? team2Score;
  final bool isComplete;
  final DateTime scheduledDate;

  const TournamentMatch({
    required this.id,
    required this.team1,
    required this.team2,
    this.winner,
    this.team1Score,
    this.team2Score,
    this.isComplete = false,
    required this.scheduledDate,
  });

  TournamentMatch copyWith({
    String? id,
    String? team1,
    String? team2,
    String? winner,
    int? team1Score,
    int? team2Score,
    bool? isComplete,
    DateTime? scheduledDate,
  }) {
    return TournamentMatch(
      id: id ?? this.id,
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      winner: winner ?? this.winner,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      isComplete: isComplete ?? this.isComplete,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }
}

class TeamStats {
  final String teamName;
  final int played;
  final int won;
  final int lost;
  final int points;
  final double netRunRate;

  const TeamStats({
    required this.teamName,
    this.played = 0,
    this.won = 0,
    this.lost = 0,
    this.points = 0,
    this.netRunRate = 0.0,
  });

  TeamStats copyWith({
    String? teamName,
    int? played,
    int? won,
    int? lost,
    int? points,
    double? netRunRate,
  }) {
    return TeamStats(
      teamName: teamName ?? this.teamName,
      played: played ?? this.played,
      won: won ?? this.won,
      lost: lost ?? this.lost,
      points: points ?? this.points,
      netRunRate: netRunRate ?? this.netRunRate,
    );
  }
}
