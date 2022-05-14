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

  final _selectedClassesWithSubject = <String, List<String>>{};

  bool _isButtonDisabled = true;

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/response.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["classess"];
    });
  }

  void modifySubject(bool isSelected, int classIndex, int subjectIndex) {
    String subject =
        _items[classIndex]["subjects"][subjectIndex]["subject_name"];
    String classes = _items[classIndex]["standard"];
    List<String>? subjectInSpecificClass =
        _selectedClassesWithSubject[classes] ?? [];

    if (isSelected) {
      subjectInSpecificClass.add(subject);
      _selectedClassesWithSubject[classes] = subjectInSpecificClass;
    } else {
      subjectInSpecificClass.remove(subject);
      if (subjectInSpecificClass.isEmpty) {
        _selectedClassesWithSubject.remove(classes);
      } else {
        _selectedClassesWithSubject[classes] = subjectInSpecificClass;
      }
    }
    _isButtonDisabled = _selectedClassesWithSubject.isEmpty;
  }

  String getSubjectName(int classIndex, int subjectIndex) =>
      _items[classIndex]["subjects"][subjectIndex]["subject_name"];

  String getClassesName(int index) => _items[index]["standard"];

  String getSubjectImage(int classIndex, int subjectIndex) =>
      _items[classIndex]["subjects"][subjectIndex]["subject_image"];

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
                          builder: (context) => SecondRoute(
                              selectedItems: _selectedClassesWithSubject)));
                },
          child: const Text(
            'Continue',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          style:
              ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        ),
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
                      itemBuilder: (context, classIndex) {
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
                                      color: Colors.black87,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getClassesName(classIndex),
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
                                      itemBuilder: (context, subjectIndex) {
                                        return Card(
                                          elevation: 16,
                                          child: Column(
                                            children: [
                                              Image.network(
                                                getSubjectImage(
                                                    classIndex, subjectIndex),
                                                fit: BoxFit.fill,
                                                height: 140,
                                                width: 140,
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: selected[classIndex]
                                                        [subjectIndex],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        selected[classIndex]
                                                                [subjectIndex] =
                                                            value!;
                                                        modifySubject(
                                                            value,
                                                            classIndex,
                                                            subjectIndex);
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    getSubjectName(classIndex,
                                                        subjectIndex),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      itemCount:
                                          _items[classIndex]["subjects"].length,
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
                    ),
                  ),
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
  final Map<String, List<String>> selectedItems;

  String getSubject(int index) {
    String subjects = "";
    String classes = selectedItems.keys.toList()[index];
    selectedItems[classes]?.forEach((element) {
      subjects += '$element ';
    });
    return subjects;
  }

  String getClass(int index) => selectedItems.keys.toList()[index];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Thank You',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          style:
              ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Padding(padding: EdgeInsets.only(top: 12)),
                Text(
                  'You teach these class and subjects',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: [
                            SizedBox.square(
                              dimension: 50,
                              child: Card(
                                color: Colors.black,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getClass(index),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 12)),
                            Text(getSubject(index),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: selectedItems.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
