import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(bodyLarge: TextStyle(color: AppColors.text)),
  );
}
