import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:toml/toml.dart';

import 'store.dart';

Future<void> handleButtonClick(GlobalState state) async {
  state.addMeatToBucket('🍖');
}

Future<void> navigateToPage(GlobalState state, String page, int navbarIndex, BuildContext context) async {
  print(page);
  switch (page) {
    case 'keys':
      Get.toNamed('/keys');
      break;
    case 'decrypt':
      Get.toNamed('/decrypt');
      break;
    default:
      Get.toNamed('/');
      state.setBucket([]);
  }
  state.saveNavbarIndex(navbarIndex);
}


saveToml(String name, GlobalState state) async {
  Map<String, dynamic> tomlTemplate = {'bucket': state.bucket};
  var tomlDB = TomlDocument.fromMap(tomlTemplate).toString();
  var file = File(localDBFile);
  file.writeAsString(tomlDB.toString());
}

loadToml(String name) async {
  //load toml
  var document = await TomlDocument.load(name);
  var documemnts = TomlDocument.parse(document.toString()).toMap();
  return documemnts;
}

Future<void> handleSelectKey(GlobalState state, String key) async {
  state.selectPublicKey(key);
}

Future<void> handleAddTextToEncrypt(GlobalState state, String text) async {
  state.setTextToEncrypt(text);
}

Future<void> handleAddTextToDecrypt(GlobalState state, String text) async {
  state.setTextToDecrypt(text);
}

Future<void> handleOnPressAddNewKey(GlobalState state, String text) async {
  //clear add new key text field
  //Go to add new key page
}

Future<void> handleSelectKeyAsListItem(GlobalState state, String text) async {
  //clear add new key text field
  //Go to add new key page
}
