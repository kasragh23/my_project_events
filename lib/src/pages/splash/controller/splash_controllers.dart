import 'package:get/get.dart';
import 'package:my_project/my_project.dart';
import 'package:my_project/src/pages/splash/repositories/splash_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashController extends GetxController{
  String? username;
  RxBool isLoading = false.obs, isRetryMode = false.obs;
  SplashRepository repository = SplashRepository();


  @override
  void onInit() {
    super.onInit();
    checkServerStatus();
  }

  Future<void> checkServerStatus() async{
    isLoading.value = true;
    isRetryMode.value = false;
    final result = await repository.checkServerStatus();
    if(result){
      getUserCredentials();
    }else{
      isLoading.value = false;
      isRetryMode.value = true;
    }
  }

  Future<void> getUserCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username');
    if(username != null){
      final id = await repository.getUserId(username!);
      await Get.offAllNamed(RouteNames.allEvents , parameters: {'userId': id.toString()});
      isLoading.value = false;
    }
    await Get.offAllNamed(RouteNames.login);
    isLoading.value = false;
  }
}