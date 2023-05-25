//Libs
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//Local
import 'actions.dart';
import 'store.dart';

//------------------------PAGE----------------------------

class HomePage extends StatelessWidget {
  final GlobalState state;
  const HomePage({Key? key, required this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      body: Consumer<GlobalState>(builder: (context, state, widget) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("for keys:")),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: state.selectedPublicKey,
                    items: <String>['', 'A', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (key) {
                      print(key);
                      if(key is String){
                        handleSelectKey(state, key);
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                TextFormField(
                  style: TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {

                }, child: Text("encrypt //")),
                TextFormField(
                  style: TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {

                }, child: Text("copy []"))
              ],
            ),
          ],
        );
      }),
    );
  }
}

class DecryptPage extends StatelessWidget {
  final GlobalState state;
  const DecryptPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      body: Consumer<GlobalState>(builder: (context, state, widget) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("for keys:")),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: state.selectedPublicKey,
                    items: <String>['', 'A', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (key) {
                      print(key);
                      if(key is String){
                        handleSelectKey(state, key);
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                TextFormField(
                  style: TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {

                }, child: Text("encrypt //")),
                TextFormField(
                  style: TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {

                }, child: Text("copy []"))
              ],
            ),
          ],
        );
      }),
    );
  }
}

class KeysPage extends StatelessWidget {
  final GlobalState state;
  const KeysPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      body: Consumer<GlobalState>(builder: (context, state, widget) {
        return Column(
          children: [
            
            Column(),
          ],
        );
      }),
    );
  }
}


class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, state, widget) {
      return BottomNavigationBar(
        selectedFontSize: 14,
        currentIndex: state.currentNavbarIndex,
        onTap: (value) {
          navigateToPage(state, ['encrypt', 'decrypt', 'keys'][value], value, context);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.password_outlined),
            label: 'Encrypt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'Decrypt',
          ),
                   BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Keys',
          ),
        ],
      );
    });
  }
}

class Bucket extends StatelessWidget {
  const Bucket({Key? key, required this.text, required state})
      : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController =
        TextEditingController(text: text);

    return Consumer<GlobalState>(builder: (context, state, widget) {
      return TextField(
        maxLines: 5,
        keyboardType: TextInputType.text,
        controller: textFieldController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      );
    });
  }
}
