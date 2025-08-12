// user_repository_impl.dart
import 'package:habit_tracker/domain/repositories/user_repository.dart';
import 'package:habit_tracker/services/mock_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final MockApiService _apiService = MockApiService();

  @override
  Future<String?> login(String email, String password) async {
    try {
      return await _apiService.login(email, password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<bool> signup(String email, String password, String username) async {
    try {
      return await _apiService.signUp(email, password, username);
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
