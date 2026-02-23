import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoit/core/error/app_exceptions.dart';
import 'package:todoit/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:todoit/features/auth/data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_state.dart';

/// --- AuthNotifier using Riverpod 3.x Notifier ---
class AuthNotifier extends Notifier<AuthState> {
  late final LoginUseCase loginUseCase;
  late final RegisterUsecase registerUseCase;
  late final LogoutUseCase logoutUseCase;
  late final GetCurrentUserUseCase getCurrentUserUseCase;

  @override
  AuthState build() {
    // Initialize repository and usecases inside build
    final authRepo = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSource(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );

    loginUseCase = LoginUseCase(authRepo);
    registerUseCase = RegisterUsecase(authRepo);
    logoutUseCase = LogoutUseCase(authRepo);
    getCurrentUserUseCase = GetCurrentUserUseCase(authRepo);

    return AuthState(); // initial state
  }

  // --- Methods ---
  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await loginUseCase(email: email, password: password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.message);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await registerUseCase(
        name: name,
        email: email,
        password: password,
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } on AuthException catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.message);
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  Future<void> loadCurrentUser() async {
    final user = await getCurrentUserUseCase();
    if (user != null) {
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }
}

/// --- Provider ---
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
