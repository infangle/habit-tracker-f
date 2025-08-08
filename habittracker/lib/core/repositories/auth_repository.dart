import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> signUp(String email, String password, String username);
  Future<void> login(String email, String password);
  Future<UserProfile?> getCurrentUser();
  Future<void> updateUserProfile(UserProfile user);
}
