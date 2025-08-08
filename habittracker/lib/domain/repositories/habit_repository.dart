import '../entities/habit.dart';

abstract class HabitRepository {
  Future<void> addHabit(String userId, Habit habit);
  Stream<List<Habit>> getHabits(String userId);
  Future<void> updateHabit(String userId, Habit habit);
  Future<void> deleteHabit(String userId, String habitId);
  Future<Habit?> getHabitById(String userId, String habitId);
  Stream<List<Habit>> getHabitsByCompletion(String userId, bool isCompleted);
  Stream<List<Habit>> getHabitsByFrequency(String userId, String frequency);
  Stream<List<Habit>> getHabitsOrderedByDate(String userId, {bool descending});
}
