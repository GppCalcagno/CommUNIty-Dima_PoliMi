import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/classes/message_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupChatListWidget extends StatefulWidget {
  final List<GroupChatModel> userGroups;
  Function? callback;

  GroupChatListWidget({super.key, required this.userGroups, this.callback});
  
  @override
  State<GroupChatListWidget> createState() => GroupChatListState(); 
}

class GroupChatListState extends State<GroupChatListWidget> {
  DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width  = MediaQuery.of(context).size.width;

    return Container(
      /*decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.purple[400]!.withOpacity(0.3),
            Colors.purple[300]!.withOpacity(0.3),
            Colors.purple[300]!.withOpacity(0.3),
            Colors.purple[200]!.withOpacity(0.3),
            Colors.purple[100]!.withOpacity(0.4),
            Colors.purple[50]!.withOpacity(0.4),
            Colors.white,
          ],
        )
      ),*/
      child: Center(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //widget.userGroups.isNotEmpty ? Expanded(
            Expanded(  
              child: ListView.builder(
                itemCount: widget.userGroups.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(top: height * 0.01),
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //color: Colors.purple[400],
                    color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
                    elevation: 8,
                    child: ListTile(
                      leading: ClipOval(
                        child: Image.network(
                          widget.userGroups[index].icon, 
                          width: 50, 
                          height: 50, 
                          fit: BoxFit.cover,
                        )
                      ),
                      title: Text(widget.userGroups[index].name, style: TextStyle(color: Colors.white, fontSize: 20), overflow: TextOverflow.ellipsis),
                      subtitle: Row(
                        children: widget.userGroups[index].lastMessage != null ? [
                          Text('${widget.userGroups[index].lastMessageSender ?? ''}: ', style: TextStyle(color: Colors.white70, fontSize: 16), overflow: TextOverflow.ellipsis),
                          Flexible(child: Text(widget.userGroups[index].lastMessage!, style: TextStyle(color: Colors.white70, fontSize: 16), overflow: TextOverflow.ellipsis)),
                        ]
                        : [ Text('<empty>', style: TextStyle(color: Colors.white70, fontSize: 16), overflow: TextOverflow.ellipsis),],
                      ),
                      trailing: widget.userGroups[index].lastMessageTimestamp != null && widget.userGroups[index].lastMessageTimestamp!.toDate().day != DateTime.now().day ? 
                        Text('${widget.userGroups[index].lastMessageTimestamp!.toDate().day.toString().padLeft(2,'0')}/${widget.userGroups[index].lastMessageTimestamp!.toDate().month.toString().padLeft(2,'0')}/${widget.userGroups[index].lastMessageTimestamp!.toDate().year.toString()}', 
                        style: TextStyle(color: Colors.white70, fontSize: 16))
                        :
                      Text(widget.userGroups[index].lastMessageTimestamp != null ? 
                        '${widget.userGroups[index].lastMessageTimestamp!.toDate().hour.toString().padLeft(2,'0')}:${widget.userGroups[index].lastMessageTimestamp!.toDate().minute.toString().padLeft(2,'0')}' 
                        : '', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      
                      onTap: () async {
                    
                        if (widget.callback == null) {
                          context.push('/chatpage', extra: widget.userGroups[index]);
                        } else {
                          List<MessageModel> messages = await dbService.getGroupMessages(widget.userGroups[index].groupId);
                          widget.callback!(widget.userGroups[index], messages);
                        }
                    
                      },
                    ),
                  );
                }
              ),
            )
            /*: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/noGroupFound.png", height: 300, width: 300),
                    Text('No group found', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20))),
                  ],
                ),
              ),*/
          ],
        )
      ),
    );
  }
}