import 'dart:io';
import 'package:flutter/semantics.dart';
import 'package:short_uuids/short_uuids.dart';
import 'package:get/get.dart';
import 'package:toml/toml.dart';

import 'middleware.dart';
import 'store.dart';

Future<void> onPressMangaBookItem(GlobalState state, dynamic item) async {
  try {
    var chapterFileDir = item['chapterDirs'][0];
    var files = await getFilesFromFolder(chapterFileDir);
    if (files == []) {
      Get.toNamed('/home');
    } else {
      state.loadMangaBook(files);
      state.resetPage();
      reloadBubbleList(state);
      Get.toNamed('/reading');
    }
  } catch (err) {
    print("unable to load chapterDirs");
    Get.toNamed('/home');
  }
}

Future<void> reloadBubbleList(GlobalState state) async {
  List<Bubble> selectedMangaBubbles = [];
  selectedMangaBubbles.addAll(state.bubbleList);
  selectedMangaBubbles.retainWhere((element) {
    return element.filename.path == state.book[state.currentPageNumber].path;
  });
  state.setCurrentPageBubbles(selectedMangaBubbles);
}

Future<void> onPressNextPage(GlobalState state) async {
  state.nextPage();
  reloadBubbleList(state);
}

Future<void> onPressPrevPage(GlobalState state) async {
  state.prevPage();
  reloadBubbleList(state);
}

void onTapCreateBubble(GlobalState state, Offset eventDetails) {
  var nextBubble = Bubble();
  nextBubble.filename = state.book[state.currentPageNumber];
  nextBubble.x = eventDetails.dx;
  nextBubble.y = eventDetails.dy;
  print(eventDetails);
  nextBubble.text = '';
  state.addBubble(nextBubble);
  reloadBubbleList(state);
  saveDB(localDBFile, state);
}

void onDbTapDeleteBubble(GlobalState state, Bubble bubble) {
  List<Bubble> bubbleList = [];
  bubbleList.addAll(state.bubbleList);
  bubbleList.retainWhere((item) {
    return bubble.id.toString() != item.id.toString();
  });
  state.setBubbleList(bubbleList);
  reloadBubbleList(state);
  saveDB(localDBFile, state);
}

void onBubbleTextChange(GlobalState state, String value, Bubble bubble) {
  List<Bubble> bubbleList = [];
  bubbleList.addAll(state.bubbleList);
  bubbleList.retainWhere((item) {
    return bubble.id.toString() != item.id.toString();
  });
  bubble.text = value;
  bubbleList.add(bubble);
  state.setBubbleList(bubbleList);
  reloadBubbleList(state);
  saveDB(localDBFile, state);
}

Future<void> onPressAddCover(GlobalState state) async {
  var choosenFolder = await pickDir();
  var folder = choosenFolder.toString();
  state.addMangaBook({
    "cover": folder + '/cover.jpg',
    "folder": folder,
    "chapterDirs": [folder]
  });
}

saveDB(String name, GlobalState state) async {
  Map<String, dynamic> tomlTemplate = {'bookList': {}, 'bubbles': {}};
  //TODO convert for loops
  state.bookList.forEach((item) {
    tomlTemplate['bookList'][const ShortUuid().generate().toString()] = {
      'cover': item['folder'] + '/cover.jpg',
      'folder': item['folder'],
      'chapterDirs': item['chapterDirs'],
    };
  });
  state.bubbleList.forEach((item) {
    tomlTemplate['bubbles'][item.id.toString()] = {
      'x': item.x,
      'y': item.y,
      'filename': item.filename.path,
      'id': item.id,
      'text': item.text,
    };
  });
  var bookList = TomlDocument.fromMap(tomlTemplate).toString();
  var file = File(localDBFile);
  file.writeAsString(bookList.toString());
}

loadDB(String name) async {
  //load toml
  var document = await TomlDocument.load(name);
  var documemnts = TomlDocument.parse(document.toString()).toMap();
  return documemnts;
}

void loadConfig(GlobalState state) async {
  if (await File(localDBFile).exists()) {
    var fromDBState = await loadDB(localDBFile);
    List<Bubble> nextBubbles = [];
    var nextBookList = [];
    Map.from(fromDBState['bubbles']).forEach((key, value) {
      var newBubble = Bubble();
      newBubble.filename = File(value['filename']);
      newBubble.x = value['x'];
      newBubble.y = value['y'];
      newBubble.text = value['text'];
      newBubble.id = key;
      nextBubbles.add(newBubble);
    });
    Map.from(fromDBState['bookList']).forEach((key, value) {
      nextBookList.add(value);
    });
    state.setBubbleList(nextBubbles);
    state.setBookList(nextBookList);
  } else {
    File(localDBFile).writeAsString('');
  }
}

void bottomBarAddBook(GlobalState state) async {
  try {
    var files = await getFiles();
    state.loadMangaBook(files);
    state.resetPage();
    Get.toNamed('/reading');
    var firstImage = files[0] as File;
    var folder = firstImage.parent.parent.path.toString();
    state.addMangaBook({
      "cover": folder,
      "folder": folder,
      "chapterDirs": [folder]
    });
    saveDB(localDBFile, state);
  } catch (err) {
    print("File open canceled");
    Get.toNamed('/home');
  }
}
