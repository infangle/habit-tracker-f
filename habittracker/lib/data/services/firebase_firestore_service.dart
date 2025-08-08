import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addHabit(String userId, Habit habit) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .set(habit.toFirestore());
  }

  Stream<List<Habit>> getHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Habit.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> updateHabit(String userId, Habit habit) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .update(habit.toFirestore());
  }

  Future<void> deleteHabit(String userId, String habitId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId)
        .delete();
  }

  Future<Habit?> getHabitById(String userId, String habitId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId)
        .get();
    return doc.exists ? Habit.fromFirestore(doc.id, doc.data()!) : null;
  }

  Stream<List<Habit>> getHabitsByCompletion(String userId, bool isCompleted) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .where('isCompleted', isEqualTo: isCompleted)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Habit.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<Habit>> getHabitsByFrequency(String userId, String frequency) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .where('frequency', isEqualTo: frequency)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Habit.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<Habit>> getHabitsOrderedByDate(
    String userId, {
    bool descending = true,
  }) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('createdAt', descending: descending)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Habit.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }
}
