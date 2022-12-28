import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(
          name: '/',
          page: () => PageOne(),
          transition: Transition.noTransition),
      GetPage(
          name: '/second',
          page: () => PageTwo(),
          transition: Transition.noTransition),
    ],
  ));
}

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: const Text('Page one'),
      onPressed: () {
        Get.toNamed("/second");
      },
    ));
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: GetBuilder<GlobalState>(
          init: GlobalState(),
          builder: (_) => Text(
            '${_.counter}',
          ),
        ),
        onPressed: () {
          GlobalState.to.increment();
        },
      ),
    );
  }
}

class GlobalState extends GetxController {
  static GlobalState get to => Get.find();

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
