import 'package:get/get.dart';
import '../controller/splash_controllers.dart';

class SplashBinding extends Bindings{
  @override void dependencies() {
    Get.lazyPut(()=> SplashController());
  }
}