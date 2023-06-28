import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isGif;
  final UserModel sender;
  final Timestamp sendAt;
  final String imgProfile;
  final bool isMe;
  final bool isTablet;

  const ChatBubbleWidget({
    required this.message,
    required this.isGif,
    required this.sender,
    required this.imgProfile,
    required this.sendAt,
    this.isMe = false,
    required this.isTablet,
    Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = '${sendAt.toDate().hour.toString().padLeft(2,'0')}:${sendAt.toDate().minute.toString().padLeft(2,'0')}  ${sendAt.toDate().day.toString().padLeft(2,'0')}-${sendAt.toDate().month.toString().padLeft(2,'0')}-${sendAt.toDate().year.toString()}';

    return Container(
      width: double.infinity,
      //margin: const EdgeInsets.only(bottom: 24),
      margin: EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: isMe ? 0 : 20,
        right: isMe ? 20 : 0,
      ),
      child: isMe
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(left: 30),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            color: Color.fromARGB(255, 147, 96, 219).withOpacity(0.8),
                          ),
                          child: !isGif ? 
                          Text(
                            message,
                            style: GoogleFonts.quicksand(
                              fontSize: !isTablet ? 14 : 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                            ),
                          ) : Image.network(
                            message, 
                            height: 200, 
                            width: 200),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            date,
                            style: GoogleFonts.quicksand(
                              fontSize: !isTablet ? 12 : 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: !isTablet ? 40 : 60,
                  width: !isTablet ? 40 : 60,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      placeholder: 'assets/placeholder.png',
                      image: imgProfile,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: !isTablet ? 40 : 60,
                  width: !isTablet ? 40 : 60,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: Icon(Icons.person, size: !isTablet ? 40 : 60, color: Colors.deepPurple[400],),
                            title: Text('Profile Info', textAlign: TextAlign.center, style: TextStyle(fontSize: !isTablet ? 20 : 24)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text('Username: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: !isTablet ? 16 : 20)),
                                    Flexible(child: Text(sender.username, style: TextStyle(fontSize: !isTablet ? 16 : 20))),
                                  ]
                                ),
                                Row(
                                  children: [
                                    Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: !isTablet ? 16 : 20)),
                                    Flexible(child: Text(sender.email, style: TextStyle(fontSize: !isTablet ? 16 : 20))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('First name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: !isTablet ? 16 : 20)),
                                    Flexible(child: Text(sender.firstName ?? '', style: TextStyle(fontSize: !isTablet ? 16 : 20))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Last name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: !isTablet ? 16 : 20)),
                                    Flexible(child: Text(sender.lastName ?? '', style: TextStyle(fontSize: !isTablet ? 16 : 20))),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }, 
                                    child: Text('Close', style: TextStyle(fontSize: !isTablet ? 16 : 20)),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      );
                    },
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        placeholder: 'assets/placeholder.png',
                        image: imgProfile,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              border: Border.all(
                                color: Color.fromARGB(196, 241, 147, 248),
                              ),
                              color: Color.fromARGB(196, 241, 147, 248),
                            ),
                          child: !isGif ? 
                          Text(
                            message,
                            style: GoogleFonts.quicksand(
                              fontSize: !isTablet ? 14 : 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                            ),
                          ) : Image.network(
                            message,
                            width: 200,
                            height: 200,),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            date,
                            style: GoogleFonts.quicksand(
                              fontSize: !isTablet ? 12 : 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
  
}