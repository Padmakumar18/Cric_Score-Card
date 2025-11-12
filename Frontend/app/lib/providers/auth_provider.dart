import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser? _currentUser;
  final ApiService _apiService = ApiService();
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

    await _apiService.init();
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

  // Sign up new user
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _errorMessage = null;

      final response = await _apiService.signup(
        email: email,
        password: password,
        name: name,
      );

      // Extract user data and token from response
      final user = AuthUser(
        id: response['id'],
        email: response['email'],
        name: response['name'],
        isGuest: false,
      );

      // Save token
      if (response['access_token'] != null) {
        await _apiService.saveToken(response['access_token']);
      }

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

  // Login existing user
  Future<bool> login({required String email, required String password}) async {
    try {
      _errorMessage = null;

      final response = await _apiService.login(
        email: email,
        password: password,
      );

      // Extract user data and token from response
      final user = AuthUser(
        id: response['id'],
        email: response['email'],
        name: response['name'],
        isGuest: false,
      );

      // Save token
      if (response['access_token'] != null) {
        await _apiService.saveToken(response['access_token']);
      }

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

  // Continue as guest
  Future<void> continueAsGuest() async {
    try {
      _errorMessage = null;

      final response = await _apiService.guestLogin();

      final user = AuthUser(
        id: response['id'],
        email: response['email'],
        name: response['name'] ?? 'Guest User',
        isGuest: true,
      );

      // Save token
      if (response['access_token'] != null) {
        await _apiService.saveToken(response['access_token']);
      }

      _currentUser = user;
      await _saveUser(user);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Guest login error: $e');
      // Fallback to local guest mode if API fails
      _currentUser = AuthUser(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        email: 'guest@cricket.app',
        name: 'Guest User',
        isGuest: true,
      );
      await _saveUser(_currentUser!);
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    await _apiService.clearToken();
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

  // Refresh user data from API
  Future<void> refreshUser() async {
    if (!isAuthenticated) return;

    try {
      final response = await _apiService.getCurrentUser();

      final user = AuthUser(
        id: response['id'],
        email: response['email'],
        name: response['name'],
        isGuest: response['is_guest'] ?? false,
      );

      _currentUser = user;
      await _saveUser(user);
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing user: $e');
    }
  }
}
