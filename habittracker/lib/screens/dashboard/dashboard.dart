import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/core/constants/app_colors.dart';
import 'package:habittracker/core/entities/user.dart';
import 'package:habittracker/providers/auth_provider.dart';
import 'package:habittracker/providers/habit_provider.dart';
import 'widgets/habit_list.dart';
import 'widgets/progress_summary.dart';
import 'widgets/habit_form.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.currentUser?.displayName ?? 'User';

    if (authProvider.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onboarding_background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.signOut();
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
                              'Hello $username,',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_secondary,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: AppColors.text_secondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder(
                          stream: Stream.periodic(
                            const Duration(seconds: 1),
                            (i) => DateTime.now(),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final currentTime = snapshot.data;
                              return Text(
                                _formatDateTime(currentTime!),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_secondary,
                                  fontSize: 16,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Progress Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<HabitProvider>(
                  builder: (context, habitProvider, child) {
                    return ProgressSummary(habits: habitProvider.habits);
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Habits',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<HabitProvider>(
                  builder: (context, habitProvider, child) {
                    if (habitProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (habitProvider.error != null) {
                      return Center(
                        child: Text(
                          'Error: ${habitProvider.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (habitProvider.habits.isEmpty) {
                      return const Center(
                        child: Text(
                          'No habits yet. Add your first habit!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return HabitList(
                      habits: habitProvider.habits,
                      onToggle: (index, value) async {
                        final habit = habitProvider.habits[index];
                        await habitProvider.toggleHabitCompletion(habit);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.onboarding_background,
        onPressed: () {
          if (authProvider.currentUser == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please log in to add a habit')),
            );
            return;
          }
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add New Habit'),
              content: SingleChildScrollView(
                child: HabitForm(
                  onSave: (newHabit) async {
                    await Provider.of<HabitProvider>(
                      context,
                      listen: false,
                    ).addHabit(newHabit);
                    Navigator.pop(context);
                  },
                  onCancel: () => Navigator.pop(context),
                  userId: authProvider.currentUser!.id,
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: AppColors.text_secondary),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
