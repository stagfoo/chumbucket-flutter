import 'dart:io';

import 'package:chumbucketdart/actions.dart';
import 'package:flutter/material.dart';
import 'package:slugid/slugid.dart';
import 'package:short_uuids/short_uuids.dart';

var localDBFile = 'database.toml';

class PGPKey {
  String name = '';
  String publicKey = '';
  String privateKey = '';
  Slugid id = Slugid.nice();
  String createdAt = '';
  String updatedAt = '';
  String deletedAt = '';
}


class GlobalState extends ChangeNotifier {
  int currentNavbarIndex = 0;
  List<String> bucket = [];
  List<PGPKey> keyring = [];
  String textToEncrypt = '';
  String textToDecrypt = '';
  String selectedPublicKey = '';
  String selectedPrivateKey = '';


  void addMeatToBucket(String emojiText) {
    bucket.add(emojiText);
    notifyListeners();
  }
  void setBucket(List<String> value) {
    bucket = value;
    notifyListeners();
  }

  void saveNavbarIndex(int value) {
    currentNavbarIndex = value;
    notifyListeners();
  }
  void selectPublicKey(String key) {
    selectedPublicKey = key;
    notifyListeners();
  }
  void setTextToEncrypt(String text) {
    textToEncrypt = text;
    notifyListeners();
  }
  void setTextToDecrypt(String text) {
    textToDecrypt = text;
    notifyListeners();
  }
}
