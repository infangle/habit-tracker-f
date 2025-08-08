import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Data layer
import 'data/repositories/habit_repository_impl.dart';

// Domain layer
import 'domain/usecases/add_habit_use_case.dart';
import 'domain/usecases/get_habits_use_case.dart';
import 'domain/usecases/update_habit_use_case.dart';
import 'domain/usecases/delete_habit_use_case.dart';

// Providers
import 'providers/habit_provider.dart';
import 'providers/auth_provider.dart';

// Screens
import 'screens/dashboard/dashboard.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection Setup
    final habitRepository = HabitRepositoryImpl(FirebaseFirestore.instance);

    final getHabitsUseCase = GetHabitsUseCase(habitRepository);
    final addHabitUseCase = AddHabitUseCase(habitRepository);
    final updateHabitUseCase = UpdateHabitUseCase(habitRepository);
    final deleteHabitUseCase = DeleteHabitUseCase(habitRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => HabitProvider(
            getHabitsUseCase: getHabitsUseCase,
            addHabitUseCase: addHabitUseCase,
            updateHabitUseCase: updateHabitUseCase,
            deleteHabitUseCase: deleteHabitUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return const LoginScreen();
      },
    );
  }
}
