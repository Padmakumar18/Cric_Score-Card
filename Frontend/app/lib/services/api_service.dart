import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // Change this to your backend URL
  static const String baseUrl = 'http://localhost:8000';

  final _storage = const FlutterSecureStorage();
  String? _token;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Initialize and load token
  Future<void> init() async {
    _token = await _storage.read(key: 'auth_token');
  }

  // Save token
  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  // Clear token
  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }

  // Get headers
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {'Content-Type': 'application/json'};

    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    } else {
      final error = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {'detail': 'Unknown error'};

      throw ApiException(
        error['detail'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }

  // Auth endpoints
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    return await post('/api/auth/signup', {
      'email': email,
      'password': password,
      'name': name,
    }, requiresAuth: false);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await post('/api/auth/login', {
      'email': email,
      'password': password,
    }, requiresAuth: false);
  }

  Future<Map<String, dynamic>> guestLogin() async {
    return await post('/api/auth/guest', {}, requiresAuth: false);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    return await get('/api/auth/me');
  }

  // Match endpoints
  Future<Map<String, dynamic>> createMatch(
    Map<String, dynamic> matchData,
  ) async {
    return await post('/api/matches', matchData);
  }

  Future<List<dynamic>> getMatches({int page = 1, int limit = 10}) async {
    final response = await get('/api/matches?page=$page&limit=$limit');
    return response['matches'] ?? [];
  }

  Future<Map<String, dynamic>> getMatch(String matchId) async {
    return await get('/api/matches/$matchId');
  }

  Future<Map<String, dynamic>> addBallEvent(
    String matchId,
    Map<String, dynamic> ballData,
  ) async {
    return await post('/api/matches/$matchId/ball-events', ballData);
  }

  // Tournament endpoints
  Future<Map<String, dynamic>> createTournament(
    Map<String, dynamic> tournamentData,
  ) async {
    return await post('/api/tournaments', tournamentData);
  }

  Future<List<dynamic>> getTournaments({int page = 1, int limit = 10}) async {
    final response = await get('/api/tournaments?page=$page&limit=$limit');
    return response['tournaments'] ?? [];
  }

  Future<Map<String, dynamic>> getTournament(String tournamentId) async {
    return await get('/api/tournaments/$tournamentId');
  }

  // Player endpoints
  Future<Map<String, dynamic>> createPlayer(
    Map<String, dynamic> playerData,
  ) async {
    return await post('/api/players', playerData);
  }

  Future<List<dynamic>> getPlayers({int page = 1, int limit = 10}) async {
    final response = await get('/api/players?page=$page&limit=$limit');
    return response['players'] ?? [];
  }

  Future<Map<String, dynamic>> getPlayer(String playerId) async {
    return await get('/api/players/$playerId');
  }

  // Profile endpoints
  Future<Map<String, dynamic>> getProfile() async {
    return await get('/api/profiles/me');
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    return await put('/api/profiles/me', profileData);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
