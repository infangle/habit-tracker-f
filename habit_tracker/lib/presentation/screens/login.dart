import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/AuthController.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: GetBuilder<AuthController>(
          builder: (controller) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => authController.setEmail(value),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) => authController.setPassword(value),
              ),
              ElevatedButton(
                onPressed: authController.loginUser,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
