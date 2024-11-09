import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/my_project.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('en','US'),
    translationsKeys: LocalizationService.keys,
    initialRoute: RouteNames.splash,
    getPages: RoutePages.pages,
  );
}
