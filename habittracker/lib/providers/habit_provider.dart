import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Collection reference
  CollectionReference get _habitsCollection => _firestore.collection('habits');

  // Set user ID
  void setUserId(String userId) {
    _userId = userId;
    loadHabits();
  }

  // Load habits from Firebase
  Future<void> loadHabits() async {
    if (_userId == null) return;

    _setLoading(true);
    try {
      final snapshot = await _habitsCollection
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .get();

      _habits = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Habit.fromFirestore(doc.id, data);
      }).toList();

      _error = null;
    } catch (e) {
      _error = 'Failed to load habits: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Add new habit
  Future<void> addHabit(
    String name,
    String frequency, {
    DateTime? startDate,
  }) async {
    if (_userId == null) return;

    _setLoading(true);
    try {
      final newHabit = Habit(
        id: '',
        name: name,
        frequency: frequency,
        startDate: startDate ?? DateTime.now(),
        userId: _userId!,
      );

      final docRef = await _habitsCollection.add(newHabit.toFirestore());
      final habitWithId = newHabit.copyWith(id: docRef.id);
      _habits.insert(0, habitWithId);

      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add habit: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Toggle habit completion
  Future<void> toggleHabitCompletion(Habit habit) async {
    try {
      final updatedHabit = habit.copyWith(
        isCompleted: !habit.isCompleted,
        completedDate: !habit.isCompleted ? DateTime.now() : null,
      );

      await _habitsCollection.doc(habit.id).update(updatedHabit.toFirestore());

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

  // Delete habit
  Future<void> deleteHabit(Habit habit) async {
    try {
      await _habitsCollection.doc(habit.id).delete();
      _habits.removeWhere((h) => h.id == habit.id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete habit: ${e.toString()}';
      notifyListeners();
    }
  }

  // Update habit
  Future<void> updateHabit(
    String id,
    String name,
    String frequency, {
    DateTime? startDate,
  }) async {
    if (_userId == null) return;

    try {
      final index = _habits.indexWhere((h) => h.id == id);
      if (index != -1) {
        final updatedHabit = _habits[index].copyWith(
          name: name,
          frequency: frequency,
          startDate: startDate ?? _habits[index].startDate,
        );

        await _habitsCollection.doc(id).update(updatedHabit.toFirestore());
        _habits[index] = updatedHabit;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update habit: ${e.toString()}';
      notifyListeners();
    }
  }

  // Get habits for a specific date
  List<Habit> getHabitsForDate(DateTime date) {
    return _habits.where((habit) {
      final habitDate = DateTime(
        habit.startDate?.year ?? 0,
        habit.startDate?.month ?? 0,
        habit.startDate?.day ?? 0,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return habitDate == targetDate;
    }).toList();
  }

  // Get completion rate
  double getCompletionRate() {
    if (_habits.isEmpty) return 0.0;
    final completedCount = _habits.where((h) => h.isCompleted).length;
    return completedCount / _habits.length;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private helper method
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
