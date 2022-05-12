
class Subjects {
  String? subjectName;
  String? subjectImage;

  Subjects({this.subjectName, this.subjectImage});

  Subjects.fromJson(Map<String, dynamic> json) {
    subjectName = json['subject_name'];
    subjectImage = json['subject_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_name'] = subjectName;
    data['subject_image'] = subjectImage;
    return data;
  }
}
