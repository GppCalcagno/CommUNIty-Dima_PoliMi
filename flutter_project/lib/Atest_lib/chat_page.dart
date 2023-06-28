import 'package:dima_project/Atest_lib/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/Atest_lib/classes/message_model.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/Atest_lib/widgets/group_chat/chat_widget.dart';
import 'package:flutter/material.dart';

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
        title: Text(key: Key('title'), widget.group.name),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 0),
            child: GestureDetector(
              child: ClipOval(
                child: Icon(key: Key('infoIcon'), Icons.info_outline_rounded, size: 20, color: Colors.white),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      icon: Icon(key: Key('groupIcon'), Icons.groups_rounded, size: 20, color: Colors.deepPurple[400]),
                      title: Text(key: Key('groupInfo'), 'Group Info', style: TextStyle(fontSize: 10)),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(key: Key('dialogName'), 'Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                              Flexible(key: Key('groupName'), child: Text(widget.group.name, style: TextStyle(fontSize: 10))),
                            ],
                          ),
                          Row(
                            children: [
                              Text(key: Key('dialogMembers'), 'Members: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                              FutureBuilder<List<UserModel>>(
                                future: groupMembers,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Flexible(key: Key('numMembers'), child: Text(snapshot.data!.length.toString(), style: TextStyle(fontSize: 10)));
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
                              key: Key('closeButton'),
                              onPressed: () {
                                //context.pop();
                                Navigator.of(context).pop();
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