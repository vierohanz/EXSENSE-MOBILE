import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  String? _cachedToken;

  StorageService(this._prefs, this._secureStorage);

  /// Initializes storage service by preloading token from secure storage
  /// and migrating any legacy unencrypted token if present.
  Future<void> init() async {
    _cachedToken = await _secureStorage.read(key: AppConstants.tokenKey);

    // Migration: If legacy token exists in SharedPreferences, move it to FlutterSecureStorage
    final legacyToken = _prefs.getString(AppConstants.tokenKey);
    if (legacyToken != null && legacyToken.isNotEmpty) {
      if (_cachedToken == null || _cachedToken!.isEmpty) {
        _cachedToken = legacyToken;
        await _secureStorage.write(key: AppConstants.tokenKey, value: legacyToken);
      }
      await _prefs.remove(AppConstants.tokenKey);
    }
  }

  // Token Management (Hardware-backed encrypted Secure Storage)
  String? get token => _cachedToken;

  Future<String?> getSecureToken() async {
    _cachedToken = await _secureStorage.read(key: AppConstants.tokenKey);
    return _cachedToken;
  }

  Future<void> setToken(String token) async {
    _cachedToken = token;
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<void> removeToken() async {
    _cachedToken = null;
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _prefs.remove(AppConstants.tokenKey);
  }

  bool get hasToken => _cachedToken != null && _cachedToken!.isNotEmpty;

  // Generic Storage Helpers (SharedPreferences for general app settings)
  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);
  Future<void> clear() async {
    _cachedToken = null;
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
}
