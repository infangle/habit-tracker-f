import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'firebase_options.dart';
import 'screens/onboarding/onboarding.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/habit_provider.dart';
import 'screens/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(key: Key('onboarding_screen')),
      routes: {
        '/login': (context) => const LoginScreen(key: Key('login_screen')),
        '/signup': (context) => Consumer<AuthProvider>(
          builder: (context, signupProvider, child) {
            return SignupScreen(key: Key('signup_screen'));
          },
        ),
        '/home': (context) => DashboardScreen(),
      },
    );
  }
}
