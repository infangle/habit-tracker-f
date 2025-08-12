// lib/data/habit_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/data/local_storage/habit_local_data_source.dart';
import 'package:habit_tracker/domain/models/habit.dart';
import 'package:habit_tracker/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HabitLocalDataSource _localDataSource =
      Get.find<HabitLocalDataSource>();

  @override
  Future<List<Habit>> getHabitsForUser(String userId) async {
    try {
      // First, try to get from Firestore
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .get();

      final habits = snapshot.docs
          .map((doc) => Habit.fromFirestore(doc))
          .toList();

      // Cache the data locally for offline access
      if (habits.isNotEmpty) {
        await _localDataSource.saveHabits(habits);
      }

      return habits;
    } catch (e) {
      // On error (e.g., network issues), return cached data
      final localHabits = await _localDataSource.getHabits();
      if (localHabits.isNotEmpty) {
        return localHabits;
      }
      // Re-throw if no local data available
      rethrow;
    }
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      try {
        // Add habit to Firestore
        final docRef = await _firestore
            .collection('users')
            .doc(uid)
            .collection('habits')
            .add(habit.toFirestore());

        final newHabit = habit.copyWith(id: docRef.id, userId: uid);

        // Save the habit to the local cache as well
        await _localDataSource.saveHabit(newHabit);
      } catch (e) {
        // If Firestore fails, still save to local cache for offline persistence
        await _localDataSource.saveHabit(habit.copyWith(userId: uid));
        rethrow;
      }
    } else {
      throw Exception('User not authenticated');
    }
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null && habit.id != null) {
      try {
        // Update habit in Firestore
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('habits')
            .doc(habit.id)
            .update(habit.toFirestore());

        // Update the habit in the local cache
        await _localDataSource.saveHabit(habit);
      } catch (e) {
        // If Firestore fails, still update local cache for offline persistence
        await _localDataSource.saveHabit(habit);
        rethrow;
      }
    } else if (habit.id == null) {
      throw Exception('Habit ID is required for update');
    } else {
      throw Exception('User not authenticated');
    }
  }

  @override
  Future<void> deleteHabit(String habitId, String userId) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null && uid == userId) {
      try {
        // Delete habit from Firestore
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('habits')
            .doc(habitId)
            .delete();

        // Delete the habit from the local cache
        await _localDataSource.deleteHabit(habitId);
      } catch (e) {
        // If Firestore fails, still delete from local cache for consistency
        await _localDataSource.deleteHabit(habitId);
        rethrow;
      }
    } else {
      throw Exception('User not authenticated or user ID mismatch');
    }
  }
}
