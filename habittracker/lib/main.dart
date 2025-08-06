import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'screens/onboarding/onboarding.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
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
      },
    );
  }
}
