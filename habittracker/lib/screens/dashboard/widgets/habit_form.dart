import 'package:flutter/material.dart';
import '../../../models/habit.dart';

class HabitForm extends StatefulWidget {
  final Function(Habit) onSave;
  final VoidCallback onCancel;

  const HabitForm({super.key, required this.onSave, required this.onCancel});

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedFrequency = 'Daily';

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Custom'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        frequency: _selectedFrequency,
        startDate: DateTime.now(),
        isCompleted: false,
      );
      widget.onSave(newHabit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Add New Habit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Habit Name Field
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Habit Name',
              hintText: 'e.g., Morning Exercise',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.task_alt),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a habit name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Frequency Selection
          Text(
            'Frequency',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),

          // Radio buttons for frequency
          Column(
            children: _frequencies.map((frequency) {
              return RadioListTile<String>(
                title: Text(frequency),
                value: frequency,
                groupValue: _selectedFrequency,
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            }).toList(),
          ),
          SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Cancel Button
              ElevatedButton(
                onPressed: widget.onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: Size(120, 40),
                ),
                child: Text('Cancel'),
              ),

              // Save Button
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(120, 40),
                ),
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
