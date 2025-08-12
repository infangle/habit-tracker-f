import 'package:habit_tracker/data/user_repository_impl.dart';

// lib/domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<String?> login(String email, String password);
  Future<bool> signup(String email, String password, String username);
  Future<void> logout();
}
