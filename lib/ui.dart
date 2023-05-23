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
        title: const Text("Your Books"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      body: Stack(
        children: [
          Consumer<GlobalState>(builder: (context, state, widget) {
            return MangaListView(state: state);
          }),
        ],
      ),
    );
  }
}

class TagPage extends StatelessWidget {
  final GlobalState state;
  const TagPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Tags"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        AddMangaBookView(state: state),
        Align(
          child: Consumer<GlobalState>(builder: (context, state, widget) {
            return BottomBar(state: state);
          }),
          alignment: Alignment.bottomCenter,
        )
      ]),
    );
  }
}

//TODO re-write other widgets like this like this
class MangaBookPage extends StatelessWidget {
  final GlobalState state;
  const MangaBookPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var wvc = WebViewController();
    // wvc.loadRequest(Uri.parse('https://jisho.org/'));
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => {onPressCreateBubble(state)},
          child: Icon(Icons.chat_bubble),
        ),
        backgroundColor: Colors.black,
        body: Stack(children: [
          MangaBookView(state: state),
          //check which is better
          BubbleListView(),
          Align(
            child: MangaNavButtons(state: state),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: BottomBar(state: state),
            alignment: Alignment.bottomCenter,
          )
        ]));
  }
}

class AddMangaBookPage extends StatelessWidget {
  final GlobalState state;
  const AddMangaBookPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add New Book"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        AddMangaBookView(state: state),
        Align(
          child: Consumer<GlobalState>(builder: (context, state, widget) {
            return BottomBar(state: state);
          }),
          alignment: Alignment.bottomCenter,
        )
      ]),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Selected Book"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      body: Stack(
        children: [
          Consumer<GlobalState>(builder: (context, state, widget) {
            return Column(
              children: state.selectedBook.chapterDirs.map((item) {
                return TextButton(
                    //TODO add chapter
                    onPressed: () => {onPressSelectChapter(state, item)},
                    child: Text(item));
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class AddMangaBookView extends StatelessWidget {
  final GlobalState state;
  const AddMangaBookView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedItem = MangaBook();
    selectedItem.cover = state.addBookCover;
    selectedItem.chapterDirs = state.addBookChapters;
    return Container(
      child: Column(
        children: [
          Center(
              child: Container(
                  height: 300,
                  child: MangaBookItem(state: state, item: selectedItem))),
          TextButton(
              child: Text('Add Cover'),
              onPressed: () => {onPressAddCover(state)}),
          Column(
              children: state.addBookChapters.map((item) {
            return Text(
              item,
              style: TextStyle(color: Colors.white),
            );
          }).toList()),
          TextButton(
              child: Text('Add Chapter'),
              onPressed: () => {onPressAddFolders(state)}),
          TextButton(
              child: Text('Save Book'),
              onPressed: () => {onPressSaveNewBook(state)})
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
  const MangaNavButtons({Key? key, required state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.lime,
      ),
      child: Consumer<GlobalState>(builder: (context, state, widget) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (state.currentPageNumber > 0) {
                  onPressPrevPage(state);
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                if (state.currentPageNumber < state.book.length) {
                  onPressNextPage(state);
                }
              },
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        );
      }),
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
  const MangaBookItem({Key? key, required this.item, required state})
      : super(key: key);
  final MangaBook item;
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, state, widget) {
      return GestureDetector(
        onTap: () => onPressMangaBookItem(state, item),
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Image.file(
            File(item.cover),
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}

class MangaListView extends StatelessWidget {
  const MangaListView({Key? key, required state}) : super(key: key);
//didnt list to the state updates
  @override
  Widget build(BuildContext context) {
    try {
      return Consumer<GlobalState>(builder: (context, state, widget) {
        return GridView(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 9 / 16),
          children: state.bookList.map((item) {
            return MangaBookItem(
              state: state,
              item: item,
            );
          }).toList(),
        );
      });
    } catch (err) {
      return Container();
    }
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        //TODO create color palette https://pub.dev/packages/flutter_palette
        decoration: const BoxDecoration(color: Colors.black, boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 10,
            color: Colors.black12,
          ),
        ]),
        child: Consumer<GlobalState>(builder: (context, state, widget) {
          return Row(
            children: [
              IconButton(
                onPressed: () async {
                  Get.toNamed('/home');
                },
                icon: const Icon(Icons.home_outlined, color: Colors.white),
              ),
              IconButton(
                onPressed: () async {
                  Get.toNamed('/import');
                },
                icon: const Icon(Icons.book_outlined, color: Colors.white),
              ),
              IconButton(
                isSelected: false,
                onPressed: () async {
                  // Get.toNamed('/tags');
                  Get.toNamed('/tags');
                  // Get.toNamed('/flash-cards');
                },
                icon:
                    const Icon(Icons.chat_bubble_outline, color: Colors.white),
              ),
              IconButton(
                onPressed: () async {
                  // var dir = await pickDir();
                  // state.addMangaBook(dir);
                  // Get.toNamed('/import');
                  loadConfig(state);
                  print(state.bookList);
                },
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                tooltip: "reload config",
              )
            ],
          );
        }));
  }
}
