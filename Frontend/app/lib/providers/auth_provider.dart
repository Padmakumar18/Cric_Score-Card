import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser? _currentUser;
  bool _isInitialized = false;
  String? _errorMessage;

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isGuest => _currentUser?.isGuest ?? false;
  bool get isLoggedIn => _currentUser != null && !_currentUser!.isGuest;
  String? get errorMessage => _errorMessage;

  // Initialize provider and check for saved session
  Future<void> init() async {
    if (_isInitialized) return;

    await _loadSavedUser();
    _isInitialized = true;
  }

  // Load saved user from local storage
  Future<void> _loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final userEmail = prefs.getString('user_email');
      final userName = prefs.getString('user_name');
      final isGuest = prefs.getBool('is_guest') ?? false;

      if (userId != null && userEmail != null && userName != null) {
        _currentUser = AuthUser(
          id: userId,
          email: userEmail,
          name: userName,
          isGuest: isGuest,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved user: $e');
    }
  }

  // Save user to local storage
  Future<void> _saveUser(AuthUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_name', user.name);
      await prefs.setBool('is_guest', user.isGuest);
    } catch (e) {
      debugPrint('Error saving user: $e');
    }
  }

  // Clear saved user
  Future<void> _clearSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('is_guest');
    } catch (e) {
      debugPrint('Error clearing saved user: $e');
    }
  }

  // Sign up new user (local storage only)
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _errorMessage = null;

      // Check if user already exists
      final prefs = await SharedPreferences.getInstance();
      final existingEmail = prefs.getString('registered_email');

      if (existingEmail == email) {
        _errorMessage = 'Email already exists';
        return false;
      }

      // Create new user
      final user = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        isGuest: false,
      );

      // Save credentials for login
      await prefs.setString('registered_email', email);
      await prefs.setString('registered_password', password);
      await prefs.setString('registered_name', name);

      _currentUser = user;
      await _saveUser(user);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Signup error: $e');
      return false;
    }
  }

  // Login existing user (local storage only)
  Future<bool> login({required String email, required String password}) async {
    try {
      _errorMessage = null;

      // Check credentials
      final prefs = await SharedPreferences.getInstance();
      final registeredEmail = prefs.getString('registered_email');
      final registeredPassword = prefs.getString('registered_password');
      final registeredName = prefs.getString('registered_name');

      if (registeredEmail != email || registeredPassword != password) {
        _errorMessage = 'Invalid email or password';
        return false;
      }

      // Create user
      final user = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: registeredName ?? 'User',
        isGuest: false,
      );

      _currentUser = user;
      await _saveUser(user);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Login error: $e');
      return false;
    }
  }

  // Continue as guest (local only)
  Future<void> continueAsGuest() async {
    try {
      _errorMessage = null;

      _currentUser = AuthUser(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        email: 'guest@cricket.app',
        name: 'Guest User',
        isGuest: true,
      );

      await _saveUser(_currentUser!);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Guest login error: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    await _clearSavedUser();
    _currentUser = null;
    _errorMessage = null;
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

  // Refresh user data from local storage
  Future<void> refreshUser() async {
    if (!isAuthenticated) return;

    try {
      await _loadSavedUser();
    } catch (e) {
      debugPrint('Error refreshing user: $e');
    }
  }
}
