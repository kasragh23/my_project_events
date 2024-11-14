import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../model/register_dto.dart';
import '../repositories/register_repository.dart';


class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();
  RxBool visible1 = false.obs;
  RxBool visible2 = false.obs;
  var isLoading = false.obs;
  var passError = ''.obs;
  var selectedGender = ''.obs;

  final RegisterRepository _registerRepository = RegisterRepository();

  String? validator(String? value) {
    if (value != null) {
      if (value.isEmpty) return 'Required';
    }
    return null;
  }

  String? passValidator(String? value) {
    if (value != null) {
      if (value.isEmpty) return 'Required';
      if (value.length < 6) return 'must be more than 6 characters';
    }
    return null;
  }

  Future<void> register() async {
    if (formKey.currentState?.validate() ?? false) {
      if (password.text == confirmPass.text) {
        passError.value = '';
        isLoading.value = true;
        try {
          final RegisterDto dto = RegisterDto(
            username: username.text,
            password: password.text,
          );
          await _registerRepository.registerUser(dto: dto);
          Get.back(result: {'username':username.text, 'password':password.text});


        } catch (error) {
          passError.value = 'An error occurred: $error';
        } finally {
          isLoading.value = false;
        }
      } else {
        passError.value = 'Password does not match. Please try again';
      }
    }
  }

  void toggleVisibility1(){
    visible1.value = !visible1.value;
  }
  void toggleVisibility2(){
    visible2.value = !visible2.value;
  }
}