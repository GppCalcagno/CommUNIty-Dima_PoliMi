import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/file_model.dart';
import 'package:dima_project/classes/user_model.dart';

class NoteModel {
  final String id;
  String name;
  bool isShared;
  //Attachment and attachment Url are used to load the files in a lazy way in the note page
  List<FileModel>? attachmentUrls;
  String? description;
  Timestamp timestamp;
  final UserModel author;
  final String courseId;

  NoteModel({
    required this.id,
    required this.courseId,
    required this.name,
    required this.isShared,
    this.attachmentUrls,
    this.description,
    required this.timestamp,
    required this.author,
  });

  factory NoteModel.fromMap(Map<String, dynamic> reviewMap, UserModel user) {
    return NoteModel(
        id: reviewMap['id'],
        courseId: reviewMap['courseId'],
        name: reviewMap['name'],
        isShared: reviewMap['isShared'],
        description: reviewMap['description'],
        timestamp: reviewMap['timestamp'],
        author: user);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'name': name,
      'isShared': isShared,
      if (description != null) 'description': description,
      'timestamp': timestamp,
      'author': FirebaseFirestore.instance.doc("users/${author.uid}"),
    };
  }
}
