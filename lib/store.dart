import 'package:get/get.dart';

class GlobalState extends GetxController {
  static GlobalState get to => Get.find();

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
