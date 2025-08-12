// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:habit_tracker/controllers/AuthController.dart';
import 'package:habit_tracker/controllers/HabitController.dart';
import 'package:habit_tracker/presentation/screens/login.dart';
import 'package:habit_tracker/domain/models/habit.dart';
import 'package:habit_tracker/infrastructure/theme.dart';
import 'package:habit_tracker/data/user_repository_impl.dart';
import 'package:habit_tracker/data/habit_repository_impl.dart';
import 'package:habit_tracker/services/firebase_messaging_service.dart';
import 'package:habit_tracker/data/local_storage/habit_local_data_source.dart';
import 'package:habit_tracker/domain/repositories/habit_repository.dart';
import 'package:habit_tracker/domain/repositories/user_repository.dart';

// Assuming you have your firebase_options.dart file from your Firebase project
// import 'firebase_options.dart';

Future<void> main() async {
  // Ensure that the Flutter framework is initialized before using plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase to enable all Firebase services.
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // Uncomment with your firebase options
  );

  // Initialize Hive for local data storage for offline support.
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  // Register the adapter for the Habit model so Hive knows how to serialize it.
  Hive.registerAdapter(HabitAdapter());

  // Initialize Firebase Messaging Service to handle push notifications.
  final fcmService = FirebaseMessagingService();
  await fcmService.initNotifications();

  // Load the saved dark mode preference from SharedPreferences.
  final prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    // We'll use Get.put to initialize the dependencies once at the top level.
    // This is a more robust approach than `initialBinding`.
    Get.put<UserRepository>(UserRepositoryImpl());
    Get.put<HabitLocalDataSource>(HabitLocalDataSource());
    Get.put<HabitRepository>(HabitRepositoryImpl());
    Get.put<AuthController>(AuthController());
    Get.put<HabitController>(HabitController());

    return GetMaterialApp(
      title: 'Habit Tracker',
      // GetX provides an easy way to manage themes.
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LoginScreen(),
    );
  }
}
