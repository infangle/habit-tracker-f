import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import '../screens/auth/signup_screen.dart';

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
      home: const SignupScreen(key: Key('signup_screen')),
    );
  }
}
