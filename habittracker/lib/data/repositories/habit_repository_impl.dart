import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final FirebaseFirestore _firestore;

  HabitRepositoryImpl(this._firestore);

  @override
  Future<void> addHabit(Habit habit) async {
    await _firestore.collection('habits').add(habit.toFirestore());
  }

  @override
  Future<List<Habit>> getHabits(String userId) async {
    final snapshot = await _firestore
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Habit.fromFirestore(doc.id, data);
    }).toList();
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _firestore
        .collection('habits')
        .doc(habit.id)
        .update(habit.toFirestore());
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _firestore.collection('habits').doc(id).delete();
  }

  @override
  Future<void> toggleHabitCompletion(Habit habit) async {
    final updatedHabit = habit.copyWith(
      isCompleted: !habit.isCompleted,
      completedDate: !habit.isCompleted ? DateTime.now() : null,
    );
    await _firestore
        .collection('habits')
        .doc(habit.id)
        .update(updatedHabit.toFirestore());
  }
}
