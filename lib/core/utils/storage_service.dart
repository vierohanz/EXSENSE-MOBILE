import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_constants.dart';

class StorageService {
  static const String _boxName = 'app_storage';
  Box? _box;
  String? _cachedToken;

  StorageService([Box? box]) : _box = box;

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
    _cachedToken = _box?.get(AppConstants.tokenKey) as String?;
  }

  Box get box {
    if (_box == null || !_box!.isOpen) {
      _box = Hive.box(_boxName);
    }
    return _box!;
  }

  String? get token =>
      _cachedToken ?? box.get(AppConstants.tokenKey) as String?;

  Future<String?> getSecureToken() async {
    _cachedToken = box.get(AppConstants.tokenKey) as String?;
    return _cachedToken;
  }

  Future<void> setToken(String token) async {
    _cachedToken = token;
    await box.put(AppConstants.tokenKey, token);
  }

  Future<void> removeToken() async {
    _cachedToken = null;
    await box.delete(AppConstants.tokenKey);
  }

  bool get hasToken => token != null && token!.isNotEmpty;

  String? getString(String key) => box.get(key) as String?;
  Future<bool> setString(String key, String value) async {
    await box.put(key, value);
    return true;
  }

  bool? getBool(String key) => box.get(key) as bool?;
  Future<bool> setBool(String key, bool value) async {
    await box.put(key, value);
    return true;
  }

  int? getInt(String key) => box.get(key) as int?;
  Future<bool> setInt(String key, int value) async {
    await box.put(key, value);
    return true;
  }

  Future<bool> remove(String key) async {
    await box.delete(key);
    return true;
  }

  Future<void> clear() async {
    _cachedToken = null;
    await box.clear();
  }
}
