import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/api_keys.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/classes/message_model.dart';
import 'package:dima_project/services/notification_service.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/widgets/group_chat/chat_bubble_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatWidget extends StatefulWidget {
  final UserModel currentUser;
  final GroupChatModel? group;
  final List<MessageModel>? messageList;
  final bool isTablet;
  const ChatWidget({Key? key, required this.group, required this.messageList, required this.currentUser, required this.isTablet}) : super(key: key);

  @override
  State<ChatWidget> createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> {
  DatabaseService dbService = DatabaseService();
  List<MessageModel> messages = [];
  final _messageTextController = TextEditingController();
  late Stream<MessageModel> _streamLastMessage;
  GiphyGif? _gif;
  late Future<List<UserModel>> groupMembers;

  @override
  void initState() {
    super.initState();
    if (widget.group == null) {
      //debugPrint('GROUP IS NULL');
    }
  }

  @override
  void dispose() {
    //debugPrint('DISPOSE CHAT WIDGET');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('BUILD CHAT WIDGET');

    if (widget.group == null) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset("assets/chat_tab.png", height: 440, width: 440),
      ]);
    } else {
      groupMembers = dbService.getGroupMembers(widget.group!.groupId);

      setState(() {
        messages = widget.messageList!; // initialize message list with old messages
      });
      _streamLastMessage = dbService.streamLastMessage(widget.group!.groupId); // initialize stream to listen for new messages

      return SafeArea(
        child: Column(
          children: [
            !widget.isTablet
                ? Container()
                : Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.group != null ? widget.group!.name : 'Select a group',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          child: Icon(Icons.info_outline_rounded, color: Colors.white70),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    icon: Icon(Icons.groups_rounded, size: 60, color: Colors.deepPurple[400]),
                                    title: Text('Group Info', style: TextStyle(fontSize: 24)),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                            Flexible(child: Text(widget.group!.name, style: TextStyle(fontSize: 20))),
                                          ],
                                        ),
                                        Row(children: [
                                          Text('Members: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                          FutureBuilder<List<UserModel>>(
                                            future: groupMembers,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Flexible(child: Text(snapshot.data!.length.toString(), style: TextStyle(fontSize: 20)));
                                              } else if (snapshot.hasError) {
                                                return Center(child: Icon(Icons.error));
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                            },
                                          )
                                        ])
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
                                            child: const Text('Close', style: TextStyle(fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
            Expanded(
              child: _chatMessages(),
            ),
            ..._buildInputChat(context),
          ],
        ),
      );
    }
  }

  _chatMessages() {
    return StreamBuilder(
        stream: _streamLastMessage,
        builder: (context, AsyncSnapshot<MessageModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (messages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/noMessageFound.png', height: 200, width: 200),
                    Text('No messages, start chatting!', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Icon(Icons.error));
            } else if (snapshot.hasData) {
              //debugPrint('STREAM DATA');

              if (messages.isEmpty) {
                messages.add(snapshot.data!);
              } else {
                if (messages.first.timestamp != snapshot.data!.timestamp) {
                  messages.insert(0, snapshot.data!);
                }
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubbleWidget(
                    message: messages[index].message,
                    isGif: messages[index].isGif,
                    isMe: messages[index].senderData!.uid == widget.currentUser.uid,
                    sendAt: messages[index].timestamp,
                    sender: messages[index].senderData!,
                    imgProfile: messages[index].senderData!.imageUrl,
                    isTablet: widget.isTablet,
                  );
                },
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        });
  }

  List<Widget> _buildInputChat(BuildContext context) {
    return [
      const SizedBox(height: 8),
      Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: Icon(
                Icons.gif_box_outlined,
                color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
                size: 50,
              ),
              onPressed: () async {
                _gif = await GiphyPicker.pickGif(context: context, apiKey: giphyKey);
                if (_gif != null) {
                  _sendMessage(true, _gif!.images.original!.url.toString(), Timestamp.now(),
                      FirebaseFirestore.instance.doc("users/${widget.currentUser.uid}"));
                  //_sendPushNotification();
                  _gif = null;
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              height: 56,
              width: double.infinity,
              alignment: Alignment.center,
              //margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
              child: TextFormField(
                key: const Key('inputText'),
                scrollPhysics: const BouncingScrollPhysics(),
                controller: _messageTextController,
                maxLines: null,
                style: GoogleFonts.quicksand(
                  fontSize: !widget.isTablet ? 14 : 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.3),
                  hintText: 'Send a message...',
                  hintStyle: GoogleFonts.quicksand(
                    color: Colors.white70,
                    fontSize: !widget.isTablet ? 16 : 20,
                    fontWeight: FontWeight.w800,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 134, 97, 236),
                      width: 0.8,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 134, 97, 236),
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            key: Key('sendButton'),
            onTap: () {
              String msg = _messageTextController.text;
              _messageTextController.clear();
              _sendMessage(false, msg, Timestamp.now(), FirebaseFirestore.instance.doc("users/${widget.currentUser.uid}"));
              
            },
            child: Container(
                height: 53,
                width: 53,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.send, color: Colors.white)),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ];
  }

  _sendMessage(bool isGif, String message, Timestamp timestamp, DocumentReference sender) async {
    if (!isGif && message.isNotEmpty || isGif) {
      MessageModel msg = _buildMessage(isGif, message, timestamp, sender);

      if (await dbService.sendMessage(widget.group!.groupId, msg)) {
        _sendPushNotification();
      }
    }
  }

  // Function used to build a message to send
  MessageModel _buildMessage(bool isGif, String message, Timestamp timestamp, DocumentReference sender) {
    MessageModel msg = MessageModel(isGif: isGif, message: message, timestamp: timestamp, sender: sender);
    UserModel senderData = UserModel(
        uid: widget.currentUser.uid, username: widget.currentUser.username, email: widget.currentUser.email, imageUrl: widget.currentUser.imageUrl);
    msg.senderData = senderData;
    return msg;
  }

  _sendPushNotification() async {
    List<String> tokens = await DatabaseService().getChatTokens(widget.group!.groupId);
    String username = widget.currentUser.username;
    Map<String, dynamic> data = {
      'title': 'New message!',
      'body': '$username has sent a new message in group ${widget.group!.name}',
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    };
    tokens.remove(await FirebaseMessaging.instance.getToken());
    if (tokens.isNotEmpty) {
      NotificationService().sendPushNotification(tokens, 'New message!', '$username has sent a new message in group ${widget.group!.name}', data);
    }
  }
}
