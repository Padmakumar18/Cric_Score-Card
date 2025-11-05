import 'package:flutter/material.dart';
import '../models/tournament.dart';

class TournamentProvider extends ChangeNotifier {
  final List<Tournament> _tournaments = [];
  Tournament? _currentTournament;
  String? _currentTournamentMatchId;

  List<Tournament> get tournaments => _tournaments;
  Tournament? get currentTournament => _currentTournament;
  String? get currentTournamentMatchId => _currentTournamentMatchId;

  void startTournamentMatch(String matchId) {
    _currentTournamentMatchId = matchId;
    notifyListeners();
  }

  void clearTournamentMatch() {
    _currentTournamentMatchId = null;
    notifyListeners();
  }

  void createTournament({
    required String name,
    required List<String> teams,
    required TournamentFormat format,
    bool shuffleTeams = false,
  }) {
    final finalTeams = shuffleTeams
        ? (List<String>.from(teams)..shuffle())
        : teams;

    final tournament = Tournament(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      teams: finalTeams,
      format: format,
      createdAt: DateTime.now(),
      standings: _initializeStandings(finalTeams),
      matches: _generateFixtures(finalTeams, format),
    );

    _tournaments.add(tournament);
    _currentTournament = tournament;
    notifyListeners();
  }

  void updateMatchResult({
    required String matchId,
    required String winner,
    required int team1Score,
    required int team2Score,
  }) {
    if (_currentTournament == null) return;

    final matchIndex = _currentTournament!.matches.indexWhere(
      (m) => m.id == matchId,
    );
    if (matchIndex == -1) return;

    final match = _currentTournament!.matches[matchIndex];
    final updatedMatch = match.copyWith(
      winner: winner,
      team1Score: team1Score,
      team2Score: team2Score,
      isComplete: true,
    );

    final updatedMatches = List<TournamentMatch>.from(
      _currentTournament!.matches,
    );
    updatedMatches[matchIndex] = updatedMatch;

    final updatedStandings = Map<String, TeamStats>.from(
      _currentTournament!.standings,
    );
    _updateStandings(updatedStandings, updatedMatch);

    _currentTournament = _currentTournament!.copyWith(
      matches: updatedMatches,
      standings: updatedStandings,
    );

    final tournamentIndex = _tournaments.indexWhere(
      (t) => t.id == _currentTournament!.id,
    );
    if (tournamentIndex != -1) {
      _tournaments[tournamentIndex] = _currentTournament!;
    }

    notifyListeners();
  }

  void _updateStandings(
    Map<String, TeamStats> standings,
    TournamentMatch match,
  ) {
    final team1Stats = standings[match.team1]!;
    final team2Stats = standings[match.team2]!;

    if (match.winner == match.team1) {
      standings[match.team1] = team1Stats.copyWith(
        played: team1Stats.played + 1,
        won: team1Stats.won + 1,
        points: team1Stats.points + 2,
      );
      standings[match.team2] = team2Stats.copyWith(
        played: team2Stats.played + 1,
        lost: team2Stats.lost + 1,
      );
    } else {
      standings[match.team2] = team2Stats.copyWith(
        played: team2Stats.played + 1,
        won: team2Stats.won + 1,
        points: team2Stats.points + 2,
      );
      standings[match.team1] = team1Stats.copyWith(
        played: team1Stats.played + 1,
        lost: team1Stats.lost + 1,
      );
    }
  }

  TournamentMatch? get nextMatch {
    if (_currentTournament == null) return null;
    try {
      return _currentTournament!.matches.firstWhere((m) => !m.isComplete);
    } catch (e) {
      return null;
    }
  }

  List<TournamentMatch> get completedMatches {
    if (_currentTournament == null) return [];
    return _currentTournament!.matches.where((m) => m.isComplete).toList();
  }

  Map<String, TeamStats> _initializeStandings(List<String> teams) {
    final standings = <String, TeamStats>{};
    for (final team in teams) {
      standings[team] = TeamStats(teamName: team);
    }
    return standings;
  }

  List<TournamentMatch> _generateFixtures(
    List<String> teams,
    TournamentFormat format,
  ) {
    final matches = <TournamentMatch>[];
    var matchId = 1;

    if (format == TournamentFormat.roundRobin) {
      for (var i = 0; i < teams.length; i++) {
        for (var j = i + 1; j < teams.length; j++) {
          matches.add(
            TournamentMatch(
              id: 'match_$matchId',
              team1: teams[i],
              team2: teams[j],
              scheduledDate: DateTime.now().add(Duration(days: matchId - 1)),
            ),
          );
          matchId++;
        }
      }
    }
    return matches;
  }

  void selectTournament(String tournamentId) {
    _currentTournament = _tournaments.firstWhere((t) => t.id == tournamentId);
    notifyListeners();
  }

  void deleteTournament(String tournamentId) {
    _tournaments.removeWhere((t) => t.id == tournamentId);
    if (_currentTournament?.id == tournamentId) {
      _currentTournament = null;
      _currentTournamentMatchId = null;
    }
    notifyListeners();
  }
}
