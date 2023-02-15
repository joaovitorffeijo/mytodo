// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/Item.dart';

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen, // Paleta de cores principal
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var itens = <Item>[];

  HomePage() {}

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.itens.insert(
        0,
        Item(
          title: newTaskCtrl.text,
          done: false,
        ),
      );
      newTaskCtrl.text = "";
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.itens = result;
      });
    }
  } // Carrega os itens que foram salvos na memória.

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.itens));
  }

  void remove(int index) {
    setState(() {
      widget.itens.removeAt(index);
      save();
    });
  }

  TextFormField() {
    return TextField(
      controller: newTaskCtrl,
      keyboardType: TextInputType.text,
      cursorColor: Colors.lightGreen,
      cursorWidth: 2.0,
      decoration: InputDecoration(
        hintText: 'Escreva sua próxima tarefa...',
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: Color.fromARGB(255, 53, 52, 52),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        title: const Text(
          'My To-Do List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(14),
              bottomLeft: Radius.circular(14)),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.6,
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextFormField(),
            ),
            Expanded(
              child: Container(
                width: screenWidth * 0.8,
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  itemCount: widget.itens.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = widget.itens[index];

                    return Card(
                      color: Color.fromARGB(255, 31, 31, 31),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                      ),
                      child: SizedBox(
                        width: 50,
                        child: Dismissible(
                          child: CheckboxListTile(
                            side: MaterialStateBorderSide.resolveWith(
                              (states) =>
                                  BorderSide(width: 1.0, color: Colors.white),
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(color: Colors.white),
                            ),
                            value: item.done,
                            onChanged: (value) {
                              setState(() {
                                item.done = value;
                                save();
                              });
                            }, // OnChanged
                          ),
                          key: Key(item.title),
                          background: Container(
                            color: Colors.redAccent,
                          ),
                          onDismissed: (direction) {
                            remove(index);
                          },
                        ),
                      ),
                    );
                  }, // ItemBuilder
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
