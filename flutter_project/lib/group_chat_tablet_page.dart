import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/classes/message_model.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/widgets/group_chat/chat_widget.dart';
import 'package:dima_project/widgets/group_chat/group_chat_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:dima_project/widgets/drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupChatTablet extends StatefulWidget {
  const GroupChatTablet({super.key});

  @override
  State<GroupChatTablet> createState() => GroupChatTabletState();
}

class GroupChatTabletState extends State<GroupChatTablet> {
  DatabaseService dbService = DatabaseService();
  //late Future<List<GroupChatModel>> userGroups;
  late Future<List<String>> userGroupIds;
  late Future<UserModel> currentUser;
  GroupChatModel? selectedGroup;
  List<MessageModel>? selectedGroupMessages;

  late Stream<List<GroupChatModel>> streamGroups;

  @override
  void initState() {
    super.initState();
    //userGroups = dbService.getUserGroups();
    userGroupIds = dbService.getUserGroupIds();
    currentUser = dbService.getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  callback(GroupChatModel group, List<MessageModel> messages) async {
    setState(() {
      selectedGroup = group;
      selectedGroupMessages =  messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('BUILD CHAT TABLET PAGE');
    
    return Scaffold(
      
      appBar: AppBar(
        
        title: const Text('Group chat'),
        backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0), // 8.0
        child: Row(
          children: [

            // left view
            Expanded(
              child : FutureBuilder<List<String>>(
                future: userGroupIds,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Icon(Icons.error));
                  } else if (snapshot.hasData) {
                      //debugPrint('FUTURE GROUP IDS');
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/noGroupFound.png", height: 300, width: 300),
                              Text('No group found', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20))),
                            ],
                          ),
                        );
                      }
                      streamGroups = dbService.streamUserGroups(snapshot.data!);

                      return StreamBuilder<List<GroupChatModel>>(
                        stream: streamGroups,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Icon(Icons.error));
                          } else if (snapshot.hasData) {
                            //debugPrint('STREAM GROUPS');
                            
                            return GroupChatListWidget(
                              userGroups: snapshot.data!,
                              callback: callback
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          } 
                        },
                      );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  } 
                },
              ),
            ),

            /* VERSIONE SENZA STREAM */
            /*Expanded(
              child: FutureBuilder<List<GroupChatModel>>(
                future: userGroups,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Icon(Icons.error));
                  } else if (snapshot.hasData) {
                    return GroupChatListWidget(
                      userGroups: snapshot.data!, 
                      callback: callback
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  } 
                },
              )
            ),*/
        
            // right view
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 800,
                child: FutureBuilder<UserModel>(
                  future: currentUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Icon(Icons.error));
                    } else if (snapshot.hasData) {
                        return ChatWidget(
                          group: selectedGroup,
                          messageList: selectedGroupMessages ?? [],
                          currentUser: snapshot.data!,
                          isTablet: true,
                        );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    } 
                  },
                ),
              ),
            )
          ],
        ),
      ),
      drawer: const DrawerForNavigation(),
    );
  }
}
