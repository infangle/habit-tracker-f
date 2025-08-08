import 'package:flutter/material.dart';
import '../../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final Function(bool?) onToggle;

  const HabitCard({super.key, required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: habit.isCompleted, onChanged: onToggle),
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
