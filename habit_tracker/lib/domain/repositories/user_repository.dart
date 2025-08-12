// lib/domain/repositories/user_repository.dart

import 'package:habit_tracker/data/user_repository_impl.dart';

// This is the abstract repository interface for user-related data.
// It ensures that the AuthController is not directly coupled to the
// implementation details of a specific data source (e.g., Firebase).
abstract class UserRepository {
  Future<void> login(String email, String password);
  Future<void> signup(String email, String password, String username);
  Future<void> logout();
}
