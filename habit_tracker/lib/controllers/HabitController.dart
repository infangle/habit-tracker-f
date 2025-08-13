// lib/controllers/HabitController.dart

import 'package:get/get.dart';
import 'package:habit_tracker/controllers/AuthController.dart';
import 'package:habit_tracker/domain/models/habit.dart';
import 'package:habit_tracker/domain/repositories/habit_repository.dart';

class HabitController extends GetxController {
  final HabitRepository _habitRepository = Get.find<HabitRepository>();
  final AuthController _authController = Get.find<AuthController>();
  final RxList<Habit> habits = <Habit>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to the user state changes in AuthController to load habits
    _authController.user.listen((firebaseUser) {
      if (firebaseUser != null) {
        loadHabits();
      } else {
        // Clear habits if the user logs out
        habits.clear();
      }
    });
  }

  Future<void> loadHabits() async {
    try {
      isLoading.value = true;
      final userId = _authController.user.value?.uid;
      if (userId != null) {
        final habitsList = await _habitRepository.getHabitsForUser(userId);
        habits.assignAll(habitsList);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load habits: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHabit(Habit newHabit) async {
    try {
      isLoading.value = true;
      final userId = _authController.user.value?.uid;
      if (userId != null) {
        await _habitRepository.addHabit(newHabit.copyWith(userId: userId));
        Get.snackbar('Success', 'Habit added successfully');
      } else {
        Get.snackbar('Error', 'User not authenticated.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add habit: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    try {
      isLoading.value = true;
      final userId = _authController.user.value?.uid;
      if (userId != null) {
        await _habitRepository.updateHabit(updatedHabit);
        Get.snackbar('Success', 'Habit updated successfully');
      } else {
        Get.snackbar('Error', 'User not authenticated.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update habit: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeHabit(String habitId) async {
    try {
      isLoading.value = true;
      final userId = _authController.user.value?.uid;
      if (userId != null) {
        await _habitRepository.deleteHabit(habitId, userId);
        Get.snackbar('Success', 'Habit removed successfully');
      } else {
        Get.snackbar('Error', 'User not authenticated.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove habit: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markHabitCompleted(String habitId, DateTime date) async {
    try {
      isLoading.value = true;
      final habit = habits.firstWhere((h) => h.id == habitId);
      final updatedDates =
          habit.completedDates.any(
            (d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day,
          )
          ? habit.completedDates
                .where(
                  (d) =>
                      d.year != date.year ||
                      d.month != date.month ||
                      d.day != date.day,
                )
                .toList()
          : [...habit.completedDates, date];

      final updatedHabit = habit.copyWith(completedDates: updatedDates);
      await _habitRepository.updateHabit(updatedHabit);
      Get.snackbar(
        'Success',
        updatedDates.contains(date)
            ? 'Habit marked as completed'
            : 'Habit unmarked',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle habit: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
