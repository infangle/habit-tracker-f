// lib/controllers/AuthController.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/presentation/screens/dashboard.dart';
import 'package:habit_tracker/presentation/screens/login.dart';
import 'package:habit_tracker/domain/repositories/user_repository.dart';

class AuthController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // The RxBool keeps track of the loading state for UI feedback.
  final RxBool isLoading = false.obs;

  // The Rx<User?> stores the current authenticated user.
  // We use Rx to make it observable for reactive programming.
  final Rx<User?> user = Rx<User?>(null);

  // The RxString stores the user's username.
  final RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // This listener will automatically update the user state whenever
    // the authentication state changes (login, logout, etc.).
    _auth.authStateChanges().listen((User? firebaseUser) async {
      user.value = firebaseUser;
      if (firebaseUser != null) {
        await _fetchUsername(firebaseUser.uid);
        Get.offAll(() => const DashboardScreen());
      } else {
        username.value = '';
        Get.offAll(() => LoginScreen());
      }
    });
  }

  Future<void> _fetchUsername(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        username.value = doc.data()?['username'] ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch username: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _userRepository.login(email, password);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String email, String password, String username) async {
    try {
      isLoading.value = true;
      await _userRepository.signup(email, password, username);
    } catch (e) {
      Get.snackbar('Signup Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _userRepository.logout();
    } catch (e) {
      Get.snackbar('Logout Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
