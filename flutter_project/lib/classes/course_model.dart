import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String courseId;
  final String name;
  final String? description;

  CourseModel({required this.courseId, required this.name, this.description});

  /// DocumentSnapshot is the data type returned by firestore
  factory CourseModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CourseModel(
      courseId: snapshot.id,
      name: data?['name'].toString() ?? "",
      description: data?['description'].toString() ?? "",
    );
  }

  /*Map<String, dynamic> toMap() {
    return {
      "name": name,
      if (description != null) "description": description ?? "",
    };
  }*/
}
