import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_imp.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_imp.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';

import '../../../shared/infrastructure/services/key_value_storage_keys.dart';
import '../../domain/entities/user.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    repository: AuthRepositoryImpl(),
    keyValueStorageService: KeyValueStorageImplementation(),
  );
});

class AuthState {
  final AuthStatus authStatus;

  final User? user;
  final String errorMessage;

  AuthState({
    this.user,
    this.errorMessage = '',
    this.authStatus = AuthStatus.checking,
  });

  AuthState copyWith({
    User? user,
    String? errorMessage,
    AuthStatus? authStatus,
  }) =>
      AuthState(
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        authStatus: authStatus ?? this.authStatus,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;
  final KeyValueStorageService keyValueStorageService;
  AuthNotifier({
    required this.repository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final user = await repository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout(errorMessage: 'Invalid credentials.');
    } on ConnectionTimeout {
      logout(errorMessage: 'Timeout.');
    } on CustomError catch (e) {
      logout(errorMessage: e.errorMessage);
    } catch (e) {
      logout(errorMessage: 'Unknown error: ${e.toString()}');
    }
  }

  Future<void> registerUser(
      String email, String password, String fullName) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = await repository.register(email, password, fullName);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(errorMessage: e.errorMessage);
    } catch (e) {
      logout(errorMessage: 'Unknown error: ${e.toString()}');
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService
        .getValue<String>(KeyValueStorageKeys.token.rawValue);
    if (token == null) logout();

    try {
      final user = await repository.checkAuthStatus(token!);
      _setLoggedUser(user);
    } catch (e) {
      logout(errorMessage: 'Unknown error: ${e.toString()}');
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue(
      KeyValueStorageKeys.token.rawValue,
      user.token,
    );

    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout({String? errorMessage}) async {
    state = state.copyWith(
      user: null,
      errorMessage: errorMessage,
      authStatus: AuthStatus.notAuthenticated,
    );
  }
}
