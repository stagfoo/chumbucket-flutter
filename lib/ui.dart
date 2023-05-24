//Libs
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            handleButtonClick(state);
          },
          child: const Icon(Icons.add)),
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      body: Consumer<GlobalState>(builder: (context, state, widget) {
        return Stack(
          children: [
            DropdownButton<String>(
              items: <String>['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            TextFormField(),
            Bucket(text: state.bucket.join(' '), state: state)
          ],
        );
      }),
    );
  }
}

class OtherPage extends StatelessWidget {
  final GlobalState state;
  const OtherPage({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Other Page"),
      ),
      bottomNavigationBar:
          Consumer<GlobalState>(builder: (context, state, widget) {
        return BottomBar(state: state);
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            handleButtonClick(state);
          },
          child: const Icon(Icons.add)),
      body: Stack(
        children: [
          Consumer<GlobalState>(builder: (context, state, widget) {
            return Bucket(text: state.bucket.join(' '), state: state);
          }),
        ],
      ),
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
          navigateToPage(state, ['home', 'other'][value], value, context);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Other',
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
