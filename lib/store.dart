import 'package:flutter/material.dart';
import 'package:slugid/slugid.dart';

var localDBFile = 'database.toml';

//TODO how can i set this like a function?
class PGPKey {
  String name = '';
  String publicKey = '';
  String privateKey = '';
  Slugid id = Slugid.nice();
  String createdAt = '';
  String updatedAt = '';
  String deletedAt = '';
}

PGPKey createFakeKey(String name, String pub, String priv) {
  var newKey = PGPKey();
  newKey.name = name;
  newKey.publicKey = pub;
  newKey.privateKey = priv;
  return newKey;
}

class PGPKeyPair {
  String publicKey = '';
  String privateKey = '';
}

class GlobalState extends ChangeNotifier {
  int currentNavbarIndex = 0;
  List<String> bucket = [];
  List<PGPKey> keyring = [
    createFakeKey("yo@stagfoo.com", "pubkey1", "privkey1"),
    createFakeKey("basal@basal.dev" , "pubkey", "privkey"),
  ];
  String textToEncrypt = '';
  String textToDecrypt = '';
  String selectedPublicKey = 'pubkey1';
  String selectedPrivateKey = 'pubkey1';
  late PGPKey selectedPGPKey = keyring[0];
  late PGPKey newKey;

  void addNewKey(String name, String pub, String priv) {
    var newKey = PGPKey();
    newKey.name = name;
    newKey.publicKey = pub;
    newKey.privateKey = priv;
    newKey.privateKey = priv;
    newKey.createdAt = DateTime.now().toString();
    newKey.updatedAt = DateTime.now().toString();
    newKey.deletedAt = '';
    keyring.add(newKey);
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
