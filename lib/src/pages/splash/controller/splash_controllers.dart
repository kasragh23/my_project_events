import 'package:get/get.dart';

import '../../../infrastructure/routes/route_paths.dart';

class SplashController extends GetxController{
  void wait() async =>
      await Future.delayed(
        const Duration(seconds: 3),
            () async {
          print("reach login");
          await Get.offAllNamed(RoutePaths.login);
        },
      );
}