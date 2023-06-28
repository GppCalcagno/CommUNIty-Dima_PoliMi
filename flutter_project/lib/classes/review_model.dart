import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/user_model.dart';

class ReviewModel {
  final String id;
  final String name;
  final int evaluation;
  final String? description;
  final Timestamp timestamp;
  final UserModel author;

  ReviewModel({
    required this.id,
    required this.name,
    required this.evaluation,
    required this.description,
    required this.timestamp,
    required this.author,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> reviewMap, UserModel user) {
    return ReviewModel(
        id: reviewMap['id'],
        name: reviewMap['name'],
        evaluation: reviewMap['evaluation'],
        description: reviewMap['description'],
        timestamp: reviewMap['timestamp'],
        author: user);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'evaluation': evaluation,
      'timestamp': timestamp,
      if (description != null) 'description': description,
      'author': FirebaseFirestore.instance.doc("users/${author.uid}"),
    };
  }
}
