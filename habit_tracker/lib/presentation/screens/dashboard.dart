import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/controllers/AuthController.dart';
import 'package:habit_tracker/controllers/HabitController.dart';
import 'package:habit_tracker/domain/models/habit.dart';
import 'package:habit_tracker/presentation/screens/progress.dart';
import 'package:habit_tracker/presentation/widgets/habit_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final HabitController habitController = Get.find();
    final Rx<DateTime> selectedDate = DateTime.now().obs;

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Get.to(() => const ProgressScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: Obx(
        () => authController.isLoading.value || habitController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${authController.username.value.isEmpty ? "User" : authController.username.value} 👋',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const Text(
                          'Let\'s make habits together!',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate.value)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () => selectDate(context),
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      final habits = habitController.habits;
                      final completedToday = habits
                          .where(
                            (h) => h.completedDates.any(
                              (d) =>
                                  d.year == selectedDate.value.year &&
                                  d.month == selectedDate.value.month &&
                                  d.day == selectedDate.value.day,
                            ),
                          )
                          .length;
                      final totalHabits = habits.length;
                      final percentage = totalHabits > 0
                          ? ((completedToday / totalHabits) * 100)
                                .toStringAsFixed(0)
                          : '0';
                      return Text(
                        '$percentage% Your daily goals almost done! 🔥\n$completedToday of $totalHabits completed.',
                        style: const TextStyle(fontSize: 16),
                      );
                    }),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: habitController.habits.length,
                        itemBuilder: (context, index) {
                          final habit = habitController.habits[index];
                          final isCompletedToday = habit.completedDates.any(
                            (d) =>
                                d.year == selectedDate.value.year &&
                                d.month == selectedDate.value.month &&
                                d.day == selectedDate.value.day,
                          );
                          return ListTile(
                            leading: Checkbox(
                              value: isCompletedToday,
                              onChanged: (value) {
                                habitController.markHabitCompleted(
                                  habit.id,
                                  selectedDate.value,
                                );
                              },
                            ),
                            title: Text(habit.name),
                            subtitle: Text('Frequency: ${habit.frequency}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Get.dialog(HabitDialog(habit: habit));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    habitController.removeHabit(habit.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => Get.dialog(const HabitDialog()),
                      child: const Text('Add Habit'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
