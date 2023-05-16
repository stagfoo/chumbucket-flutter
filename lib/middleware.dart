import 'package:file_picker/file_picker.dart';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:file_manager/file_manager.dart';
import 'dart:io';

//return type   // name   // async
Future<String?> pickDir() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory == null) {
    return '';
  }
  return selectedDirectory;
}

Future<List> getDirs() async {
  var root = await FilePicker.platform.getDirectoryPath();
  if (root == null) {
    return [];
  }
  var list = [];
  List contents = Directory(root).listSync();
  for (var fileOrDir in contents) {
    if (fileOrDir is Directory) {
      list.add(fileOrDir);
    }
  }
  return list;
}

Future<List> getFiles() async {
  var root = await FilePicker.platform.getDirectoryPath();
  if (root == null) {
    return [];
  }
  var list = [];
  List contents = Directory(root).listSync();
  for (var fileOrDir in contents) {
    if (fileOrDir is File) {
      //TODO filter by extension
      list.add(fileOrDir);
    }
  }
  return list;
}

Future<List> getFilesFromFolder(String root) async {
  var list = [];
  List contents = Directory(root).listSync();
  for (var fileOrDir in contents) {
    if (fileOrDir is File) {
      //TODO filter by extension
      list.add(fileOrDir);
    }
  }
  return list;
}
