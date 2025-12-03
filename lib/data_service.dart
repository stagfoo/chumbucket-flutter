import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:toml/toml.dart';
import 'store.dart';

class DataService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/manabee-db.toml');
  }

  Future<GlobalState> loadState() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final doc = TomlDocument.parse(contents);
      final state = GlobalState();
      final bookList = doc.toMap()['bookList'] as Map<String, dynamic>? ?? {};
      final bubbles = doc.toMap()['bubbles'] as Map<String, dynamic>? ?? {};

      state.bookList = bookList.entries.map((entry) {
        final bookData = entry.value as Map<String, dynamic>;
        final book = MangaBook();
        book.id = entry.key;
        book.name = bookData['name'];
        book.cover = bookData['cover'];
        book.chapterDirs = List<String>.from(bookData['chapterDirs']);
        book.words = (bookData['words'] as List<dynamic>? ?? []).map((wordData) {
          final word = Word();
          word.id = wordData['id'];
          word.eng = wordData['eng'];
          word.furagana = wordData['furagana'];
          word.kanji = wordData['kanji'];
          word.meaning = wordData['meaning'];
          return word;
        }).toList();
        return book;
      }).toList();

      state.bubbleList = bubbles.entries.map((entry) {
        final bubbleData = entry.value as Map<String, dynamic>;
        final bubble = Bubble();
        bubble.id = bubbleData['id'];
        bubble.x = bubbleData['x'];
        bubble.y = bubbleData['y'];
        bubble.filename = File(bubbleData['filename']);
        bubble.text = bubbleData['text'];
        return bubble;
      }).toList();

      return state;
    } catch (e) {
      // If the file doesn't exist or there's an error, return a default state
      return GlobalState();
    }
  }

  Future<File> saveState(GlobalState state) async {
    final file = await _localFile;
    final bookList = {
      for (var book in state.bookList)
        book.id: {
          'name': book.name,
          'cover': book.cover,
          'folder': book.chapterDirs.isNotEmpty
              ? p.dirname(book.chapterDirs.first)
              : '',
          'chapterDirs': book.chapterDirs,
          'words': book.words
              .map((word) => {
                    'id': word.id,
                    'eng': word.eng,
                    'furagana': word.furagana,
                    'kanji': word.kanji,
                    'meaning': word.meaning,
                  })
              .toList(),
        }
    };
    final bubbles = {
      for (var bubble in state.bubbleList)
        bubble.id: {
          'x': bubble.x,
          'y': bubble.y,
          'filename': bubble.filename.path,
          'id': bubble.id,
          'text': bubble.text,
        }
    };
    final toml = TomlDocument.fromMap({'bookList': bookList, 'bubbles': bubbles});
    return file.writeAsString(toml.toString());
  }
}
