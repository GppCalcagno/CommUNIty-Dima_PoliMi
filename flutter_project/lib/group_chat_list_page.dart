import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/widgets/group_chat/group_chat_list_widget.dart';
import 'package:dima_project/widgets/drawer.dart';
import 'package:dima_project/widgets/group_chat/upper_gradient_picture_chat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupChatList extends StatefulWidget {
  const GroupChatList({super.key});

  @override
  State<GroupChatList> createState() => GroupChatListState();
}

class GroupChatListState extends State<GroupChatList> {
  DatabaseService dbService = DatabaseService();
  //Future<List<GroupChatModel>>? userGroups;
  late Future<List<String>> userGroupIds;
  late Stream<List<GroupChatModel>> streamGroups;

  @override
  void initState() {
    super.initState();
    //userGroups = dbService.getUserGroups();
    userGroupIds = dbService.getUserGroupIds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('BUILD CHAT PAGE');

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
      ),
      body: Column(
        children: [
          UpperGradientPictureChat(height: height, width: width),
          Transform.translate(
            offset: Offset(0.0, -(height * 0.025)),
            child: Container(
              height: 23,
              width: width,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 28, 28, 28) : Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
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

                  return StreamBuilder(
                    stream: streamGroups,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Icon(Icons.error));
                      } else if (snapshot.hasData) {
                        //debugPrint('STREAM GROUPS');

                        return GroupChatListWidget(userGroups: snapshot.data!);
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
                      return GroupChatListWidget(userGroups: snapshot.data!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),*/
        ],
      ),
      drawer: const DrawerForNavigation(),
    );
  }
}
