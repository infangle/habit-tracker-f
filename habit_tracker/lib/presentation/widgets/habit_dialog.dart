import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/controllers/HabitController.dart';
import 'package:habit_tracker/domain/models/habit.dart';

class HabitDialog extends StatefulWidget {
  final Habit? habit;

  const HabitDialog({super.key, this.habit});

  @override
  _HabitDialogState createState() => _HabitDialogState();
}

class _HabitDialogState extends State<HabitDialog> {
  final TextEditingController _nameController = TextEditingController();
  final RxString _frequency = 'Daily'.obs;
  final Rx<DateTime?> _startDate = Rx<DateTime?>(null);
  final HabitController _habitController = Get.find();

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _frequency.value = widget.habit!.frequency;
      _startDate.value = widget.habit!.startDate;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      _startDate.value = picked;
    }
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
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                value: _frequency.value,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: ['Daily', 'Weekly'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => _frequency.value = value!,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                title: Text(
                  _startDate.value == null
                      ? 'Select Start Date'
                      : 'Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate.value!)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectStartDate(context),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              if (widget.habit == null) {
                _habitController.addHabit(
                  name: _nameController.text,
                  frequency: _frequency.value,
                  startDate: _startDate.value,
                );
              } else {
                _habitController.editHabit(
                  id: widget.habit!.id,
                  name: _nameController.text,
                  frequency: _frequency.value,
                  startDate: _startDate.value,
                );
              }
              Get.back();
            } else {
              Get.snackbar('Error', 'Habit name cannot be empty');
            }
          },
          child: Text(widget.habit == null ? 'Add' : 'Save'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
