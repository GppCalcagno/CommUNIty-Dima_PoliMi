import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/note_model.dart';
import 'package:dima_project/widgets/courses/note_list.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoteWidget extends StatefulWidget {
  final DatabaseService db = DatabaseService();
  final CourseModel course;
  NoteWidget({super.key, required this.course});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final dateOrder = ['Newer', 'Older'];
  String selecteddateOrder = 'Newer';

  final privacy = ['My Notes', 'My Private Notes', 'My Public Notes', 'CommUNIty Notes'];
  String selecteddPrivacy = 'My Notes';

  late Future<List<NoteModel>> NoteList;
  @override
  void initState() {
    super.initState();
    NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);

    debugPrint("Course: INIT");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: Key("addNoteButton"),
        onPressed: () {
          debugPrint("FloatingActionButton pressed");
          context.push("/courses/reviews/newNote", extra: widget.course).then((_) => setState(() {
                NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);
              }));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15),
              Text("Order By:", style: TextStyle(color: Colors.deepPurple[400])),
              SizedBox(width: 10),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    value: selecteddateOrder,
                    onChanged: (String? newValue) {
                      setState(() {
                        selecteddateOrder = newValue ?? 'Newer';
                        NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);
                      });
                    },
                    items: dateOrder.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                  )),
              SizedBox(width: 15),
              Text("Filter:", style: TextStyle(color: Colors.deepPurple[400])),
              SizedBox(width: 10),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    value: selecteddPrivacy,
                    onChanged: (String? newValue) {
                      setState(() {
                        selecteddPrivacy = newValue ?? 'My Notes';
                        NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);
                      });
                    },
                    items: privacy.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                  )),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<NoteModel>>(
              future: NoteList,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(image: AssetImage("assets/emptyMyNotes.png"), height: 200, width: 200, fit: BoxFit.cover),
                        SizedBox(height: 30),
                        Text("No Available Notes", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text("Write Your First Note!", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                      ],
                    );
                  }
                  return myNoteList(notes: snapshot.data!, course: widget.course, notifyParent: refresh);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  refresh() {
    setState(() {
      NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);
    });
  }
}
