import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fang/services/auth_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService();

  AuthCubit() : super(const AuthState(status: AuthStatus.initial));

  /// Initialize auth state - check if user is already authenticated
  Future<void> init() async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      final success = await _authService.login(email, password);
      if (success) {
        emit(state.copyWith(status: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid email or password',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Login failed: ${e.toString()}',
      ));
    }
  }

  /// Register a new account
  Future<void> register({
    required String email,
    required String password,
    String? phoneNumber,
    String? countryId,
    required String firstName,
    String? lastName,
    String? flag,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      final success = await _authService.register(
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        countryId: countryId,
        firstName: firstName,
        lastName: lastName,
        flag: flag,
      );

      if (success) {
        // After successful registration, auto-login
        await login(email, password);
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Registration failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Registration failed: ${e.toString()}',
      ));
    }
  }

  /// Logout
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      await _authService.logout();
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Logout failed: ${e.toString()}',
      ));
    }
  }

  /// Clear error state
  void clearError() {
    if (state.status == AuthStatus.error) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: null,
      ));
    }
  }
}

