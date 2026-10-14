import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> saveUser(UserModel user);
  UserModel? getUser();
  Future<void> clearAuth();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<void> saveToken(String token) async {
    await _storageService.setToken(token);
  }

  @override
  String? getToken() {
    return _storageService.token;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _storageService.setString(
      AppConstants.userKey,
      jsonEncode(user.toJson()),
    );
  }

  @override
  UserModel? getUser() {
    final userJson = _storageService.getString(AppConstants.userKey);
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearAuth() async {
    await _storageService.removeToken();
    await _storageService.remove(AppConstants.userKey);
  }
}
