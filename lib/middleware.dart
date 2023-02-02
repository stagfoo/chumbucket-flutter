import 'package:file_picker/file_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'dart:io';

//return type   // name   // async
Future<String?> pickDir() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory == null) {
    return '';
  }
  return selectedDirectory;
}

Future<List<Directory>> getDirs() async {
  var root = await FilePicker.platform.getDirectoryPath();
  if (root == null) {
    return [];
  }
  var fm = FileManager(root: Directory(root)); //
  var dirs = await fm.dirsTree();
  return dirs;
}


Future<List<File>> getFiles() async {
  var root = await FilePicker.platform.getDirectoryPath();
  if (root == null) {
    return [];
  }
  var fm = FileManager(root: Directory(root)); //
  var files = await fm.filesTree(extensions: [
    "png",
    "jpg",
    "jpeg"
  ]);
  return files;
}
Future<List<File>> getFilesFromFolder(String root) async {
  var fm = FileManager(root: Directory(root)); //
  var files = await fm.filesTree(extensions: [
    "png",
    "jpg",
    "jpeg"
  ]);
  return files;
}
