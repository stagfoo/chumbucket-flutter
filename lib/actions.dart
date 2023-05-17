import 'dart:io';
import 'package:flutter/semantics.dart';
import 'package:short_uuids/short_uuids.dart';
import 'package:get/get.dart';
import 'package:toml/toml.dart';

import 'middleware.dart';
import 'store.dart';

Future<void> onPressMangaBookItem(GlobalState state, MangaBook item) async {
  try {
    state.selectMangaBook(item);
    Get.toNamed('/chapter-select');
    // var chapterFileDir = item['chapterDirs'][0];
    // var files = await getFilesFromFolder(chapterFileDir);
    // if (files == []) {
    //   Get.toNamed('/home');
    // } else {
    //   state.loadMangaBook(files);
    //   state.resetPage();
    //   reloadBubbleList(state);
    //   Get.toNamed('/reading');
    // }
  } catch (err) {
    print("unable to load chapterDirs");
    print(err);
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
  var chooseFile = await pickFile();
  state.setNewBookCover(chooseFile.path.toString());
}

Future<void> onPressAddFolders(GlobalState state) async {
  var choosenFolder = await pickDir();
  var folder = choosenFolder.toString();
  state.addNewBookChapters(folder);
}

Future<void> onPressSaveNewBook(GlobalState state) async {
  var newBook = MangaBook();
  newBook.cover = state.addBookCover;
  newBook.chapterDirs = state.addBookChapters;
  state.addMangaBook(newBook);
  state.resetAddNewBook();
  Get.toNamed('/home');
  saveDB(localDBFile, state);
}

saveDB(String name, GlobalState state) async {
  Map<String, dynamic> tomlTemplate = {'bookList': {}, 'bubbles': {}};
  //TODO convert for loops
  state.bookList.forEach((item) {
    tomlTemplate['bookList'][const ShortUuid().generate().toString()] = {
      'cover': item.cover,
      'folder': File(item.cover).parent.path.toString(),
      'chapterDirs': item.chapterDirs,
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
    List<MangaBook> nextBookList = [];
    Map.from(fromDBState['bubbles']).forEach((key, value) {
      var newBubble = Bubble();
      newBubble.filename = File(value['filename']);
      newBubble.x = value['x'];
      newBubble.y = value['y'];
      newBubble.text = value['text'];
      newBubble.id = key;
      nextBubbles.add(newBubble);
    });
    try {
      Map.from(fromDBState['bookList']).forEach((key, value) {
        var book = MangaBook();
        book.cover = value['cover'];
        book.chapterDirs = List<String>.from(value['chapterDirs'] as List);
        nextBookList.add(book);
      });
      state.setBubbleList(nextBubbles);
      state.setBookList(nextBookList);
    } catch (err) {
      print(err);
    }
  } else {
    File(localDBFile).writeAsString('');
  }
}
