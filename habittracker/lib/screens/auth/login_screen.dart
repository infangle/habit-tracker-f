import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/core/constants/app_colors.dart';
import 'package:habittracker/providers/auth_provider.dart';
import 'package:habittracker/screens/dashboard/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    await provider.login(_emailController.text, _passwordController.text);

    if (provider.errorMessage == null && provider.currentUser != null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome back, ${provider.currentUser!.displayName}!'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

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
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.text,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  SizedBox(height: 40),
                  Form(
                    child: Column(
                      children: [
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
                          onPressed: provider.isLoading
                              ? null
                              : () => _handleLogin(context),
                          child: provider.isLoading
                              ? const CircularProgressIndicator()
                              : const Text('LOG IN'),
                        ),
                        if (provider.errorMessage != null) ...[
                          SizedBox(height: 10),
                          Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to forgot password screen
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.text,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
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
                    'DON\'T HAVE AN ACCOUNT?',
                    style: TextStyle(
                      color: AppColors.button_text,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'SIGN UP',
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
