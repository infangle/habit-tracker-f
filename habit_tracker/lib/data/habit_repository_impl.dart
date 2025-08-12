// habit_repository_impl.dart
import 'package:habit_tracker/domain/models/habit.dart';
import 'package:habit_tracker/domain/repositories/habit_repository.dart';
import 'package:habit_tracker/services/mock_api_service.dart';

class HabitRepositoryImpl implements HabitRepository {
  final MockApiService _apiService = MockApiService();

  @override
  Future<List<Habit>> getHabitsForUser(String userId) async {
    try {
      final habitData = await _apiService.getHabits(userId);
      return habitData.map((data) => Habit.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to load habits: $e');
    }
  }

  @override
  Future<void> addHabit(Habit habit) async {
    try {
      await _apiService.createHabit(habit.userId, habit.toJson());
    } catch (e) {
      throw Exception('Failed to add habit: $e');
    }
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    try {
      await _apiService.updateHabit(habit.userId, habit.id, habit.toJson());
    } catch (e) {
      throw Exception('Failed to update habit: $e');
    }
  }

  @override
  Future<void> deleteHabit(String habitId, String userId) async {
    try {
      await _apiService.deleteHabit(userId, habitId);
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }
}
