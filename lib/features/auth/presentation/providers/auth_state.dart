import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final UserEntity? currentUser;
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    UserEntity? Function()? currentUser,
    bool? isLoading,
    bool? isPasswordVisible,
    String? Function()? errorMessage,
  }) {
    return AuthState(
      currentUser: currentUser != null ? currentUser() : this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [currentUser, isLoading, isPasswordVisible, errorMessage];
}
