import 'package:flutter/material.dart';
import '../../../domain/entities/habit.dart';

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
  final _startDateController = TextEditingController();
  String _selectedFrequency = 'Daily';
  DateTime? _selectedStartDate;

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Custom'];

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.now();
    _startDateController.text = _formatDate(_selectedStartDate!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = _formatDate(picked);
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        frequency: _selectedFrequency,
        startDate: _selectedStartDate,
        userId: widget.userId,
        isCompleted: false,
      );
      widget.onSave(newHabit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

            // Start Date Field
            TextFormField(
              controller: _startDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Date',
                hintText: 'Select start date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: _selectStartDate,
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
      ),
    );
  }
}
