import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/utils/utils.dart';
import '../controllers/register_controller.dart';
import '/generated/locales.g.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  double pageWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  double responsiveWidth(BuildContext context) {
    if (pageWidth(context) > 700) {
      return 700;
    }
    return double.infinity;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.localization_app_register.tr),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: SizedBox(
            width: responsiveWidth(context),
            child: _body(),
          ),
        ),
      );

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(
            LocaleKeys.localization_app_account_credentials.tr,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          verticalGap(),
          Center(
            child: Form(
              key: controller.formKey,
              child: _formFields(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: controller.firstName,
          decoration: InputDecoration(
            labelText: LocaleKeys.localization_app_first_name.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        verticalGap(),
        TextField(
          controller: controller.lastName,
          decoration: InputDecoration(
            labelText: LocaleKeys.localization_app_last_name.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        verticalGap(),
        TextField(
          controller: controller.username,
          decoration: InputDecoration(
            labelText: LocaleKeys.localization_app_username.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        verticalGap(),
        TextField(
          controller: controller.password,
          obscureText: !controller.visible.value,
          decoration: InputDecoration(
              labelText: LocaleKeys.localization_app_password.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: InkWell(
                onTap: controller.toggleVisibility,
                child: controller.visible.value
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )),
        ),
        verticalGap(),
        TextField(
          controller: controller.confirmPass,
          obscureText: !controller.visible.value,
          decoration: InputDecoration(
              labelText: LocaleKeys.localization_app_confirm_password.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: InkWell(
                onTap: controller.toggleVisibility,
                child: controller.visible.value
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )),
        ),
        verticalGap(),
        _genderRadio(),
        verticalGap(),
        ElevatedButton(
          onPressed: controller.register,
          child: const Text('Register'),
        )
      ],
    );
  }

  Widget _genderRadio() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Obx(() => Radio<String>(
          value: 'Male',
          groupValue: controller.selectedGender.value,
          onChanged: (value) {
            controller.selectedGender.value = value!;
          })),
      const Text('Male'),
      Obx(() => Radio<String>(
          value: 'Female',
          groupValue: controller.selectedGender.value,
          onChanged: (value) {
            controller.selectedGender.value = value!;
          })),
      const Text('Female'),
      Obx(() => Text(controller.passError.value,
          style: const TextStyle(color: Colors.red)))
    ]);
  }
}
