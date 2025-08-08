import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../services/firebase_firestore_service.dart';

class HabitRepositoryImpl implements HabitRepository {
  final FirebaseFirestoreService _firebaseFirestoreService;

  HabitRepositoryImpl(this._firebaseFirestoreService);

  @override
  Future<void> addHabit(Habit habit) async {
    await _firebaseFirestoreService.addHabit(habit);
  }

  @override
  Stream<List<Habit>> getHabits(String userId) {
    return _firebaseFirestoreService.getHabitsByUser(userId);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _firebaseFirestoreService.updateHabit(habit);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _firebaseFirestoreService.deleteHabit(id);
  }

  @override
  Future<void> toggleHabitCompletion(Habit habit) async {
    final updatedHabit = habit.copyWith(
      isCompleted: !habit.isCompleted,
      completedDate: !habit.isCompleted ? DateTime.now() : null,
    );
    await _firebaseFirestoreService.updateHabit(updatedHabit);
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    return await _firebaseFirestoreService.getHabitById(id);
  }
}
