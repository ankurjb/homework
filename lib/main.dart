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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('SUBMIT'),
      ),
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
                          child: Container(
                            color: Colors.white10,
                            child: Text(_items[position]["standard"]),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Text(_items[position]["subjects"][index]
                                  ["subject_name"]);
                            },
                            itemCount: _items[position]["subjects"].length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: _items.length,
                )),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
