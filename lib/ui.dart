//Libs
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';
import 'package:widget_zoom/widget_zoom.dart';
// import 'package:webview_flutter/webview_flutter.dart';

//Local
import 'actions.dart';
import 'store.dart';
import 'middleware.dart';

//------------------------PAGE----------------------------

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("manabee"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings action
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      body: Consumer<GlobalState>(builder: (context, state, widget) {
        return MangaListView(state: state);
      }),
    );
  }
}

class FlashCardsPage extends StatefulWidget {
  final GlobalState state;
  const FlashCardsPage({Key? key, required this.state}) : super(key: key);

  @override
  _FlashCardsPageState createState() => _FlashCardsPageState();
}

class _FlashCardsPageState extends State<FlashCardsPage> {
  bool _isFlipped = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Assuming flashcards are stored in the global state
    final flashCards = widget.state.bookList.expand((book) => book.words).toList();

    if (flashCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("manabee"),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            "No flashcards available.",
            style: TextStyle(color: Colors.white),
          ),
        ),
        bottomNavigationBar: BottomBar(state: widget.state),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("manabee"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProgressIndicator(flashCards.length),
            const SizedBox(height: 24),
            Expanded(
              child: _buildFlashCard(flashCards[_currentIndex]),
            ),
            const SizedBox(height: 24),
            _buildReviewActions(flashCards.length),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(state: widget.state),
    );
  }

  Widget _buildProgressIndicator(int totalCards) {
    // TODO: Implement actual progress tracking
    return Column(
      children: [
        const Text("FLASH CARDS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text("0 👍 / 0 👎", style: const TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        Text("${_currentIndex + 1} / $totalCards", style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildFlashCard(Word card) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlipped = !_isFlipped;
        });
      },
      child: _isFlipped ? _buildCardBack(card) : _buildCardFront(card),
    );
  }

  Widget _buildCardFront(Word card) {
    return Card(
      color: Colors.purple,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(card.kanji, style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            Text(card.furagana, style: const TextStyle(color: Colors.white, fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(Word card) {
    return DictionaryCard(word: card);
  }

  Widget _buildReviewActions(int totalCards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.thumb_down, color: Colors.white, size: 48),
          onPressed: () {
            // TODO: Implement review logic
            setState(() {
              _isFlipped = false;
              _currentIndex = (_currentIndex + 1) % totalCards;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.thumb_up, color: Colors.white, size: 48),
          onPressed: () {
            // TODO: Implement review logic
            setState(() {
              _isFlipped = false;
              _currentIndex = (_currentIndex + 1) % totalCards;
            });
          },
        ),
      ],
    );
  }
}

class TagPage extends StatelessWidget {
  final GlobalState state;
  const TagPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement actual search functionality
    final searchResult = Word();
    searchResult.eng = "that";
    searchResult.furagana = "これ";
    searchResult.kanji = "-";


    return Scaffold(
      appBar: AppBar(
        title: const Text("manabee"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // This assumes that the `GlobalState` has a `selectedBook` with a list of words.
            // You might need to adjust this based on your actual state structure.
            if (state.selectedBook != null)
              _buildBookWordsSection(context, state.selectedBook.name, state.selectedBook.words),
            const SizedBox(height: 24),
            _buildDictionarySection(context, searchResult),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(state: state),
    );
  }

  Widget _buildBookWordsSection(BuildContext context, String bookTitle, List<Word> words) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bookTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: words.length,
          itemBuilder: (context, index) {
            return WordCard(word: words[index]);
          },
        ),
      ],
    );
  }

  Widget _buildDictionarySection(BuildContext context, Word searchResult) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dictionary",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "kore",
            filled: true,
            fillColor: const Color(0xFF1F1F1F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        WordCard(word: searchResult),
      ],
    );
  }
}

class WordCard extends StatelessWidget {
  final Word word;

  const WordCard({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow, // This can be customized based on the design
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWordColumn("ENGLISH", word.eng),
            _buildWordColumn("FURAGANA", word.furagana),
            _buildWordColumn("KANJI", word.kanji),
          ],
        ),
      ),
    );
  }

  Widget _buildWordColumn(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class MangaBookPage extends StatelessWidget {
  final GlobalState state;
  const MangaBookPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("manabee"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => onPressCreateBubble(state),
        child: const Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
      body: Stack(
        children: [
          MangaBookView(state: state),
          BubbleListView(),
          if (state.selectedWord != null) // Show the dictionary card if a word is selected
            Align(
              alignment: Alignment.bottomCenter,
              child: DictionaryCard(word: state.selectedWord!),
            ),
        ],
      ),
      bottomNavigationBar: MangaNavButtons(state: state),
    );
  }
}

class DictionaryCard extends StatelessWidget {
  final Word word;

  const DictionaryCard({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.kanji,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              word.furagana,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              word.eng,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            // TODO: Add tags, links, and other details from the design
          ],
        ),
      ),
    );
  }
}

class AddMangaBookPage extends StatelessWidget {
  final GlobalState state;
  const AddMangaBookPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("manabee"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => onPressSaveNewBook(state),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: AddMangaBookView(state: state),
      bottomNavigationBar: BottomBar(state: state),
    );
  }
}

//--------------------------------------------------------------

class MangaBookChapterSelect extends StatelessWidget {
  final GlobalState state;
  const MangaBookChapterSelect({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = state.selectedBook;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("manabee"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, book),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "All Chapters",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
            ),
            _buildChapterList(state),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(state: state),
    );
  }

  Widget _buildHeader(BuildContext context, MangaBook book) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.file(
            File(book.cover),
            height: 180,
            width: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Last Page Read",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                book.lastPageRead.isNotEmpty
                    ? Image.file(
                        File(book.lastPageRead),
                        height: 80,
                        width: 120,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 80,
                        width: 120,
                        color: Colors.grey[800],
                        child: const Center(child: Text("No pages read yet", style: TextStyle(color: Colors.white))),
                      ),
                const SizedBox(height: 8),
                // TODO: Implement page count logic
                Text(
                  "Page 0 of 0 Read",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList(GlobalState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.selectedBook.chapterDirs.length,
      itemBuilder: (context, index) {
        final chapterDir = state.selectedBook.chapterDirs[index];
        // This is a placeholder for the number of words in a chapter.
        // In a real app, you would need to calculate this.
        final wordCount = (index + 1) * 5;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => onPressSelectChapter(state, chapterDir),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Chapter ${index + 1}"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.message, size: 14),
                      const SizedBox(width: 4),
                      Text("$wordCount"),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddMangaBookView extends StatelessWidget {
  final GlobalState state;
  const AddMangaBookView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => onPressAddCover(state),
            child: Container(
              height: 250,
              width: 180,
              color: Colors.purple,
              child: state.addBookCover.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 48),
                          Text("cover image",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    )
                  : Image.file(File(state.addBookCover), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: state.addBookChapters.length,
              itemBuilder: (context, index) {
                final chapterPath = state.addBookChapters[index];
                return Card(
                  color: const Color(0xFF1F1F1F),
                  child: ListTile(
                    leading: const Icon(Icons.folder, color: Colors.white),
                    title: Text(
                      chapterPath,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
            ),
            onPressed: () => onPressAddFolders(state),
            child: const Text("+ add new page/folder"),
          ),
        ],
      ),
    );
  }
}

class BubbleItem extends StatelessWidget {
  BubbleItem({Key? key, required this.item, required state}) : super(key: key);
  final Bubble item;

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController =
        TextEditingController(text: item.text);

    return Consumer<GlobalState>(builder: (context, state, widget) {
      return Positioned(
        top: item.y,
        left: item.x,
        child: Draggable(
          feedback: Container(
            height: 48,
            width: 250,
            child: Text(textFieldController.text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
            padding: const EdgeInsets.only(left: 16, right: 32),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          onDragStarted: () => {
            //TODO hide OG
          },
          onDragEnd: (draggableDetails) => {
            item.x = draggableDetails.offset.dx,
            item.y = draggableDetails.offset.dy,
            onBubbleTextChange(state, textFieldController.text, item),
            //TODO show OG
          },
          child: Visibility(
              visible: true,
              child: Container(
                height: 48,
                width: 250,
                padding: const EdgeInsets.only(left: 16, right: 32),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: TextField(
                  maxLines: 2,
                  onTapOutside: (event) => {
                    onBubbleTextChange(state, textFieldController.text, item),
                  },
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  controller: textFieldController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              )),
        ),
      );
    });
  }
}

class BubbleListView extends StatelessWidget {
  BubbleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        alignment: Alignment.topLeft,
        child: Consumer<GlobalState>(builder: (context, state, widget) {
          return Stack(
            children: state.currentPageBubbles.map((item) {
              return BubbleItem(state: state, item: item);
            }).toList(),
          );
        }),
      ),
    );
  }
}

class MangaNavButtons extends StatelessWidget {
  const MangaNavButtons({Key? key, required this.state}) : super(key: key);
  final GlobalState state;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              if (state.currentPageNumber > 0) {
                onPressPrevPage(state);
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            "${state.currentPageNumber + 1} / ${state.book.length}",
            style: const TextStyle(color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              if (state.currentPageNumber < state.book.length - 1) {
                onPressNextPage(state);
              }
            },
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class MangaBookView extends StatelessWidget {
  const MangaBookView({Key? key, required state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      return Consumer<GlobalState>(builder: (context, state, widget) {
        return Container(
          margin: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            color: Colors.lime,
          ),
          child: Image.file(
            state.book[state.currentPageNumber],
          ),
        );
      });
    } catch (err) {
      print('No Books to display');
      return Container();
    }
  }
}

class MangaBookItem extends StatelessWidget {
  const MangaBookItem({Key? key, required this.item, required this.state})
      : super(key: key);
  final MangaBook item;
  final GlobalState state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressMangaBookItem(state, item),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Image.file(
              File(item.cover),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.message, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${item.words.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MangaListView extends StatelessWidget {
  const MangaListView({Key? key, required this.state}) : super(key: key);
  final GlobalState state;

  @override
  Widget build(BuildContext context) {
    if (state.bookList.isEmpty) {
      return const Center(
        child: Text(
          "No books found. Add a new book to get started.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/grid_background.png"), // Add your grid image here
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 9 / 16,
        ),
        itemCount: state.bookList.length,
        itemBuilder: (context, index) {
          final item = state.bookList[index];
          return MangaBookItem(item: item, state: state);
        },
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required this.state}) : super(key: key);
  final GlobalState state;

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    int currentIndex = 0;
    if (currentRoute == '/tags') {
      currentIndex = 1;
    } else if (currentRoute == '/flash-cards') {
      currentIndex = 2;
    }

    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.toNamed('/');
            break;
          case 1:
            Get.toNamed('/tags');
            break;
          case 2:
            Get.toNamed('/flash-cards');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Tags',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.style),
          label: 'Flash Cards',
        ),
      ],
    );
  }
}
