import 'Classess.dart';

class Classes {
  List<Classess>? classess;

  Classes({this.classess});

  Classes.fromJson(Map<String, dynamic> json) {
    if (json['classess'] != null) {
      classess = <Classess>[];
      json['classess'].forEach((v) {
        classess!.add(Classess.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (classess != null) {
      data['classess'] = classess!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
