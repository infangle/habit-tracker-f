import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Hello, Welcome to Main Habbits',
              style: TextStyle(
                color: AppColors.text_secondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Explore the app, Find some peace of mind to achieve good habbits',
              style: TextStyle(color: AppColors.text, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SvgPicture.asset('assets/images/onboarding.svg'),
            const SizedBox(height: 20),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
