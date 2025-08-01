import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';

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
      home: const Scaffold(body: Center(child: Text('Habit Tracker'))),
    );
  }
}
