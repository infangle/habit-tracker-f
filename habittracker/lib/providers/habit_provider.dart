import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/entities/habit.dart';
import '../domain/usecases/add_habit_use_case.dart';
import '../domain/usecases/get_habits_use_case.dart';
import '../domain/usecases/update_habit_use_case.dart';
import '../domain/usecases/delete_habit_use_case.dart';
import '../providers/auth_provider.dart';

class HabitProvider extends ChangeNotifier {
  final AddHabitUseCase _addHabitUseCase;
  final GetHabitsUseCase _getHabitsUseCase;
  final UpdateHabitUseCase _updateHabitUseCase;
  final DeleteHabitUseCase _deleteHabitUseCase;
  final AuthProvider _authProvider;

  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Habit>>? _habitsSubscription;

  HabitProvider({
    required AddHabitUseCase addHabitUseCase,
    required GetHabitsUseCase getHabitsUseCase,
    required UpdateHabitUseCase updateHabitUseCase,
    required DeleteHabitUseCase deleteHabitUseCase,
    required AuthProvider authProvider,
  }) : _addHabitUseCase = addHabitUseCase,
       _getHabitsUseCase = getHabitsUseCase,
       _updateHabitUseCase = updateHabitUseCase,
       _deleteHabitUseCase = deleteHabitUseCase,
       _authProvider = authProvider {
    _authProvider.addListener(_onAuthStateChanged);
    _onAuthStateChanged();
  }

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _onAuthStateChanged() {
    if (_authProvider.currentUser == null) {
      _habitsSubscription?.cancel();
      _habits = [];
      _error = 'User not logged in';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _startListeningToHabits();
  }

  void _startListeningToHabits() {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) return;

    _habitsSubscription?.cancel();
    _setLoading(true);

    _habitsSubscription = _getHabitsUseCase
        .execute(userId)
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
    final userId = _authProvider.currentUser?.id;
    if (userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    try {
      final habitWithUser = habit.copyWith(userId: userId);
      await _addHabitUseCase.execute(userId, habitWithUser);
      _error = null;
    } catch (e) {
      _error = 'Failed to add habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    try {
      final updatedHabit = habit.copyWith(
        isCompleted: !habit.isCompleted,
        completedDate: !habit.isCompleted ? DateTime.now() : null,
      );
      await _updateHabitUseCase.execute(userId, updatedHabit);
      _error = null;
    } catch (e) {
      _error = 'Failed to update habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    try {
      final habitWithUser = habit.copyWith(userId: userId);
      await _updateHabitUseCase.execute(userId, habitWithUser); // Fixed typo
      _error = null;
    } catch (e) {
      _error = 'Failed to update habit: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    try {
      await _deleteHabitUseCase.execute(userId, habitId);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete habit: ${e.toString()}';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _habitsSubscription?.cancel();
    _authProvider.removeListener(_onAuthStateChanged);
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
