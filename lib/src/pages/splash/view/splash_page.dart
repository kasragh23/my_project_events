import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controllers.dart';

class SplashPage extends GetView<SplashController>{
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.wait();
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.deepPurple,),
      ),
    );
  }

}