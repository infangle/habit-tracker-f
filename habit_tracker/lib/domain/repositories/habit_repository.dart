// habit_repository.dart

import 'package:habit_tracker/domain/models/habit.dart';

// lib/domain/repositories/habit_repository.dart
abstract class HabitRepository {
  Future<List<Habit>> getHabitsForUser(String userId);
  Future<void> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String habitId, String userId);
}
