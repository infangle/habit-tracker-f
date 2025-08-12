// lib/services/mock_api_service.dart
class MockApiService {
  final Map<String, Map<String, dynamic>> _users = {};
  final Map<String, List<Map<String, dynamic>>> _habits = {};

  Future<bool> signUp(String email, String password, String username) async {
    if (_users.containsKey(email)) {
      throw Exception('User already exists');
    }
    _users[email] = {
      'email': email,
      'password': password,
      'username': username,
      'id': email.hashCode.toString(),
    };
    return true;
  }

  Future<String?> login(String email, String password) async {
    final user = _users[email];
    if (user != null && user['password'] == password) {
      return user['id'];
    }
    throw Exception('Invalid email or password');
  }

  Future<void> logout() async {}

  Future<void> createHabit(String userId, Map<String, dynamic> habit) async {
    _habits.putIfAbsent(userId, () => []).add(habit);
  }

  Future<List<Map<String, dynamic>>> getHabits(String userId) async {
    return _habits[userId] ?? [];
  }

  Future<void> updateHabit(
    String userId,
    String habitId,
    Map<String, dynamic> habit,
  ) async {
    final habits = _habits[userId] ?? [];
    final index = habits.indexWhere((h) => h['id'] == habitId);
    if (index != -1) {
      habits[index] = habit;
    } else {
      throw Exception('Habit not found');
    }
  }

  Future<void> deleteHabit(String userId, String habitId) async {
    _habits[userId]?.removeWhere((h) => h['id'] == habitId);
  }
}
