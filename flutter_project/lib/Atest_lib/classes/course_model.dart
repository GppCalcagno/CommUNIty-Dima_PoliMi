class CourseModel {
  final String courseId;
  final String name;
  final String? description;

  CourseModel({required this.courseId, required this.name, this.description});

  /// DocumentSnapshot is the data type returned by firestore

  /*Map<String, dynamic> toMap() {
    return {
      "name": name,
      if (description != null) "description": description ?? "",
    };
  }*/
}
