import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatModel {
  String groupId;
  String name;
  String icon;
  //List<DocumentReference>? members;
  String? lastMessage;
  String? lastMessageSender;
  Timestamp? lastMessageTimestamp;

  GroupChatModel({
    required this.groupId, 
    required this.name,
    required this.icon,
    //this.members,
    this.lastMessage,
    this.lastMessageSender,
    this.lastMessageTimestamp,
  });

  factory GroupChatModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return GroupChatModel(
      groupId: snapshot.id,
      name: data?['name'],
      icon: data?['icon'],
      lastMessage: data?['lastMessage'],
      lastMessageSender: data?['lastMessageSender'],
      lastMessageTimestamp: data?['lastMessageTimestamp'],
    );
  }
}