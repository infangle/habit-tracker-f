import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = "An unknown error occurred";
    }

    _isLoading = false;
    notifyListeners();
  }
}
