import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/note_model.dart';
import 'package:dima_project/layout_dimension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dima_project/classes/user_model.dart';

class ModifyNotePage extends StatefulWidget {
  NoteModel note;
  final DatabaseService dbService = DatabaseService();
  ModifyNotePage({super.key, required this.note});

  @override
  ModifyNotePageState createState() => ModifyNotePageState();
}

class ModifyNotePageState extends State<ModifyNotePage> {
  int _currentStep = 0;
  bool _isSharedNote = false;

  bool _firstStepError = false;
  bool _sent = false;

  List<PlatformFile>? attachments;
  List<String> attachmentsToRemove = [];

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.note.name;
    descriptionController.text = widget.note.description ?? '';
    _isSharedNote = widget.note.isShared;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
        key: Key("modifyNoteAppBar"),
        title: Text('Modify Note ${widget.note.name}'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > limitWidth) SizedBox(width: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width > limitWidth ? TabletWidth - 450 : MediaQuery.of(context).size.width-10,
            child: Stepper(
              //physics: NeverScrollableScrollPhysics(),
              type: StepperType.vertical,
              currentStep: _currentStep,
              steps: getSteps(),
              onStepContinue: () {
                setState(() {
                  if (_currentStep < getSteps().length - 1) {
                    if (_currentStep == 0) {
                      if (nameController.text.isEmpty) {
                        _firstStepError = true;
                      } else {
                        debugPrint("New_Review_Page: Current State $_currentStep");
                        _firstStepError = false;
                        _currentStep += 1;
                      }
                    } else {
                      debugPrint("New_Review_Page: Current State $_currentStep");
                      _currentStep += 1;
                    }
                  } else {
                    debugPrint("New_Review_Page: Last Step Action");

                    //Show alert Dialog
                    showDialog(
                        context: context,
                        builder: (context) => FutureBuilder(
                            future: UpdateReview(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return AlertDialog(
                                  title: Text("Update Note"),
                                  content: Text("Your note has been updated"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => {
                                              context.pop(),
                                              context.pop("Modified"),

                                              //context.push("/courses/selectedcourse", extra: widget.course),
                                            },
                                        child: Text("Ok"))
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: Text("Update Note"),
                                  content: SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                                );
                              }
                            }));
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (_currentStep > 0) {
                    debugPrint("New_Review_Page: Current State $_currentStep");
                    _currentStep -= 1;
                  }
                });
              },
              controlsBuilder: (context, ControlsDetails details) {
                return Container(
                  width: MediaQuery.of(context).size.width > limitWidth ? 500 : null,
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: _currentStep == 2 ? const Text('Submit') : const Text('Continue'),
                        ),
                      ),
                      if (_currentStep > 0) SizedBox(width: 30),
                      if (_currentStep > 0)
                        ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Icon(Icons.arrow_back, size: 22),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
          if (MediaQuery.of(context).size.width > limitWidth)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Image(
                      image: AssetImage("assets/newNoteTablet.png"),
                      height: 220,
                      fit: BoxFit.cover,
                    )),
              ],
            ),
        ],
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          title: const Text('Title & Setting'),
          content: Container(
              //height: 475,
              child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  errorText: _firstStepError ? "Please enter a title" : null,
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 40),
              //add a slider to set _isSharedNote
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Share this note with other students: "),
                  Switch(
                    value: _isSharedNote,
                    onChanged: (value) {
                      debugPrint("New_Review_Page: Switch value changed to $value");
                      setState(() {
                        _isSharedNote = value;
                      });
                    },
                    //activeTrackColor: Colors.lightGreenAccent,
                    //activeColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          )),
          isActive: _currentStep >= 0,
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          title: const Text('Note Text'),
          content: Container(
            //height: 475,
            child: Column(
              children: [
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: "Enter your Notes",
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                      )),

                  minLines: 10,
                  maxLines: 10, // allow user to enter 5 line in textfield
                  keyboardType: TextInputType.multiline, // user keyboard will have a button to move cursor to next line
                  controller: descriptionController,
                ),
              ],
            ),
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: Text("Remove Attachments"),
          content: SizedBox(
              //upload file to firebase storage
              height: 350,
              child: Column(
                children: [
                  //show uploaded files

                  Expanded(
                    child: widget.note.attachmentUrls != null
                        ? ListView.builder(
                            itemCount: widget.note.attachmentUrls?.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(widget.note.attachmentUrls![index].name),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      attachmentsToRemove.add(widget.note.attachmentUrls![index].name);
                                      widget.note.attachmentUrls!.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        : Center(child: Text("No Attachments")),
                  ),
                ],
              )),
          isActive: _currentStep >= 2 && widget.note.attachmentUrls != null,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Row(
            children: [
              Text('Add Attachments'),
              SizedBox(width: 32),
              if (_currentStep > 1)
                FloatingActionButton.small(
                  elevation: 0,
                  child: Icon(Icons.upload_file_outlined),
                  onPressed: () => selectFile(),
                ),
            ],
          ),
          content: SizedBox(
              //upload file to firebase storage
              height: 380,
              child: Column(
                children: [
                  //show uploaded files
                  if (attachments != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: attachments?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(attachments![index].name),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  attachments!.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              )),
          isActive: _currentStep >= 3,
        ),
      ];

  Future<bool> UpdateReview() async {
    //done due to a the future in the alert that is called twice without reason
    if (!_sent) {
      UserModel author = await DatabaseService().getCurrentUser();
      author.position = null;
      String? description = descriptionController.text == "" ? null : descriptionController.text;

      widget.note.name = nameController.text;
      widget.note.description = description;
      widget.note.isShared = _isSharedNote;
      widget.note.timestamp = Timestamp.now();

      await DatabaseService().UpdateNote(widget.note, attachmentsToRemove, attachments);

      setState(() {
        _sent = true;
      });
    }

    return true;
  }

  Future selectFile() async {
    // allowedExtensions: ['pdf', 'png', 'jpg']
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    debugPrint("New_Review_Page: Selected Files: ${result?.files.length ?? 0}");
    setState(() {
      attachments == null ? attachments = result?.files : attachments?.addAll(result?.files as Iterable<PlatformFile>);
      print(attachments?.length);
    });
  }
}
