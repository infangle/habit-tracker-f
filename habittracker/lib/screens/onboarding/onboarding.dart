import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboarding_background, // #8E97FD
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/logo/logo.svg',
                  width: 100,
                  height: 100,
                ),
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
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: Size(double.infinity, 40),
                  backgroundColor:
                      AppColors.primary_white, // White for contrast
                  foregroundColor: AppColors.text, // Dark text
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: AppColors.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
