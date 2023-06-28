import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/user_model.dart';

class MessageModel {
  String message;
  UserModel? senderData;
  Timestamp timestamp;
  bool isGif;

  MessageModel({
    required this.message,
    required this.timestamp,
    required this.isGif,
    this.senderData
  });
}