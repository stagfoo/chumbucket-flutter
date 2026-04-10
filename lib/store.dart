import 'dart:io';

import 'package:chumbucketdart/actions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slugid/slugid.dart';
import 'package:short_uuids/short_uuids.dart';
import 'data_service.dart';

var localDBFile = 'manabee-db.toml';

class Word {
  String id = const ShortUuid().generate();
  String eng = '';
  String furagana = '';
  String kanji = '';
  String meaning = '';
  List<String> tags = [];
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
  String id = const ShortUuid().generate();
  String name = '';
  String cover = '';
  List<String> chapterDirs = [];
  List<Bubble> bubbles = [];
  List<Word> words = [];
  String lastChapterRead = '';
  String lastPageRead = '';
}

class GlobalState extends ChangeNotifier {
  final DataService _dataService = DataService();
  int currentPageNumber = 0;
  List<File> currentBookFiles = [];
  MangaBook selectedBook = MangaBook();
  Word? selectedWord;
  List<MangaBook> bookList = [];
  String addBookCover = '';
  List<String> addBookChapters = [];
  List<Bubble> bubbleList = [];
  List<Bubble> currentPageBubbles = [];
  int selectedChapter = 0;

  GlobalState() {
    loadState();
  }

  Future<void> loadState() async {
    final state = await _dataService.loadState();
    bookList = state.bookList;
    bubbleList = state.bubbleList;
    notifyListeners();
  }

  Future<void> _saveState() async {
    await _dataService.saveState(this);
  }

  void loadMangaBook(List<File> files) {
    currentBookFiles = files;
    notifyListeners();
    _saveState();
  }

  void selectMangaBook(MangaBook book) {
    selectedBook = book;
    notifyListeners();
    _saveState();
  }

  void setSelectedChapter(int i) {
    selectedChapter = i;
    notifyListeners();
  }

  void setNewBookCover(file) {
    addBookCover = file;
    notifyListeners();
    _saveState();
  }

  void addNewBookChapters(folder) {
    addBookChapters.add(folder);
    notifyListeners();
    _saveState();
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
    _saveState();
  }

  void setBookList(List<MangaBook> list) {
    bookList = list;
    notifyListeners();
    _saveState();
  }

  void addMangaBook(MangaBook book) {
    bookList.add(book);
    notifyListeners();
    _saveState();
  }

  void addBubble(bubble) {
    bubbleList.add(bubble);
    notifyListeners();
    _saveState();
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

  void setSelectedWord(Word word) {
    selectedWord = word;
    notifyListeners();
  }
}
