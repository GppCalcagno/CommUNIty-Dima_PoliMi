import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/note_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class myNoteList extends StatelessWidget {
  List<NoteModel> notes;
  final Function() notifyParent;
  final Function(NoteModel note)? notifyPick;

  final CourseModel course;
  final String userID = FirebaseAuth.instance.currentUser!.uid;
  myNoteList({super.key, required this.notes, required this.course, required this.notifyParent, this.notifyPick});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Dismissible(
          direction: userID == notes[index].author.uid ? DismissDirection.endToStart : DismissDirection.none,
          background: Container(color: Colors.red, alignment: Alignment.centerRight, child: Icon(Icons.delete, color: Colors.white)),
          key: Key(notes[index].id),
          onDismissed: (direction) {
            //future builder to deelte a review

            showDialog(
                context: context,
                builder: (context) => FutureBuilder(
                    future: DatabaseService().deleteNote(notes[index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AlertDialog(
                          title: Text("Delete Note"),
                          content: Text("Your note has been deleted"),
                          actions: [
                            TextButton(
                                onPressed: () => {
                                      context.pop(),
                                      notifyParent(),
                                    },
                                child: Text("Ok"))
                          ],
                        );
                      } else {
                        return AlertDialog(
                          title: Text("Delete Note"),
                          content: SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                        );
                      }
                    }));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              color: notes[index].author.uid == userID ? Color.fromARGB(255, 134, 97, 236).withOpacity(0.5) : null,
              child: ListTile(
                  tileColor: Colors.transparent,
                  onTap: () {
                    debugPrint("Note pressed");
                    if (notifyPick != null) {
                      notifyPick!(notes[index]);
                    } else {
                      context.push("/courses/reviews/showNote", extra: notes[index]).then((value) => value == "Modified" ? notifyParent() : null);
                    }
                  },
                  leading: CircleAvatar(backgroundImage: NetworkImage(notes[index].author.imageUrl)),
                  title: Text(notes[index].name, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (notes[index].author.uid != userID) Text("Author: ${notes[index].author.username}"),
                      Text("Last Update: ${notes[index].timestamp.toDate().toString().substring(0, 16)}"),
                      Text("Characters in the description: ${notes[index].description?.length.toString() ?? "0"}"),
                      Text("Number of attachments: ${notes[index].attachmentUrls?.length.toString() ?? "0"}"),
                      SizedBox(height: 13),
                    ],
                  ),
                  trailing: notes[index].author.uid == userID
                      ? notes[index].isShared
                          ? Icon(Icons.public, color: Colors.green)
                          : Icon(Icons.lock_outline_rounded, color: Colors.yellow[900])
                      : null),
            ),
          ),
        );
      },
    );
  }
}
