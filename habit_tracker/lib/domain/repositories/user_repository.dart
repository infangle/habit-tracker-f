import 'package:habit_tracker/data/user_repository_impl.dart';

abstract class UserRepository {
  Future<bool> login(String email, String password);
  Future<bool> signup(String email, String password, String username);
}
