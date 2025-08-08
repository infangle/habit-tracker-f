import 'package:flutter/material.dart';
import 'habit_card.dart';

class HabitList extends StatelessWidget {
  final List<Habit> habits;

  const HabitList({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitCard(habit: habits[index]);
      },
    );
  }
}
