import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/logger.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

// Data Layer Providers
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return AuthLocalDataSourceImpl(storageService);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final local = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});

// UseCase Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(repo);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repo);
});

// Presentation Layer Notifier
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// Verifies authentication status against Secure Storage and Backend API.
  /// Returns true if user is authenticated with a valid session, false otherwise.
  Future<bool> checkAuthStatus() async {
    final storage = ref.read(storageServiceProvider);
    if (!storage.hasToken) {
      state = state.copyWith(currentUser: () => null);
      return false;
    }

    try {
      AppLogger.i('Validating session token with backend API...');
      final remote = ref.read(authRemoteDataSourceProvider);
      final local = ref.read(authLocalDataSourceProvider);
      final userModel = await remote.getCurrentUser();
      await local.saveUser(userModel);
      state = state.copyWith(currentUser: () => userModel);
      AppLogger.i('Session valid for user: ${userModel.name}');
      return true;
    } catch (e) {
      AppLogger.w('Backend token validation failed or offline: $e');
      final local = ref.read(authLocalDataSourceProvider);
      final localUser = local.getUser();
      // If offline but token was not invalidated and local profile exists, allow cached session
      if (localUser != null && storage.hasToken) {
        AppLogger.i('Restoring cached user session: ${localUser.name}');
        state = state.copyWith(currentUser: () => localUser);
        return true;
      }

      AppLogger.i('Clearing invalid session');
      await local.clearAuth();
      state = state.copyWith(currentUser: () => null);
      return false;
    }
  }

  Future<void> checkCurrentUser() async {
    await checkAuthStatus();
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    AppLogger.i('Attempting login for email: $email');

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(
      LoginParams(email: email.trim(), password: password),
    );

    state = state.copyWith(isLoading: false);

    return result.fold(
      (failure) {
        AppLogger.e('Login failed: ${failure.message}', failure);
        state = state.copyWith(errorMessage: () => failure.message);
        AppHelpers.showAuthErrorDialog(
          title: 'Informasi Akun Tidak Sesuai',
          message: failure.message.isNotEmpty
              ? failure.message
              : 'Pastikan email dan kata sandi Anda sesuai',
        );
        return false;
      },
      (user) {
        AppLogger.i('Login succeeded for user: ${user.name} (${user.email})');
        state = state.copyWith(currentUser: () => user);
        AppHelpers.showSnackbar(
          title: 'Login Berhasil',
          message: 'Selamat datang kembali, ${user.name}!',
        );
        return true;
      },
    );
  }

  Future<void> logout() async {
    final storage = ref.read(storageServiceProvider);
    await storage.removeToken();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = state.copyWith(currentUser: () => null);
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
