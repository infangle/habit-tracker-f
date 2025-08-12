// lib/presentation/widgets/habit_dialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/HabitController.dart';
import 'package:habit_tracker/controllers/AuthController.dart';
import 'package:habit_tracker/domain/models/habit.dart';

class HabitDialog extends StatefulWidget {
  final Habit? habit;
  const HabitDialog({super.key, this.habit});

  @override
  _HabitDialogState createState() => _HabitDialogState();
}

class _HabitDialogState extends State<HabitDialog> {
  final HabitController habitController = Get.find();
  final AuthController authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final RxString frequency = 'Daily'.obs;
  final Rx<DateTime> startDate = DateTime.now().obs;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      // If we are editing, pre-fill the form with existing habit data.
      nameController.text = widget.habit!.name;
      frequency.value = widget.habit!.frequency;
      startDate.value = widget.habit!.startDate;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startDate.value) {
      startDate.value = picked;
    }
  }

  void _saveHabit() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a habit name.');
      return;
    }

    // Ensure the user is logged in before creating a habit.
    final currentUser = authController.user.value;
    if (currentUser == null) {
      Get.snackbar('Error', 'You must be logged in to save a habit.');
      return;
    }

    if (widget.habit == null) {
      // Adding a new habit
      final newHabit = Habit(
        userId: currentUser.uid,
        name: nameController.text,
        frequency: frequency.value,
        startDate: startDate.value,
      );
      habitController.addHabit(newHabit);
    } else {
      // Updating an existing habit
      final updatedHabit = widget.habit!.copyWith(
        name: nameController.text,
        frequency: frequency.value,
        startDate: startDate.value,
      );
      habitController.updateHabit(updatedHabit);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Habit Name'),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                value: frequency.value,
                decoration: const InputDecoration(labelText: 'Frequency'),
                items: ['Daily', 'Weekly', 'Monthly']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    frequency.value = value;
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      'Start Date: ${startDate.value.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _pickStartDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _saveHabit, child: const Text('Save')),
      ],
    );
  }
}
