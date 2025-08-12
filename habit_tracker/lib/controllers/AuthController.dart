// AuthController.dart
import 'package:get/get.dart';
import 'package:habit_tracker/data/user_repository_impl.dart';
import 'package:habit_tracker/presentation/screens/dashboard.dart';
import 'package:habit_tracker/presentation/screens/login.dart';

class AuthController extends GetxController {
  final UserRepositoryImpl userRepository = Get.find<UserRepositoryImpl>();
  final RxString userId = ''.obs;
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString username = ''.obs;
  final RxBool isLoading = false.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;
  void setUsername(String value) => username.value = value;

  Future<void> loginUser() async {
    try {
      isLoading.value = true;
      final id = await userRepository.login(email.value, password.value);
      if (id != null) {
        userId.value = id;
        Get.off(() => DashboardScreen());
        Get.snackbar('Success', 'Login successful!');
      } else {
        Get.snackbar('Error', 'Invalid email or password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpUser() async {
    try {
      isLoading.value = true;
      final success = await userRepository.signup(
        email.value,
        password.value,
        username.value,
      );
      if (success) {
        final id = await userRepository.login(email.value, password.value);
        userId.value = id ?? '';
        Get.off(() => DashboardScreen());
        Get.snackbar('Success', 'Signup successful!');
      } else {
        Get.snackbar('Error', 'Signup failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Signup failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await userRepository.logout();
      userId.value = '';
      email.value = '';
      password.value = '';
      username.value = '';
      Get.offAll(() => LoginScreen());
      Get.snackbar('Success', 'Logged out successfully');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
