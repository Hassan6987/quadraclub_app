import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() => _instance;

  StorageService._internal();

  final _storage = GetStorage();

  static const String keyToken = 'jwt_token';
  static const String refreshToken = 'refresh_token';
  static const String authToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyRememberedEmail = 'remembered_email';
  static const String keyOnboarding = 'onboarding';

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(keyToken, token);
      log('Token saved successfully');
    } catch (e) {
      log('Error saving token: $e');
      rethrow;
    }
  }

  String? getToken() {
    try {
      return _storage.read(keyToken);
    } catch (e) {
      log('Error reading token: $e');
      return null;
    }
  }

  Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(authToken, token);
      log('Auth Token saved successfully');
    } catch (e) {
      log('Error saving Auth token: $e');
      rethrow;
    }
  }

  String? getAuthToken() {
    try {
      return _storage.read(authToken);
    } catch (e) {
      log('Error reading Auth token: $e');
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(refreshToken, token);
      log('Refresh Token saved successfully');
    } catch (e) {
      log('Error saving token: $e');
      rethrow;
    }
  }

  String? getRefreshToken() {
    try {
      return _storage.read(refreshToken);
    } catch (e) {
      log('Error reading token: $e');
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(keyUserId, userId);
      log('User id saved successfully');
    } catch (e) {
      log('Error saving user id: $e');
      rethrow;
    }
  }

  String? getUserId() {
    try {
      return _storage.read(keyUserId);
    } catch (e) {
      log('Error reading user id: $e');
      return null;
    }
  }

  bool hasToken() {
    try {
      final token = _storage.read(keyToken);
      if (token == null || token.isEmpty) {
        log('No token found');
        return false;
      }

      // Decode the JWT token
      final parts = token.split('.');
      if (parts.length != 3) {
        log('Invalid token format');
        remove(keyToken);
        return false;
      }

      try {
        // Add padding to base64 string if necessary
        String normalized = base64Url.normalize(parts[1]);
        final payload = json.decode(utf8.decode(base64Url.decode(normalized)));

        // Check if the token has an expiration claim
        if (!payload.containsKey('exp')) {
          log('Token does not contain expiration');
          return false;
        }

        // Get expiration timestamp and current time
        final expiration = DateTime.fromMillisecondsSinceEpoch(
          payload['exp'] * 1000,
        );
        final currentTime = DateTime.now();

        // Check if token is expired
        if (currentTime.isAfter(expiration)) {
          log('Token is expired');
          remove(keyToken);
          return false;
        }

        log('Token is valid and not expired');
        return true;
      } catch (e) {
        log('Error decoding token payload: $e');
        remove(keyToken);
        return false;
      }
    } catch (e) {
      log('Error checking token: $e');
      return false;
    }
  }

  // User Data Operations
  Future<void> saveUserData(String userData) async {
    try {
      _storage.write(keyUserData, userData);
    } catch (e) {
      log('Error saving user data: $e');
      rethrow;
    }
  }

  String? getUserData() {
    try {
      return _storage.read(keyUserData);
    } catch (e) {
      log('Error reading user data: $e');
      return null;
    }
  }

  Future<void> saveOnboarding() async {
    try {
      await _storage.write(keyOnboarding, true);
      log('onboarding saved');
    } catch (e) {
      log('Error saving onboarding: $e');
      rethrow;
    }
  }

  bool hasOnboarding() {
    try {
      final hasOnboarding = _storage.read(keyOnboarding);
      log('Retrieved onboarding: $hasOnboarding');
      return hasOnboarding ?? false;
    } catch (e) {
      log('Error reading remembered email: $e');
      return false;
    }
  }

  Future<void> clearRememberedEmail() async {
    try {
      await remove(keyRememberedEmail);
      log('Remembered email cleared successfully');
    } catch (e) {
      log('Error clearing remembered email: $e');
      rethrow;
    }
  }

  // Clear All Data
  Future<void> clearAll() async {
    try {
      await _storage.remove(keyToken);
      log('Storage cleared successfully');
    } catch (e) {
      log('Error clearing storage: $e');
      rethrow;
    }
  }

  // Clear Specific Key
  Future<void> remove(String key) async {
    try {
      _storage.remove(key);
      log('Key $key removed successfully');
    } catch (e) {
      log('Error removing key $key: $e');
      rethrow;
    }
  }

  Future<void> removeToken() async {
    try {
      _storage.remove(keyToken);
      log('JWT Token removed successfully');
    } catch (e) {
      log('Error removing key JWT Token: $e');
      rethrow;
    }
  }

  // Check if key exists
  bool hasKey(String key) {
    try {
      final value = _storage.read(key);
      return value != null;
    } catch (e) {
      log('Error checking key $key: $e');
      return false;
    }
  }
}
