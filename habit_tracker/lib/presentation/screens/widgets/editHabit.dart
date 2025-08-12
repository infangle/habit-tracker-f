// edit_habit_screen.dart

import 'package:flutter/material.dart';

class EditHabitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Habit')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement edit habit functionality
            Navigator.pop(context);
          },
          child: Text('Save Changes'),
        ),
      ),
    );
  }
}
