// add_habit_screen.dart

import 'package:flutter/material.dart';

class AddHabitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Habit')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement add habit functionality
            Navigator.pop(context);
          },
          child: Text('Add Habit'),
        ),
      ),
    );
  }
}
