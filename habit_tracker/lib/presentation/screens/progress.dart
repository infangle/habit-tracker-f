import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
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
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Habit Completion Heatmap',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: _buildHeatmap(habitController)),
                ],
              ),
      ),
    );
  }

  Widget _buildHeatmap(HabitController habitController) {
    // Aggregate completion counts per day
    final Map<DateTime, int> datasets = {};
    for (final habit in habitController.habits) {
      for (final date in habit.completedDates) {
        // Normalize to date only (ignore time)
        final normalizedDate = DateTime(date.year, date.month, date.day);
        datasets.update(
          normalizedDate,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return HeatMapCalendar(
      defaultColor: Colors.grey[200],
      flexible: true,
      colorMode: ColorMode.opacity,
      datasets: datasets,
      colorsets: const {
        1: Colors.green, // Light green for 1 completion
        2: Colors.greenAccent, // Brighter for 2
        3: Colors.lightGreen, // Medium
        5: Colors.green, // Darker for higher
        7: Colors.teal, // Even more
      },
      onClick: (date) {
        final count = datasets[date] ?? 0;
        Get.snackbar(
          'Day Details',
          '$count habits completed on ${date.toLocal().toString().split(' ')[0]}',
        );
      },
    );
  }
}
