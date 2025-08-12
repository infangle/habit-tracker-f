// HabitController.dart
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/AuthController.dart';
import 'package:habit_tracker/data/habit_repository_impl.dart';
import 'package:habit_tracker/domain/models/habit.dart';
import 'package:habit_tracker/domain/repositories/habit_repository.dart';

class HabitController extends GetxController {
  final HabitRepository _habitRepository = Get.find<HabitRepositoryImpl>();
  final AuthController _authController = Get.find<AuthController>();
  final RxList<Habit> habits = <Habit>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authController.userId.listen((userId) {
      if (userId.isNotEmpty) {
        loadHabits();
      }
    });
  }

  Future<void> loadHabits() async {
    try {
      isLoading.value = true;
      final habitsList = await _habitRepository.getHabitsForUser(
        _authController.userId.value,
      );
      habits.assignAll(habitsList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load habits: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHabit({
    required String name,
    required String frequency,
    DateTime? startDate,
  }) async {
    try {
      isLoading.value = true;
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _authController.userId.value,
        name: name,
        frequency: frequency,
        startDate: startDate,
      );
      await _habitRepository.addHabit(newHabit);
      await loadHabits();
      Get.snackbar('Success', 'Habit added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add habit: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editHabit({
    required String id,
    required String name,
    required String frequency,
    DateTime? startDate,
  }) async {
    try {
      isLoading.value = true;
      final existingHabit = habits.firstWhere((h) => h.id == id);
      final updatedHabit = Habit(
        id: id,
        userId: existingHabit.userId,
        name: name,
        frequency: frequency,
        startDate: startDate,
        completedDates: existingHabit.completedDates,
      );
      await _habitRepository.updateHabit(updatedHabit);
      await loadHabits();
      Get.snackbar('Success', 'Habit updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update habit: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeHabit(String habitId) async {
    try {
      isLoading.value = true;
      await _habitRepository.deleteHabit(habitId, _authController.userId.value);
      await loadHabits();
      Get.snackbar('Success', 'Habit removed successfully');
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
      final updatedDates = habit.completedDates.contains(date)
          ? habit.completedDates.where((d) => d != date).toList()
          : [...habit.completedDates, date];
      final updatedHabit = Habit(
        id: habit.id,
        userId: habit.userId,
        name: habit.name,
        frequency: habit.frequency,
        startDate: habit.startDate,
        completedDates: updatedDates,
      );
      await _habitRepository.updateHabit(updatedHabit);
      await loadHabits();
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
