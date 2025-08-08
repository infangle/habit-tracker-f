import 'package:flutter/material.dart';

// Placeholder Habit class for now
class Habit {
  final String name;

  Habit({required this.name});
}

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: false, // Replace with actual completion status
          onChanged: (value) {
            // TODO: Handle habit completion
          },
        ),
        title: Text(habit.name),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            // TODO: Handle edit and delete actions
          },
        ),
      ),
    );
  }
}
