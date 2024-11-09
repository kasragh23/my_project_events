import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget horizontalGap({double? w}){
  return SizedBox(width: w ?? 10);
}

Widget smallHorizontal({double? w}){
  return SizedBox(width: w ?? 1.5,);
}

Widget verticalGap({double? h}){
  return SizedBox(height:h ?? 15);
}

void showSnackBar(String title){
  Get.showSnackbar(
    GetSnackBar(
      title: title,
      message: 'some error occurred',
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red.shade800,
    ),
  );
}

