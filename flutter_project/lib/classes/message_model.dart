import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/user_model.dart';

class MessageModel {
  String message;
  DocumentReference sender; // first get the reference of the sender from the db (lazy loading)
  UserModel? senderData;  // then get the data from the reference using the function getMessageSender
  Timestamp timestamp;
  bool isGif;

  MessageModel({
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.isGif,
  });


  Map<String, dynamic> toMap(String senderId) {
    return {
      'message': message,
      'sender': FirebaseFirestore.instance.doc("users/$senderId"),
      'timestamp': timestamp,
      'isGif': isGif
    };
  }

  factory MessageModel.fromDocumentSnapshot(DocumentSnapshot messageSnapshot) {
    return MessageModel(
      message: messageSnapshot['message'],
      sender: messageSnapshot['sender'],
      timestamp: messageSnapshot['timestamp'],
      isGif: messageSnapshot['isGif']
    );
  }
}