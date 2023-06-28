import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/classes/message_model.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/widgets/group_chat/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final GroupChatModel group;
  const ChatScreen({super.key, required this.group});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  DatabaseService dbService = DatabaseService();
  late Future<UserModel> currentUser;
  late Future<List<UserModel>> groupMembers;
  late Future<List<MessageModel>> messageList;

  @override
  void initState() {
    super.initState();
    currentUser = dbService.getCurrentUser();
    groupMembers = dbService.getGroupMembers(widget.group.groupId);
    messageList = dbService.getGroupMessages(widget.group.groupId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              child: ClipOval(
                child: Image.network(
                  widget.group.icon, 
                  width: 40, 
                  height: 40, 
                  fit: BoxFit.cover,
                )
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      icon: Icon(Icons.groups_rounded, size: 40, color: Colors.deepPurple[400]),
                      title: Text('Group Info', style: TextStyle(fontSize: 20)),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Flexible(child: Text(widget.group.name, style: TextStyle(fontSize: 16))),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Members: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              FutureBuilder<List<UserModel>>(
                                future: groupMembers,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Flexible(child: Text(snapshot.data!.length.toString(), style: TextStyle(fontSize: 16)));
                                  } else if (snapshot.hasError) {
                                    return Center(child: Icon(Icons.error));
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              )
                            ]
                          )
                        ],
                      ),
                      actions: [
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([currentUser, messageList]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return ChatWidget(
              currentUser: snapshot.data![0], 
              group: widget.group, 
              messageList: snapshot.data![1],
              isTablet: false,
            );
          } else if (snapshot.hasError) {
            return Center(child: Icon(Icons.error));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}