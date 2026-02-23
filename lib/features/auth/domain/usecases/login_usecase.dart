import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
