import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/HabitController.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  final HabitController habitController = Get.put(HabitController());

  DashboardScreen({super.key}); // Use Get.put to initialize the controller

  @override
  Widget build(BuildContext context) {
    String username = "Mert"; // Replace with actual username from user profile
    Rx<DateTime> selectedDate = DateTime.now().obs;

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () =>
                      Text('Hi, $username 👋', style: TextStyle(fontSize: 20)),
                ),
                Text(
                  'Let\'s make habits together!',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => selectDate(context),
            child: Text('Today'),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate.value)}",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Date'),
                      content: Text('Calendar widget goes here'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Select Date'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              '25% Your daily goals almost done! 🔥\n1 of 4 completed.',
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: habitController.habits.length,
                itemBuilder: (context, index) {
                  final habit = habitController.habits[index];
                  return ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (value) {
                        // Implement checkbox functionality
                      },
                    ),
                    title: Text(habit),
                    subtitle: Text("500/2000 ML"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement edit functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            habitController.removeHabit(habit);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddHabitDialog(context);
              },
              child: Text('Add Habit'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    TextEditingController habitNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Habit'),
          content: TextField(
            controller: habitNameController,
            decoration: InputDecoration(hintText: 'Enter habit name'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (habitNameController.text.isNotEmpty) {
                  habitController.addHabit(habitNameController.text);
                  habitNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
