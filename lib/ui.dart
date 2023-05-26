//Libs
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//Local
import 'actions.dart';
import 'store.dart';
import 'const.dart';

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
                    child: const Text(FOR_KEYS)),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: state.selectedPublicKey,
                    items: state.keyring.map((value) {
                      return DropdownMenuItem<String>(
                        value: value.publicKey,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      handleSelectKey(state, value!);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text(ENCRYPT)),
                TextFormField(
                  style: const TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text(COPY))
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
                    child: const Text(FOR_KEYS)),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: state.selectedPublicKey,
                    items: state.keyring.map((value) {
                      return DropdownMenuItem<String>(
                        value: value.publicKey,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (key) {
                      print(key);
                      if (key is String) {
                        handleSelectKey(state, key);
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //TODO component
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text(DECRYPT)),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                    height: 5,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text(COPY))
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
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      navigateToPage(state, 'new-key', 2);
                    },
                    child: const Text(CREATE)),
                TextButton(onPressed: () {}, child: const Text(IMPORT)),
              ],
            ),
            const Text(KEY_LIBRARY, textAlign: TextAlign.left),
            KeyList(state: state),
            const Text(
              SELECTED_KEYS_INFO,
              textAlign: TextAlign.left,
            ),
            KeyInfo(selectedKey: state.selectedPGPKey, state: state),
            Row(
              children: [
                TextButton(onPressed: () {}, child: const Text(DELETE)),
                TextButton(onPressed: () {}, child: const Text(COPY)),
                TextButton(onPressed: () {}, child: const Text(COPY)),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class NewKeyPage extends StatelessWidget {
  final GlobalState state;
  const NewKeyPage({Key? key, required this.state}) : super(key: key);

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
            const Text(CREATE_NEW_PAIR, textAlign: TextAlign.left),
            NewKeyTable(state: state),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      navigateToPage(state, 'keys', 2);
                    },
                    child: const Text(CANCEL)),
                TextButton(onPressed: () {}, child: const Text(CREATE)),
              ],
            ),
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
          navigateToPage(state, ['encrypt', 'decrypt', 'keys'][value], value);
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

class KeyList extends StatelessWidget {
  const KeyList({Key? key, required state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, state, widget) {
      return Padding(
          padding: EdgeInsets.all(10),
          child: Table(
              border: TableBorder.all(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
              columnWidths: {
                1: FractionColumnWidth(.1),
              },
              children: state.keyring.map((e) {
                return TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(e.name, textAlign: TextAlign.left)),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('P', textAlign: TextAlign.center))
                ]);
              }).toList()));
    });
  }
}

class BorderedItem extends StatelessWidget {
  const BorderedItem({Key? key, required state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, state, widget) {
      return Container(
          decoration: BoxDecoration(
              // Red border with the width is equal to 5
              border: Border.all(width: 1, color: Colors.grey)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(4, 16, 4, 16),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      vertical: BorderSide(width: 1, color: Colors.grey)),
                ),
                child: Text("crypo"),
              ),
              Expanded(
                child: SizedBox(
                  child: Padding(
                      child: TextFormField(),
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0)),
                ),
              ),
            ],
          ));
    });
  }
}

class NewKeyTable extends StatelessWidget {
  const NewKeyTable({Key? key, required state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, state, widget) {
      return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              BorderedItem(state: state),
              BorderedItem(state: state),
              BorderedItem(state: state),
              BorderedItem(state: state),
              BorderedItem(state: state),
              BorderedItem(state: state),
            ],
          ));
    });
  }
}

class KeyInfo extends StatelessWidget {
  final PGPKey selectedKey;

  const KeyInfo({Key? key, required this.selectedKey, required state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, state, widget) {
      return Padding(
          padding: EdgeInsets.all(10),
          child: Table(
            border: TableBorder.all(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
            columnWidths: {
              0: FractionColumnWidth(.2),
            },
            children: [
              // TableRow(children: [
              //   Text("crypto"),
              //   Text(selectedKey.name)
              // ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("added", textAlign: TextAlign.left)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(selectedKey.name, textAlign: TextAlign.left)),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("added", textAlign: TextAlign.left)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(selectedKey.id.toString(),
                        textAlign: TextAlign.left)),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("added", textAlign: TextAlign.left)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child:
                        Text(selectedKey.updatedAt, textAlign: TextAlign.left)),
              ]),
            ],
          ));
    });
  }
}
