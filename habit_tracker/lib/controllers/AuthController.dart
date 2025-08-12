import 'package:get/get.dart';
import 'package:habit_tracker/data/user_repository_impl.dart'; // Import the UserRepository implementation from the data layer

class AuthController extends GetxController {
  final UserRepositoryImpl
  userRepository; // Change UserRepository to UserRepositoryImpl
  AuthController(this.userRepository);

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
    userRepository
        .login(
          email.value,
          password.value,
        ) // Use the email and password values from the RxStrings
        .then((success) {
          if (success) {
            // Handle successful login, navigate to the next screen, etc.
            print('Login successful!');
          } else {
            // Handle login failure, show error message, etc.
            print('Login failed. Please try again.');
          }
        })
        .catchError((error) {
          // Handle any errors that occur during the login process
          print('An error occurred: $error');
        });
  }

  void signUpUser() {
    userRepository
        .signup(
          email.value,
          password.value,
          username.value,
        ) // Use the email, password, and username values from the RxStrings
        .then((success) {
          if (success) {
            // Handle successful signup, navigate to the next screen, etc.
            print('Signup successful!');
          } else {
            // Handle signup failure, show error message, etc.
            print('Signup failed. Please try again.');
          }
        })
        .catchError((error) {
          // Handle any errors that occur during the signup process
          print('An error occurred: $error');
        });
  }
}
