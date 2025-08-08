import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dashboard/widgets/habit_list.dart';
import '../dashboard/widgets/progress_summary.dart';
import '../dashboard/widgets/habit_form.dart';
import '../../models/habit.dart';
import '../../core/constants/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String _currentTime;
  late Timer _timer;
  String? _username;
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    _currentTime = _formatDateTime(DateTime.now());
    _username =
        FirebaseAuth.instance.currentUser?.displayName ??
        FirebaseAuth.instance.currentUser?.email?.split('@')[0] ??
        'User';

    // Initialize habits with dummy data
    habits = [
      Habit(id: '1', name: 'Morning Exercise', frequency: 'Daily'),
      Habit(id: '2', name: 'Read 30 minutes', frequency: 'Daily'),
      Habit(id: '3', name: 'Drink 8 glasses of water', frequency: 'Daily'),
      Habit(id: '4', name: 'Meditate 10 minutes', frequency: 'Daily'),
      Habit(id: '5', name: 'Practice coding', frequency: 'Daily'),
    ];

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _formatDateTime(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onboarding_background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message and current date/time
                Card(
                  color: AppColors.facebook_button,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello $_username,',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_secondary,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: AppColors.text_secondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _currentTime,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_secondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Progress Summary
                Text(
                  'Progress Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                ProgressSummary(habits: habits),
                SizedBox(height: 20),

                // Habit List
                Text(
                  'Your Habits',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 300,
                  child: HabitList(
                    habits: habits,
                    onToggle: (index, value) {
                      setState(() {
                        habits[index].isCompleted = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.onboarding_background,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add New Habit'),
              content: SingleChildScrollView(
                child: HabitForm(
                  onSave: (newHabit) {
                    setState(() {
                      habits.add(newHabit);
                    });
                    Navigator.pop(context);
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add, color: AppColors.text_secondary),
      ),
    );
  }
}
