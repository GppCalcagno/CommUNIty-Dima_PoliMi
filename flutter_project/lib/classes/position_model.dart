import 'package:cloud_firestore/cloud_firestore.dart';

class PositionModel {
  final String latitude;
  final String longitude;
  final String? description;
  final String? courseName;
  final Timestamp timestamp;

  PositionModel({
    required this.latitude, 
    required this.longitude,
    this.description, 
    this.courseName,
    required this.timestamp,
  });


  factory PositionModel.fromMap(Map<String, dynamic> positionMap) {
    return PositionModel(
      latitude : positionMap['coordinates']['latitude'],
      longitude : positionMap['coordinates']['longitude'],
      description : positionMap['description'],
      courseName : positionMap['course'],
      timestamp : positionMap['timestamp'],
      //course : positionMap['course'] != null ? getCourseFromReference(positionMap['course']) : null,
      //course: getCourseFromReference('BWt7hUfX6Vab4mvi8OL6'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coordinates' : {'latitude': latitude, 'longitude': longitude},
      if (description != null) 'description': description,
      //if (course != null) 'course': FirebaseFirestore.instance.collection('courses').doc(course!.courseId)
      //else 'course': null,
      'course': courseName,
      'timestamp': timestamp,
    };
  }

}
