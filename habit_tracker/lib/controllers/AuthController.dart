import 'package:get/get.dart';

class AuthController extends GetxController {
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString username = ''.obs;

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void setUsername(String value) {
    username.value = value;
  }

  void loginUser() {
    // Implement your login logic here using email and password
    print(
      'Logging in with email: ${email.value} and password: ${password.value}',
    );
    // Add your authentication logic
  }

  void signUpUser() {
    // Implement your signup logic here using email, password, and username
    print(
      'Signing up with email: ${email.value}, password: ${password.value}, and username: ${username.value}',
    );
    // Add your authentication logic
  }
}
