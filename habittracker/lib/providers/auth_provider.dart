import 'package:flutter/foundation.dart';
import '../core/repositories/auth_repository.dart';
import '../core/repositories/firebase_auth_repository.dart';
import '../core/entities/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = FirebaseAuthRepository();
  String? _errorMessage;
  bool _isLoading = false;
  UserProfile? _currentUser;

  AuthProvider() {
    getCurrentUser(); // Initialize currentUser on creation
  }

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

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } on Exception catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
