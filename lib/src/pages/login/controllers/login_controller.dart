import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/my_project.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/login_repository.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final LoginRepository loginRepository = LoginRepository();
  RxBool isLoading = false.obs;
  RxBool visible = false.obs;
  var rememberMe = false.obs;

  String? validator(String? value) {
    if (value != null) {
      if (value.isEmpty) return 'Required';
    }
    return null;
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    isLoading.value = true;
      try {
        final credentials = await loginRepository.getUserCredentials();
        print(credentials);
        isLoading.value = false;
        if (credentials.containsKey(username.text)) {
          if (credentials[username.text] == password.text) {
            if (rememberMe.value) {
              saveUserCredentials();
            }
            final userId = await loginRepository.getUserId(username.text);
            Get.offNamed(RouteNames.allEvents,
                parameters: {'userId': userId.toString()});
          } else {
            Get.showSnackbar(
              GetSnackBar(
                backgroundColor: Colors.red.shade900,
                title: 'Validation Error',
                message: 'Incorrect password',
                duration: const Duration(seconds: 4),
              ),
            );
          }
        } else {
          Get.showSnackbar(
            GetSnackBar(
              backgroundColor: Colors.red.shade900,
              title: 'Validation Error',
              message: 'User not found',
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (error) {
        Get.showSnackbar(
          GetSnackBar(
            message: 'An error occurred: $error',
            duration: const Duration(seconds: 3),
          ),
        );
      }

  }

  void toggleVisibility() {
    visible.value = !visible.value;
  }

  Future<void> saveUserCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('username', username.text);
    await preferences.setString('password', password.text);
  }

  Future<void> loadUserCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username.text = preferences.getString('username') ?? '';
    password.text = preferences.getString('password') ?? '';
  }

  void register() async {
    var userInfo = await Get.toNamed(RouteNames.register);
    if (userInfo != null) {
      username.text = userInfo['username'];
      password.text = userInfo['password'];
    }
  }
}
