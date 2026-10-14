import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/logger.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthController extends GetxController {
  final StorageService _storageService;
  final LoginUseCase _loginUseCase;
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRepository _authRepository;

  AuthController({
    required StorageService storageService,
    required LoginUseCase loginUseCase,
    required AuthRemoteDataSource authRemoteDataSource,
    required AuthLocalDataSource authLocalDataSource,
    required AuthRepository authRepository,
  })  : _storageService = storageService,
        _loginUseCase = loginUseCase,
        _authRemoteDataSource = authRemoteDataSource,
        _authLocalDataSource = authLocalDataSource,
        _authRepository = authRepository;

  final Rx<UserEntity?> _currentUser = Rx<UserEntity?>(null);
  UserEntity? get currentUser => _currentUser.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;

  final RxnString _errorMessage = RxnString();
  String? get errorMessage => _errorMessage.value;

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  /// Verifies authentication status against Hive Storage and Backend API.
  /// Returns true if user is authenticated with a valid session, false otherwise.
  Future<bool> checkAuthStatus() async {
    if (!_storageService.hasToken) {
      _currentUser.value = null;
      return false;
    }

    try {
      AppLogger.i('Validating session token with backend API...');
      final userModel = await _authRemoteDataSource.getCurrentUser();
      await _authLocalDataSource.saveUser(userModel);
      _currentUser.value = userModel;
      AppLogger.i('Session valid for user: ${userModel.name}');
      return true;
    } catch (e) {
      AppLogger.w('Backend token validation failed or offline: $e');
      final localUser = _authLocalDataSource.getUser();
      // If offline but token was not invalidated and local profile exists, allow cached session
      if (localUser != null && _storageService.hasToken) {
        AppLogger.i('Restoring cached user session: ${localUser.name}');
        _currentUser.value = localUser;
        return true;
      }

      AppLogger.i('Clearing invalid session');
      await _authLocalDataSource.clearAuth();
      _currentUser.value = null;
      return false;
    }
  }

  Future<void> checkCurrentUser() async {
    await checkAuthStatus();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading.value = true;
    _errorMessage.value = null;
    AppLogger.i('Attempting login for email: $email');

    final result = await _loginUseCase(
      LoginParams(email: email.trim(), password: password),
    );

    _isLoading.value = false;

    return result.fold(
      (failure) {
        AppLogger.e('Login failed: ${failure.message}', failure);
        _errorMessage.value = failure.message;
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
        _currentUser.value = user;
        AppHelpers.showSnackbar(
          title: 'Login Berhasil',
          message: 'Selamat datang kembali, ${user.name}!',
        );
        return true;
      },
    );
  }

  Future<void> logout() async {
    await _storageService.removeToken();
    await _authRepository.logout();
    _currentUser.value = null;
  }
}
