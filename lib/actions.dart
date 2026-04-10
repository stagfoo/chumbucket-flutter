import 'dart:io';
import 'package:flutter/semantics.dart';
import 'package:short_uuids/short_uuids.dart';
import 'package:get/get.dart';
import 'package:toml/toml.dart';

import 'middleware.dart';
import 'store.dart';

Future<void> onPressMangaBookItem(GlobalState state, MangaBook item) async {
  state.selectMangaBook(item);
  Get.toNamed('/chapter-select');
}

Future<void> onPressSelectChapter(GlobalState state, String path) async {
  try {
    var chapter = state.selectedBook.chapterDirs.indexOf(path);
    print(path);
    print(chapter);
    state.setSelectedChapter(chapter);
    var files =
        await getFilesFromFolder(state.selectedBook.chapterDirs[chapter]);
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
    print(err);
    Get.toNamed('/home');
  }
}

Future<void> reloadBubbleList(GlobalState state) async {
  List<Bubble> selectedMangaBubbles = [];
  selectedMangaBubbles.addAll(state.bubbleList);
  selectedMangaBubbles.retainWhere((element) {
    return element.filename.path ==
        state.currentBookFiles[state.currentPageNumber].path;
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

void onPressCreateBubble(GlobalState state) {
  var nextBubble = Bubble();
  //Is this correct?
  nextBubble.filename = state.currentBookFiles[state.currentPageNumber];
  nextBubble.x = 100;
  nextBubble.y = 100;
  nextBubble.text = '';
  state.addBubble(nextBubble);
  reloadBubbleList(state);
}

Future<void> onWordTapped(GlobalState state, String word) async {
  final result = await searchWord(word);
  if (result.isNotEmpty) {
    final firstResult = result.first;
    final newWord = Word();
    newWord.eng = firstResult.senses.first.englishDefinitions.first;
    newWord.furagana = firstResult.japanese.first.reading;
    newWord.kanji = firstResult.japanese.first.word;
    newWord.tags = firstResult.tags;
    state.setSelectedWord(newWord);
  }
}

void onTapCreateBubble(GlobalState state, Offset eventDetails) {
  var nextBubble = Bubble();
  //Is this correct?
  nextBubble.filename = state.currentBookFiles[state.currentPageNumber];
  nextBubble.x = eventDetails.dx;
  nextBubble.y = eventDetails.dy;
  print(eventDetails);
  nextBubble.text = '';
  state.addBubble(nextBubble);
  reloadBubbleList(state);
}

void onDbTapDeleteBubble(GlobalState state, Bubble bubble) {
  List<Bubble> bubbleList = [];
  bubbleList.addAll(state.bubbleList);
  bubbleList.retainWhere((item) {
    return bubble.id.toString() != item.id.toString();
  });
  state.setBubbleList(bubbleList);
  reloadBubbleList(state);
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
}

