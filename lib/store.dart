import 'dart:io';

import 'package:chumbucketdart/actions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slugid/slugid.dart';
import 'package:short_uuids/short_uuids.dart';

var localDBFile = 'manabee-db.toml';

class Bubble {
  double x = 0;
  double y = 0;
  File filename = File('');
  String id = const ShortUuid().generate();
  String text = '';
}

class MangaBook {
  File cover = File('');
  List<String> chapterDirs = [];
  List<Bubble> bubbles = [];
  int lastChapterRead = 0;
  int lastPageRead = 0;
}

class GlobalState extends ChangeNotifier {
  int currentPageNumber = 0;
  List book = [];
  List bookList = [];
  String addBookCover = '';
  List<String> addBookChapters = [];
  List<Bubble> bubbleList = [];
  List<Bubble> currentPageBubbles = [];

  void loadDefaultState(bookList, bubbleList) {
    bookList = bookList;
    bubbleList = bubbleList;
  }

  void loadMangaBook(files) {
    book = files;
    notifyListeners();
  }

  void setNewBookCover(file) {
    addBookCover = file;
    notifyListeners();
  }

  void addNewBookChapters(folder) {
    addBookChapters.add(folder);
    notifyListeners();
  }

  void resetAddNewBook() {
    addBookChapters = [];
    addBookCover = '';
    //Don't notify because no rerender is needed?
  }

  void setCurrentPageBubbles(bubbles) {
    currentPageBubbles = bubbles;
    notifyListeners();
  }

  void setBubbleList(List<Bubble> bubbles) {
    bubbleList = bubbles;
    notifyListeners();
  }

  void setBookList(list) {
    bookList = list;
    notifyListeners();
  }

  void addMangaBook(book) {
    bookList.add(book);
    notifyListeners();
  }

  void addBubble(bubble) {
    bubbleList.add(bubble);
    notifyListeners();
  }

  void resetPage() {
    currentPageNumber = 0;
    notifyListeners();
  }

  void nextPage() {
    currentPageNumber++;
    notifyListeners();
  }

  void prevPage() {
    currentPageNumber--;
    notifyListeners();
  }
}
