import 'package:habittracker/data/services/firebase_firestore_service.dart';
import 'package:habittracker/domain/entities/habit.dart';
import 'package:habittracker/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final FirebaseFirestoreService _firestoreService;

  HabitRepositoryImpl({required FirebaseFirestoreService firestoreService})
    : _firestoreService = firestoreService;

  @override
  Future<void> addHabit(String userId, Habit habit) async {
    await _firestoreService.addHabit(userId, habit);
  }

  @override
  Stream<List<Habit>> getHabits(String userId) {
    return _firestoreService.getHabits(userId);
  }

  @override
  Future<void> updateHabit(String userId, Habit habit) async {
    await _firestoreService.updateHabit(userId, habit);
  }

  @override
  Future<void> deleteHabit(String userId, String habitId) async {
    await _firestoreService.deleteHabit(userId, habitId);
  }

  @override
  Future<Habit?> getHabitById(String userId, String habitId) async {
    return await _firestoreService.getHabitById(userId, habitId);
  }

  @override
  Stream<List<Habit>> getHabitsByCompletion(String userId, bool isCompleted) {
    return _firestoreService.getHabitsByCompletion(userId, isCompleted);
  }

  @override
  Stream<List<Habit>> getHabitsByFrequency(String userId, String frequency) {
    return _firestoreService.getHabitsByFrequency(userId, frequency);
  }

  @override
  Stream<List<Habit>> getHabitsOrderedByDate(
    String userId, {
    bool descending = true,
  }) {
    return _firestoreService.getHabitsOrderedByDate(
      userId,
      descending: descending,
    );
  }
}
