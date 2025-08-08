import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:habittracker/data/services/firebase_firestore_service.dart';
import 'package:habittracker/data/repositories/habit_repository_impl.dart';
import 'package:habittracker/domain/usecases/add_habit_use_case.dart';
import 'package:habittracker/domain/usecases/get_habits_use_case.dart';
import 'package:habittracker/domain/usecases/update_habit_use_case.dart';
import 'package:habittracker/domain/usecases/delete_habit_use_case.dart';
import 'package:habittracker/providers/auth_provider.dart';
import 'package:habittracker/providers/habit_provider.dart';
import 'package:habittracker/screens/auth/login_screen.dart';
import 'package:habittracker/screens/auth/signup_screen.dart';
import 'package:habittracker/screens/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final firestoreService = FirebaseFirestoreService();
            final habitRepository = HabitRepositoryImpl(
              firestoreService: firestoreService,
            );
            return HabitProvider(
              addHabitUseCase: AddHabitUseCase(habitRepository),
              getHabitsUseCase: GetHabitsUseCase(habitRepository),
              updateHabitUseCase: UpdateHabitUseCase(habitRepository),
              deleteHabitUseCase: DeleteHabitUseCase(habitRepository),
              authProvider: Provider.of<AuthProvider>(context, listen: false),
            );
          },
        ),
      ],
      child: MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
