import 'package:flutter/foundation.dart';
import '../domain/entities/habit.dart';
import '../domain/usecases/add_habit_use_case.dart';
import '../domain/usecases/get_habits_use_case.dart';
import '../domain/usecases/update_habit_use_case.dart';
import '../domain/usecases/delete_habit_use_case.dart';

class HabitProvider extends ChangeNotifier {
  final AddHabitUseCase _addHabitUseCase;
  final GetHabitsUseCase _getHabitsUseCase;
  final UpdateHabitUseCase _updateHabitUseCase;
  final DeleteHabitUseCase _deleteHabitUseCase;

  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  HabitProvider({
    required AddHabitUseCase addHabitUseCase,
    required GetHabitsUseCase getHabitsUseCase,
    required UpdateHabitUseCase updateHabitUseCase,
    required DeleteHabitUseCase deleteHabitUseCase,
  }) : _addHabitUseCase = addHabitUseCase,
       _getHabitsUseCase = getHabitsUseCase,
       _updateHabitUseCase = updateHabitUseCase,
       _deleteHabitUseCase = deleteHabitUseCase;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    loadHabits();
  }

  Future<void> loadHabits() async {
    if (_userId == null) return;

    _setLoading(true);
    try {
      _habits = await _getHabitsUseCase.execute(_userId!);
      _error = null;
    } catch (e) {
      _error = 'Failed to load habits: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addHabit(Habit habit) async {
    if (_userId == null) return;

    _setLoading(true);
    try {
      await _addHabitUseCase.execute(habit);
      _habits.insert(0, habit);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add habit: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    try {
      final updatedHabit = habit.copyWith(
        isCompleted: !habit.isCompleted,
        completedDate: !habit.isCompleted ? DateTime.now() : null,
      );

      await _updateHabitUseCase.execute(updatedHabit);

      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = updatedHabit;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    try {
      await _deleteHabitUseCase.execute(habit.id);
      _habits.removeWhere((h) => h.id == habit.id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateHabit(Habit habit) async {
    if (_userId == null) return;

    try {
      await _updateHabitUseCase.execute(habit);
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update habit: ${e.toString()}';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
