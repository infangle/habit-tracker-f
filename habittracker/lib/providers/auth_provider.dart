import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/repositories/auth_repository.dart';
import '../core/repositories/firebase_auth_repository.dart';
import '../domain/entities/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = FirebaseAuthRepository();
  String? _errorMessage;
  bool _isLoading = false;
  UserProfile? _currentUser;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  UserProfile? get currentUser => _currentUser;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signUp(email, password, username);
      _errorMessage = null;

      // Get the newly created user
      await getCurrentUser();
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.login(email, password);
      _errorMessage = null;

      // Get the logged in user
      await getCurrentUser();
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    try {
      _currentUser = await _authRepository.getCurrentUser();
      notifyListeners();
    } on Exception catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
