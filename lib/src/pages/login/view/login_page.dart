import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/generated/locales.g.dart';

import '../../../infrastructure/utils/utils.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  double pageWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  double responsiveWidth(BuildContext context) {
    if (pageWidth(context) > 700) {
      return 700;
    }
    return double.infinity;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: Center(
          child: SizedBox(
            width: responsiveWidth(context),
            child: _body(),
          ),
        ),
      );

  AppBar _appBar() {
    return AppBar(
      title: Text(LocaleKeys.localization_app_login.tr),
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
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.localization_app_login_credentials.tr,
            style: const TextStyle(fontSize: 18),
          ),
          verticalGap(),
          Center(
            child: Form(key: controller.formKey, child: _formFields()),
          ),
        ],
      ),
    );
  }

  Widget _formFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
            validator: controller.validator,
            controller: controller.password,
            obscureText: !controller.visible.value,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
              ),
            ),
          ),
        ),

        verticalGap(),
        //TODO: I should've implement the 'remember me' checkbox about here
        Row(
          children: [
            Obx(() => Checkbox(
                value: controller.rememberMe.value,
                onChanged: (bool? value) {
                  controller.rememberMe.value = value!;
                })),
            Text(LocaleKeys.localization_app_remember_me.tr),
          ],
        ),
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
            onPressed: controller.login,
            child: Text(LocaleKeys.localization_app_login.tr),
          ),
        ),
        verticalGap(),
        _createAccount(),
      ],
    );
  }

  Widget _createAccount() {
    return RichText(
      text: TextSpan(
          text: LocaleKeys.localization_app_dont_have_acc.tr,
          style: TextStyle(color: Colors.grey.shade600),
          children: <TextSpan>[
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = (controller.register),
              text: LocaleKeys.localization_app_create_one.tr,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ]),
    );
  }
}
