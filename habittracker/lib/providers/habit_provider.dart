import 'dart:async';
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
  StreamSubscription<List<Habit>>? _habitsSubscription;

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
    _startListeningToHabits();
  }

  void _startListeningToHabits() {
    if (_userId == null) return;

    _habitsSubscription?.cancel();
    _setLoading(true);

    _habitsSubscription = _getHabitsUseCase
        .execute(_userId!)
        .listen(
          (habits) {
            _habits = habits;
            _error = null;
            _setLoading(false);
            notifyListeners();
          },
          onError: (error) {
            _error = 'Failed to load habits: ${error.toString()}';
            _setLoading(false);
            notifyListeners();
          },
        );
  }

  Future<void> addHabit(Habit habit) async {
    if (_userId == null) return;

    try {
      await _addHabitUseCase.execute(habit);
      _error = null;
    } catch (e) {
      _error = 'Failed to add habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    try {
      final updatedHabit = habit.copyWith(
        isCompleted: !habit.isCompleted,
        completedDate: !habit.isCompleted ? DateTime.now() : null,
      );

      await _updateHabitUseCase.execute(updatedHabit);
      _error = null;
    } catch (e) {
      _error = 'Failed to update habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    try {
      await _deleteHabitUseCase.execute(habit.id);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateHabit(Habit habit) async {
    if (_userId == null) return;

    try {
      await _updateHabitUseCase.execute(habit);
      _error = null;
    } catch (e) {
      _error = 'Failed to update habit: ${e.toString()}';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _habitsSubscription?.cancel();
    super.dispose();
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
