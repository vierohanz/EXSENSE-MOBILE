import 'package:get/get.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/logger.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;

  final RxnString _errorMessage = RxnString();
  String? get errorMessage => _errorMessage.value;

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Future<bool> checkAuthStatus() async {
    if (!_authRepository.isAuthenticated()) {
      _currentUser.value = null;
      return false;
    }

    try {
      final user = await _authRepository.getCurrentUser();
      _currentUser.value = user;
      return user != null;
    } catch (e) {
      AppLogger.w('Failed to check auth status: $e');
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final user = await _authRepository.login(
        email: email.trim(),
        password: password,
      );
      _currentUser.value = user;
      _isLoading.value = false;

      AppHelpers.showSnackbar(
        title: 'Login Berhasil',
        message: 'Selamat datang kembali, ${user.name}!',
      );
      return true;
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = e.toString();
      AppHelpers.showAuthErrorDialog(
        title: 'Informasi Akun Tidak Sesuai',
        message: 'Pastikan email dan kata sandi Anda sesuai',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser.value = null;
  }
}
