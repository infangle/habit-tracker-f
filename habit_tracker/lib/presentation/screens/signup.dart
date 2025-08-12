import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controllers/AuthController.dart';

class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
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
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) => authController.setUsername(value),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) => authController.setPassword(value),
              ),
              ElevatedButton(
                onPressed: authController.signUpUser,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
