import 'package:flutter/foundation.dart';
import '../models/player_profile.dart';

class PlayerProfileProvider extends ChangeNotifier {
  final List<PlayerProfile> _players = [];

  List<PlayerProfile> get players => _players;

  void addPlayer(PlayerProfile player) {
    _players.add(player);
    notifyListeners();
  }

  void updatePlayer(PlayerProfile updatedPlayer) {
    final index = _players.indexWhere((p) => p.id == updatedPlayer.id);
    if (index != -1) {
      _players[index] = updatedPlayer.copyWith(updatedAt: DateTime.now());
      notifyListeners();
    }
  }

  void deletePlayer(String playerId) {
    _players.removeWhere((p) => p.id == playerId);
    notifyListeners();
  }

  PlayerProfile? getPlayerById(String id) {
    try {
      return _players.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  PlayerProfile? getPlayerByName(String name) {
    try {
      return _players.firstWhere(
        (p) => p.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  List<PlayerProfile> searchPlayers(String query) {
    if (query.isEmpty) return _players;
    return _players
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              (p.team?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();
  }

  List<PlayerProfile> getPlayersByRole(String role) {
    return _players.where((p) => p.role == role).toList();
  }
}
