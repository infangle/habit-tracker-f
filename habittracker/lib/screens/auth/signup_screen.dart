import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/signup_provider.dart';
import '../../core/constants/app_colors.dart';
import '../dashboard/home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(); // Not used yet

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<SignupProvider>(context, listen: false);
    await provider.signUp(_emailController.text, _passwordController.text);

    if (provider.errorMessage == null) {
      // ✅ Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signup successful!')));

      // ✅ Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primary_white,
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 20),
              const Text('OR SIGNUP WITH EMAIL'),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter a username'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) => value == null || value.length < 6
                          ? 'Minimum 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _handleSignUp(context),
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('SIGN UP'),
                    ),
                    if (provider.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ALREADY HAVE AN ACCOUNT?'),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: AppColors.login_button),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
