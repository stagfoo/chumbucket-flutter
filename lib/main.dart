import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:io';

//Local
import 'ui.dart';
import 'store.dart';

void main() {
  runApp(ChangeNotifierProvider(
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      enableLog: true,
      themeMode: ThemeMode.dark,
      getPages: [
        GetPage(
            name: '/', page: () => HomePage(), transition: Transition.fadeIn),
        GetPage(
            name: '/reading',
            page: () =>
                Consumer<GlobalState>(builder: (context, state, widget) {
                  return MangaBookPage(state: state);
                }),
            transition: Transition.fadeIn),
        GetPage(
            name: '/tags',
            page: () =>
                Consumer<GlobalState>(builder: (context, state, widget) {
                  return TagPage(state: state);
                }),
            transition: Transition.fadeIn),
        GetPage(
            name: '/import',
            page: () =>
                Consumer<GlobalState>(builder: (context, state, widget) {
                  return AddMangaBookPage(state: state);
                }),
            transition: Transition.fadeIn),
      ],
    ),
    create: (context) => GlobalState(),
  ));
}
