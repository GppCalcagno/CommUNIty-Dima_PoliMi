import 'package:dima_project/Atest_lib/classes/course_model.dart';

import 'package:dima_project/classes/note_model.dart';
import 'package:dima_project/Atest_lib/widgets/courses/note_list.dart';
import 'package:dima_project/Atest_lib/widgets/courses/shownote_tablet.dart';
import 'package:dima_project/Atest_lib/services/database_service.dart';

import 'package:flutter/material.dart';

class NoteWidgetTablet extends StatefulWidget {
  final DatabaseService db = DatabaseService();
  final CourseModel course;
  NoteWidgetTablet({super.key, required this.course});

  @override
  State<NoteWidgetTablet> createState() => _NoteWidgetTabletState();
}

class _NoteWidgetTabletState extends State<NoteWidgetTablet> {
  final userID = "0123456789";
  final dateOrder = ['Newer', 'Older'];
  String selecteddateOrder = 'Newer';

  final privacy = ['My Note', 'My Private Notes', 'My Public Notes', 'CommUNIty Notes'];
  String selecteddPrivacy = 'My Note';

  late Future<List<NoteModel>> NoteList;

  NoteModel? selectedNote;

  @override
  void initState() {
    super.initState();
    NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);

    debugPrint("Course: INIT");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (selectedNote != null && selectedNote!.author.uid == userID)
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                //  debugPrint("FloatingActionButton EDIT pressed");
                //  context.push("/courses/reviews/modifyNote", extra: selectedNote).then((value) => refresh());
              },
              child: Icon(Icons.edit_document),
            ),
          SizedBox(height: 15),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              debugPrint("FloatingActionButton ADD pressed");
              //context.push("/courses/reviews/newNote", extra: widget.course).then((_) => setState(() {
              //      NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);
              //    }));
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15),
              Text("Order By:"),
              SizedBox(width: 10),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    key: Key("dateOrderDropdown"),
                    value: selecteddateOrder,
                    onChanged: (String? newValue) {
                      setState(() {
                        selecteddateOrder = newValue ?? 'Newer';
                        NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);
                      });
                    },
                    items: dateOrder.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(key: Key(value), value: value, child: Text(value));
                    }).toList(),
                  )),
              SizedBox(width: 15),
              Text("Filter:"),
              SizedBox(width: 10),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    key: Key("FilterDropdown"),
                    value: selecteddPrivacy,
                    onChanged: (String? newValue) {
                      setState(() {
                        selecteddPrivacy = newValue ?? 'My Note';
                        NoteList = widget.db.getNotes(widget.course, selecteddateOrder, selecteddPrivacy);
                      });
                    },
                    items: privacy.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(key: Key(value), value: value, child: Text(value));
                    }).toList(),
                  )),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 470,
                  child: FutureBuilder<List<NoteModel>>(
                    future: NoteList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data!.isEmpty) {
                          return Column(
                            key: Key("emptyNotes"),
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
                        return myNoteList(notes: snapshot.data!, course: widget.course, notifyParent: refresh, notifyPick: selectNote);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                SizedBox(
                    width: 730,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0),
                        child: ShowNoteTabletWidget(selectedNote: selectedNote)))
              ],
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

  selectNote(NoteModel note) {
    setState(() {
      selectedNote = note;
    });
  }
}
