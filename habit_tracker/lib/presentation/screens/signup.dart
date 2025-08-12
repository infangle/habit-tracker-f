import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/AuthController.dart';
import 'package:habit_tracker/presentation/screens/login.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: authController.setEmail,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onChanged: authController.setUsername,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: authController.setPassword,
              ),
              const SizedBox(height: 16),
              authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: authController.signUpUser,
                      child: const Text('Sign Up'),
                    ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.to(() => LoginScreen()),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
