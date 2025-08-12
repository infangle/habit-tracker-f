// lib/data/local_storage/habit_local_data_source.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/domain/models/habit.dart';

// This new class acts as the local data source for habits, using Hive.
class HabitLocalDataSource {
  static const String _boxName = 'habits';

  Future<List<Habit>> getHabits() async {
    final box = await Hive.openBox<Habit>(_boxName);
    return box.values.toList();
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final box = await Hive.openBox<Habit>(_boxName);
    await box.clear(); // Clear existing data to avoid duplicates.
    await box.addAll(habits);
  }

  Future<void> saveHabit(Habit habit) async {
    final box = await Hive.openBox<Habit>(_boxName);
    await box.put(habit.id, habit);
  }

  Future<void> deleteHabit(String habitId) async {
    final box = await Hive.openBox<Habit>(_boxName);
    await box.delete(habitId);
  }
}
