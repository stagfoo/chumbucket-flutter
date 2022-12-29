import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Local
import 'ui.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(
          name: '/',
          page: () => const PageOne(),
          transition: Transition.fadeIn),
      GetPage(
          name: '/second',
          page: () => const PageTwo(),
          transition: Transition.fadeIn),
    ],
  ));
}



