import '../entities/habit.dart';

abstract class HabitRepository {
  Future<void> addHabit(Habit habit);
  Future<List<Habit>> getHabits(String userId);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String id);
  Future<void> toggleHabitCompletion(Habit habit);
}
