// lib/domain/repositories/user_repository.dart

abstract class UserRepository {
  Future<void> login(String email, String password);
  Future<void> signup(String email, String password, String username);
  Future<void> logout();
}
