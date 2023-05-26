import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

//Local
import 'ui.dart';
import 'store.dart';

void main() {
  runApp(ChangeNotifierProvider(
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      enableLog: true,
      theme: ThemeData.dark(),
      getPages: [
        GetPage(
            name: '/',
            page: () =>
                Consumer<GlobalState>(builder: (context, state, widget) {
                  return HomePage(state: state);
                }),
            transition: Transition.fadeIn),
        GetPage(
            name: '/decrypt',
            page: () =>
                Consumer<GlobalState>(builder: (context, state, widget) {
                  return DecryptPage(state: state);
                }),
            transition: Transition.fadeIn),
        GetPage(
            name: '/keys',
            page: () =>
                Consumer<GlobalState>(builder: (context, state, widget) {
                  return KeysPage(state: state);
                }),
            transition: Transition.fadeIn),
        GetPage(
            name: '/new-key',
            page: () =>
                Consumer<GlobalState>(builder: (context, state, widget) {
                  return NewKeyPage(state: state);
                }),
            transition: Transition.fadeIn),
      ],
    ),
    create: (context) => GlobalState(),
  ));
}
