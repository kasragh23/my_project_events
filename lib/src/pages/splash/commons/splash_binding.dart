import 'package:get/get.dart';
import 'package:my_project/src/pages/splash/controller/splash_controllers.dart';

class SplashBinding extends Bindings{
  @override void dependencies() {
    Get.lazyPut(()=> SplashController());
  }
}