import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({UserModel user, String token, String? refreshToken})> login({
    required String email,
    required String password,
  });

  Future<UserModel> getCurrentUser();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<({UserModel user, String token, String? refreshToken})> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email.trim(),
        'password': password,
      },
    );

    final body = response.data;
    if (body is Map<String, dynamic>) {
      final isSuccess = body['success'] as bool? ?? (body['status'] == true || body['status'] == 'success');
      final data = body['data'];

      if (isSuccess && data is Map<String, dynamic>) {
        final token = data['access_token']?.toString() ?? data['token']?.toString() ?? '';
        final refreshToken = data['refresh_token']?.toString();
        final userJson = data['user'] is Map<String, dynamic> ? data['user'] as Map<String, dynamic> : data;
        final user = UserModel.fromJson(userJson);

        return (user: user, token: token, refreshToken: refreshToken);
      }

      final message = body['message']?.toString() ?? 'Login gagal, periksa email dan password Anda';
      throw ServerException(message);
    }

    throw ServerException('Format respon server tidak valid');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.profile);
    final body = response.data;

    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }
    }

    throw ServerException('Gagal memuat profil pengguna');
  }

  @override
  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
  }
}
