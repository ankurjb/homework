import 'Subjects.dart';

class Classess {
  String? standard;
  List<Subjects>? subjects;

  Classess({this.standard, this.subjects});

  Classess.fromJson(Map<String, dynamic> json) {
    standard = json['standard'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['standard'] = standard;
    if (subjects != null) {
      data['subjects'] = subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
