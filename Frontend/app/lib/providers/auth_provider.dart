import 'package:flutter/foundation.dart';
import '../models/auth_user.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser? _currentUser;
  final Map<String, AuthUser> _users = {}; // Simple in-memory storage

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isGuest => _currentUser?.isGuest ?? false;
  bool get isLoggedIn => _currentUser != null && !_currentUser!.isGuest;

  // Sign up new user
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Check if email already exists
    if (_users.containsKey(email.toLowerCase())) {
      return false;
    }

    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.toLowerCase(),
      name: name,
      isGuest: false,
    );

    _users[email.toLowerCase()] = user;
    _currentUser = user;
    notifyListeners();
    return true;
  }

  // Login existing user
  Future<bool> login({required String email, required String password}) async {
    final user = _users[email.toLowerCase()];
    if (user == null) {
      return false;
    }

    _currentUser = user;
    notifyListeners();
    return true;
  }

  // Continue as guest
  void continueAsGuest() {
    _currentUser = AuthUser(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@cricket.app',
      name: 'Guest User',
      isGuest: true,
    );
    notifyListeners();
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Check if user can access feature
  bool canAccessFeature(String feature) {
    if (!isAuthenticated) return false;
    if (isGuest) {
      // Guest users can only access quick match
      return feature == 'quick_match';
    }
    return true;
  }
}
