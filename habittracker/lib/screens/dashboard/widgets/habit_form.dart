import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/core/constants/app_colors.dart';
import 'package:habittracker/domain/entities/habit.dart';
import 'package:habittracker/providers/auth_provider.dart';
import 'package:habittracker/providers/habit_provider.dart';
import 'package:uuid/uuid.dart';

class HabitForm extends StatefulWidget {
  final Function(Habit) onSave;
  final VoidCallback onCancel;
  final String userId;

  const HabitForm({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.userId,
  });

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _frequencyController = TextEditingController();
  bool _isCompleted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final habit = Habit(
        id: const Uuid().v4(),
        name: _nameController.text,
        frequency: _frequencyController.text,
        startDate: DateTime.now(),
        isCompleted: _isCompleted,
        completedDate: _isCompleted ? DateTime.now() : null,
        userId: widget.userId,
      );
      widget.onSave(habit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.currentUser == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                filled: true,
                fillColor: AppColors.text_field,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a habit name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _frequencyController,
              decoration: InputDecoration(
                labelText: 'Frequency (e.g., daily, weekly)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                filled: true,
                fillColor: AppColors.text_field,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a frequency';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Completed'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.login_button,
                    foregroundColor: AppColors.primary_white,
                  ),
                  onPressed: _submitForm,
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
