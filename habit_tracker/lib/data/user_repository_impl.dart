import 'package:http/http.dart' as http;
import 'package:habit_tracker/domain/repositories/user_repository.dart';
import 'dart:convert';

class UserRepositoryImpl implements UserRepository {
  final String baseUrl =
      'http://localhost:3000'; // Base URL for the JSON server

  @override
  Future<bool> login(String email, String password) async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      // Parse the response body to check if the user with the given email and password exists
      final List<dynamic> users = json.decode(response.body);
      for (var user in users) {
        if (user['email'] == email && user['password'] == password) {
          return true; // Login successful
        }
      }
    }
    return false; // Login failed
  }

  @override
  Future<bool> signup(String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      body: json.encode({
        'email': email,
        'password': password,
        'username': username,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return true; // Signup successful
    }
    return false; // Signup failed
  }
}
