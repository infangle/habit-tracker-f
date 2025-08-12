// habit_repository_impl.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:habit_tracker/domain/models/habit.dart';
import 'package:habit_tracker/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  List<Habit> _habits = [];

  Future<void> _loadHabits() async {
    final String habitsData = await rootBundle.loadString('db.json');
    final List<dynamic> habitsJson = json.decode(habitsData);

    _habits = habitsJson.map<Habit>((json) => Habit.fromJson(json)).toList();
  }

  @override
  Future<List<Habit>> getHabitsForUser(int userId) async {
    await _loadHabits();
    return _habits.where((habit) => habit.userId == userId).toList();
  }

  @override
  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    // Save the updated habits list back to the db.json file
    // You can write the updated list back to the file here
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      // Save the updated habits list back to the db.json file
      // You can write the updated list back to the file here
    }
  }

  @override
  Future<void> deleteHabit(int habitId) async {
    _habits.removeWhere((habit) => habit.id == habitId);
    // Save the updated habits list back to the db.json file
    // You can write the updated list back to the file here
  }
}
