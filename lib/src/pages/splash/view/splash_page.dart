import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/generated/locales.g.dart';
import '../controller/splash_controllers.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          } else if (controller.isRetryMode.value) {
            return ElevatedButton(
              onPressed: controller.checkServerStatus,
              child: Text(LocaleKeys.localization_app_retry.tr),
            );
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
