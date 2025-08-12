import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add Habit functionality
              },
              child: Text('Add Habit'),
            ),
            ElevatedButton(
              onPressed: () {
                // Remove Habit functionality
              },
              child: Text('Remove Habit'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update Habit functionality
              },
              child: Text('Update Habit'),
            ),
            ElevatedButton(
              onPressed: () {
                // Clear All Habits functionality
              },
              child: Text('Clear All Habits'),
            ),
          ],
        ),
      ),
    );
  }
}
