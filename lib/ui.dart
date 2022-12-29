//Libs
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Local
import 'store.dart';

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
    ),
    );
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