import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Homework'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _items = [];

  // TODO optimise this
  List selected = List.generate(
      50, (i) => List.filled(50, false, growable: false),
      growable: false);

  final List<String> _selectedItems = [];

  bool _isButtonDisabled = true;

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/response.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["classess"];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
        child: ElevatedButton(
          onPressed: _isButtonDisabled
              ? null
              : () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SecondRoute(selectedItems: _selectedItems)));
          },
          child: const Text(
            'Continue',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
          ),
        ),
      ) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teacher profile',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 12)),
                        Text(
                          'Which grades & subjects you teach',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, position) {
                      return Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox.square(
                                  dimension: 50,
                                  child: Card(
                                    color: Colors.black,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _items[position]["standard"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 16,
                                        child: Column(
                                          children: [
                                            Image.network(
                                              _items[position]["subjects"]
                                                  [index]["subject_image"],
                                              fit: BoxFit.fill,
                                              height: 140,
                                              width: 140,
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: selected[position]
                                                      [index],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      selected[position]
                                                          [index] = value!;
                                                      _isButtonDisabled =
                                                          _selectedItems
                                                              .isNotEmpty;
                                                      if (value) {
                                                        _selectedItems.add(_items[
                                                                        position]
                                                                    ["subjects"]
                                                                [index]
                                                            ["subject_name"]);
                                                      } else {
                                                        _selectedItems.remove(
                                                            _items[position][
                                                                        "subjects"]
                                                                    [index][
                                                                "subject_name"]);
                                                      }
                                                    });
                                                  },
                                                ),
                                                Text(_items[position]
                                                        ["subjects"][index]
                                                    ["subject_name"]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount:
                                        _items[position]["subjects"].length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: _items.length,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key, required this.selectedItems}) : super(key: key);
  final List<String> selectedItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(selectedItems.first + selectedItems.last)),
      ),
    );
  }
}
