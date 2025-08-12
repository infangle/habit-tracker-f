import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/controllers/HabitController.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController habitController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Tracking')),
      body: Obx(
        () => habitController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : habitController.habits.isEmpty
            ? const Center(child: Text('No habits to show'))
            : ListView.builder(
                itemCount: habitController.habits.length,
                itemBuilder: (context, index) {
                  final habit = habitController.habits[index];
                  final completionCount = habit.completedDates.length;
                  final weeklyCompletions = habit.completedDates
                      .where(
                        (d) => d.isAfter(
                          DateTime.now().subtract(const Duration(days: 7)),
                        ),
                      )
                      .length;
                  final monthlyCompletions = habit.completedDates
                      .where(
                        (d) => d.isAfter(
                          DateTime.now().subtract(const Duration(days: 30)),
                        ),
                      )
                      .length;
                  return ListTile(
                    title: Text(habit.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Frequency: ${habit.frequency}'),
                        Text('Total Completions: $completionCount'),
                        Text('Last 7 Days: $weeklyCompletions'),
                        Text('Last 30 Days: $monthlyCompletions'),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
