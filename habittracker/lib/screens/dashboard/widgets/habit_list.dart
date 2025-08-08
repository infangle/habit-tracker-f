import 'package:flutter/material.dart';
import '../../../domain/entities/habit.dart';
import 'habit_card.dart';

class HabitList extends StatelessWidget {
  final List<Habit> habits;
  final Function(int, bool?) onToggle;

  const HabitList({super.key, required this.habits, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitCard(
          habit: habits[index],
          onToggle: (value) => onToggle(index, value),
        );
      },
    );
  }
}
