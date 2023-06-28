import 'package:dima_project/Atest_lib/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/Atest_lib/widgets/group_chat/group_chat_list_widget.dart';
import 'package:dima_project/widgets/drawer.dart';
import 'package:dima_project/Atest_lib/widgets/group_chat/upper_gradient_picture_chat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupChatList extends StatefulWidget {
  final bool isEmpty;
  const GroupChatList({super.key, required this.isEmpty});

  @override
  State<GroupChatList> createState() => GroupChatListState();
}

class GroupChatListState extends State<GroupChatList> {
  DatabaseService dbService = DatabaseService();
  late Future<List<String>> userGroupIds;
  late Stream<List<GroupChatModel>> streamGroups;

  @override
  void initState() {
    super.initState();
    userGroupIds = dbService.getUserGroupIds(widget.isEmpty);
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
              key: const Key("translate"),
              height: 48,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
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
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/noGroupFound.png", height: 200, width: 200),
                          Text(key: Key('noGroup'), 'No group found', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20))),
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
        ],
      ),

      drawer: const DrawerForNavigation(),
    );
  }
}