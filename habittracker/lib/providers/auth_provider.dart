import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/repositories/auth_repository.dart';
import '../core/repositories/firebase_auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = FirebaseAuthRepository();
  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signUp(email, password);
      _errorMessage = null;
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
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
