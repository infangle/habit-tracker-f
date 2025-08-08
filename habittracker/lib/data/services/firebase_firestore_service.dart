import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/domain/entities/habit.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference for habits
  CollectionReference get _habitsCollection => _firestore.collection('habits');

  /// Adds a new habit to Firestore
  Future<void> addHabit(Habit habit) async {
    try {
      await _habitsCollection.add(habit.toFirestore());
    } catch (e) {
      throw Exception('Failed to add habit: $e');
    }
  }

  /// Gets a stream of all habits from Firestore
  Stream<List<Habit>> getHabits() {
    return _habitsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Habit.fromFirestore(doc.id, data);
      }).toList();
    });
  }

  /// Gets a stream of habits filtered by user ID
  Stream<List<Habit>> getHabitsByUser(String userId) {
    return _habitsCollection.where('userId', isEqualTo: userId).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Habit.fromFirestore(doc.id, data);
        }).toList();
      },
    );
  }

  /// Updates an existing habit in Firestore
  Future<void> updateHabit(Habit habit) async {
    try {
      if (habit.id.isEmpty) {
        throw Exception('Habit ID is required for update');
      }
      await _habitsCollection.doc(habit.id).update(habit.toFirestore());
    } catch (e) {
      throw Exception('Failed to update habit: $e');
    }
  }

  /// Deletes a habit from Firestore
  Future<void> deleteHabit(String id) async {
    try {
      await _habitsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }

  /// Gets a single habit by ID
  Future<Habit?> getHabitById(String id) async {
    try {
      final doc = await _habitsCollection.doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Habit.fromFirestore(doc.id, data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get habit: $e');
    }
  }

  /// Gets habits filtered by completion status
  Stream<List<Habit>> getHabitsByCompletion(bool isCompleted) {
    return _habitsCollection
        .where('isCompleted', isEqualTo: isCompleted)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Habit.fromFirestore(doc.id, data);
          }).toList();
        });
  }

  /// Gets habits filtered by frequency
  Stream<List<Habit>> getHabitsByFrequency(String frequency) {
    return _habitsCollection
        .where('frequency', isEqualTo: frequency)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Habit.fromFirestore(doc.id, data);
          }).toList();
        });
  }

  /// Gets habits ordered by creation date
  Stream<List<Habit>> getHabitsOrderedByDate({bool descending = true}) {
    return _habitsCollection
        .orderBy('createdAt', descending: descending)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Habit.fromFirestore(doc.id, data);
          }).toList();
        });
  }
}
