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
          actions: [
            TextButton(
                onPressed: () => Get.updateLocale(const Locale('en', 'US')),
                child: Text(
                  LocaleKeys.localization_app_change_language_to_english.tr,
                  style: const TextStyle(color: Colors.white),
                )),
            TextButton(
              onPressed: () => Get.updateLocale(const Locale('fa', 'IR')),
              child: Text(
                LocaleKeys.localization_app_change_language_to_persian.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: SizedBox(
              width: responsiveWidth(context),
              child: _body(),
            ),
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
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: controller.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller.firstName,
          decoration: InputDecoration(
            labelText: LocaleKeys.localization_app_first_name.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        verticalGap(),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: controller.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller.lastName,
          decoration: InputDecoration(
            labelText: LocaleKeys.localization_app_last_name.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        verticalGap(),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: controller.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller.username,
          decoration: InputDecoration(
            labelText: LocaleKeys.localization_app_username.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        verticalGap(),
        Obx(
          () => TextFormField(
            textInputAction: TextInputAction.next,
            validator: controller.passValidator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.password,
            obscureText: !controller.visible1.value,
            decoration: InputDecoration(
              labelText: LocaleKeys.localization_app_password.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: InkWell(
                onTap: controller.toggleVisibility1,
                child: controller.visible1.value
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              ),
            ),
          ),
        ),
        verticalGap(),
        Obx(
          () => TextFormField(
            textInputAction: TextInputAction.next,
            validator: controller.passValidator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.confirmPass,
            obscureText: !controller.visible2.value,
            decoration: InputDecoration(
              labelText: LocaleKeys.localization_app_confirm_password.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: InkWell(
                onTap: controller.toggleVisibility2,
                child: controller.visible2.value
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              ),
            ),
          ),
        ),
        verticalGap(),
        _genderRadio(),
        verticalGap(),
        Obx(
          () => controller.isLoading.value
              ? ElevatedButton(
                  onPressed: null,
                  child: Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : ElevatedButton(
                  onPressed: controller.register,
                  child: Text(LocaleKeys.localization_app_register.tr),
                ),
        )
      ],
    );
  }

  Widget _genderRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => Radio<String>(
              value: LocaleKeys.localization_app_male.tr,
              groupValue: controller.selectedGender.value,
              onChanged: (value) {
                controller.selectedGender.value = value!;
              }),
        ),
        Text(LocaleKeys.localization_app_male.tr),
        Obx(
          () => Radio<String>(
              value: LocaleKeys.localization_app_female.tr,
              groupValue: controller.selectedGender.value,
              onChanged: (value) {
                controller.selectedGender.value = value!;
              }),
        ),
        Text(LocaleKeys.localization_app_female.tr),
        Obx(
          () => Text(controller.passError.value,
              style: const TextStyle(color: Colors.red)),
        )
      ],
    );
  }
}
