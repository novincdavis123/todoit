import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login({required String email, required String password}) =>
      remoteDataSource.login(email: email, password: password);

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) => remoteDataSource.register(name: name, email: email, password: password);

  @override
  Future<void> logout() => remoteDataSource.logout();

  @override
  Future<User?> getCurrentUser() => remoteDataSource.getCurrentUser();
}
