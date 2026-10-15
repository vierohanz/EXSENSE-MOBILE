import '../../../../core/config/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final token = data['token'] ?? data['access_token'] ?? data['data']?['token'];
      if (token != null) {
        await _storageService.setToken(token.toString());
      }
      final userJson = data['user'] ?? data['data']?['user'] ?? data['data'] ?? data;
      if (userJson is Map<String, dynamic>) {
        return UserModel.fromJson(userJson);
      }
    }

    return UserModel(
      id: '1',
      name: email.split('@').first,
      email: email,
    );
  }

  Future<UserModel?> getCurrentUser() async {
    final token = _storageService.token;
    if (token == null || token.isEmpty) return null;

    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final userJson = data['data'] ?? data['user'] ?? data;
        if (userJson is Map<String, dynamic>) {
          return UserModel.fromJson(userJson);
        }
      }
    } catch (_) {}

    return null;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {}
    await _storageService.removeToken();
    await _storageService.remove(AppConstants.userKey);
  }

  bool isAuthenticated() => _storageService.hasToken;
}
