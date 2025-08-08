import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Data layer
import 'data/repositories/habit_repository_impl.dart';
import 'data/services/firebase_firestore_service.dart';

// Domain layer
import 'domain/usecases/add_habit_use_case.dart';
import 'domain/usecases/get_habits_use_case.dart';
import 'domain/usecases/update_habit_use_case.dart';
import 'domain/usecases/delete_habit_use_case.dart';

// Providers
import 'providers/habit_provider.dart';
import 'providers/auth_provider.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'firebase_options.dart';

// Main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection Setup
    final firebaseFirestoreService = FirebaseFirestoreService();
    final habitRepository = HabitRepositoryImpl(firebaseFirestoreService);

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
