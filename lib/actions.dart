import 'dart:io';
import 'package:dart_pg/dart_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:toml/toml.dart';

import 'store.dart';

Future<void> navigateToPage(GlobalState state, String page, int navbarIndex) async {
  print(page);
  switch (page) {
    case 'keys':
      Get.toNamed('/keys');
      break;
    case 'decrypt':
      if(state.keyring.length == 1) {
        state.selectPublicKey(state.keyring[0].id.toString());
        state.selectPrivateKey(state.keyring[0].id.toString());
      }
      Get.toNamed('/decrypt');
      break;
    case 'new-key':
      Get.toNamed('/new-key');
      break;
    default:
      if(state.keyring.length == 1) {
        state.selectPublicKey(state.keyring[0].id.toString());
        state.selectPrivateKey(state.keyring[0].id.toString());
      }
      Get.toNamed('/');
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
  print(key);
}

Future<void> handleAddTextToEncrypt(GlobalState state, String text) async {
  state.setTextToEncrypt(text);
}

Future<void> handleAddTextToDecrypt(GlobalState state, String text) async {
  state.setTextToDecrypt(text);
}

Future<PGPKey> getKeyFromKeyring(GlobalState state) async {
  return state.keyring.firstWhere((element) => element.id.toString() == state.selectedPublicKey);
}
 

Future<void> handleEncryptMessage(GlobalState state) async {
  var text = Message.createTextMessage(state.textToEncrypt);
  var key = state.keyring.firstWhere((element) => element.id.toString() == state.selectedPublicKey);
  final encryptedMessage = await OpenPGP.encrypt(
    text, passwords: ['test']
  );
  print(text);
  print(key.publicKey.toString());
  print(encryptedMessage.armor());
}

Future<void> handleDecryptMessage(GlobalState state) async {
  var key = await getKeyFromKeyring(state);
  var text = Message.createTextMessage(state.textToDecrypt);
  const password = 'test';
  final armoredPublicKeys = [key.publicKey.armor()];
  final armoredPrivateKey = key.privateKey.armor();

  final publicKeys = await Future.wait(
    armoredPublicKeys.map((armored) => OpenPGP.readPublicKey(armored)),
  );
  final privateKey = await OpenPGP.decryptPrivateKey(armoredPrivateKey, password);

  final encryptedMessage = await OpenPGP.encrypt(
    text,
    encryptionKeys: publicKeys,
    signingKeys: [privateKey],
  );
  final encrypted = encryptedMessage.armor();
  print(encrypted);
}

Future<void> handleUpdateNewKeyDetails(GlobalState state,  String key, String text) async {
  state.updateNewKeyDetails(key, text);
  //clear add new key text field
  //Go to add new key page
}
Future<void> handleOnPressAddNewKey(GlobalState state) async {
  final passphrase = state.newKeyPassword;
  print(state.newKeyEmail);
  final userID = [state.newKeyName, '($state.newKeyName)','<$state.newKeyEmail>'].join(' ');
  final privateKey = await OpenPGP.generateKey(
      [userID],
      passphrase,
      type: KeyGenerationType.rsa,
      rsaKeySize: RSAKeySize.s4096,
  );
  final publicKey = privateKey.toPublic;
  state.addNewKey(state.newKeyName, publicKey, privateKey, state.newKeyEmail);
  navigateToPage(state, 'keys', 2);
  //clear add new key text field
  //Go to add new key page
}

Future<void> handleSelectKeyAsListItem(GlobalState state, String text) async {
  //clear add new key text field
  //Go to add new key page
}


