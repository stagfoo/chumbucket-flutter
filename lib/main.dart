import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Local
import 'ui.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    theme: ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.pink[800],

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    ),
    getPages: [
      GetPage(
          name: '/',
          page: () => const HomePage(),
          transition: Transition.fadeIn),
      GetPage(
          name: '/goals',
          page: () => const GoalsPage(),
          transition: Transition.fadeIn),
      GetPage(
          name: '/collections',
          page: () => const CollectionsPage(),
          transition: Transition.fadeIn),
      GetPage(
          name: '/add-marker',
          page: () => const AddMarkerPage(),
          transition: Transition.fadeIn),
    ],
  ));
}
