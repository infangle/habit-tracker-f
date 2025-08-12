import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/AuthController.dart';
import 'package:habit_tracker/controllers/HabitController.dart';
import 'package:habit_tracker/presentation/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Habit Tracker',
      home: LoginScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(HabitController());
      }),
    );
  }
}
