// habit_repository.dart

import 'package:habit_tracker/domain/models/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabitsForUser(int userId);
  Future<void> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(int habitId);
}
