import 'dart:io';

import 'package:chumbucketdart/actions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slugid/slugid.dart';
import 'package:short_uuids/short_uuids.dart';

var localDBFile = 'manabee-db.toml';

class Word {
  String id = const ShortUuid().generate();
  String eng = '';
  String furagana = '';
  String kanji = '';
  String meaning = '';
}

class Bubble {
  double x = 0;
  double y = 0;
  File filename = File('');
  String id = const ShortUuid().generate();
  String text = '';
  List<Word> words = [];
}

class MangaBook {
  String name = '';
  String cover = '';
  List<String> chapterDirs = [];
  List<Bubble> bubbles = [];
  List<Word> words = [];
  String lastChapterRead = '';
  String lastPageRead = '';
}

class GlobalState extends ChangeNotifier {
  int currentPageNumber = 0;
  //TODO rename book to currentBookFiles or something
  List<dynamic> book = [];
  MangaBook selectedBook = MangaBook();
  Word? selectedWord;
  List<MangaBook> bookList = [];
  String addBookCover = '';
  List<String> addBookChapters = [];
  List<Bubble> bubbleList = [];
  List<Bubble> currentPageBubbles = [];
  int selectedChapter = 0;

  void loadDefaultState(bookList, bubbleList) {
    bookList = bookList;
    bubbleList = bubbleList;
  }

  void loadMangaBook(files) {
    book = files;
    notifyListeners();
  }

  void selectMangaBook(MangaBook book) {
    selectedBook = book;
    notifyListeners();
  }

  void setSelectedChapter(int i) {
    selectedChapter = i;
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

  void setBookList(List<MangaBook> list) {
    bookList = list;
    notifyListeners();
  }

  void addMangaBook(MangaBook book) {
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
