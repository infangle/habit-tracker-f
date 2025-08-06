import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_white, // White background
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max, // Fill screen height
            mainAxisAlignment: MainAxisAlignment.center, // Push Row to bottom
            children: [
              Column(
                children: [
                  Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.text,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      minimumSize: Size(double.infinity, 40),
                      backgroundColor: AppColors.google_button, // #EBEAEC
                      foregroundColor: AppColors.text, // Dark text/icon
                    ),
                    onPressed: () {
                      // TODO: Implement login with Google
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/google.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Continue with Google',
                          style: TextStyle(color: AppColors.text),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'OR SIGNUP WITH EMAIL',
                    style: TextStyle(
                      color: AppColors.button_text,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            filled: true,
                            fillColor: AppColors.text_field, // #A1A4B2
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            filled: true,
                            fillColor: AppColors.text_field, // #A1A4B2
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            filled: true,
                            fillColor: AppColors.text_field, // #A1A4B2
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            minimumSize: Size(double.infinity, 40),
                            backgroundColor: AppColors.login_button, // #8E97FD
                            foregroundColor:
                                AppColors.primary_white, // White text
                          ),
                          onPressed: () {
                            // TODO: Implement login with email
                          },
                          child: Text('SIGN UP'),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'I have read the ',
                              style: TextStyle(
                                color: AppColors.text,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Open terms and conditions page
                              },
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.login_button,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ALREADY HAVE AN ACCOUNT?',
                    style: TextStyle(
                      color: AppColors.button_text,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: AppColors.login_button,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
