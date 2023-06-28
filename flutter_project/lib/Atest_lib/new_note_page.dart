import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/Atest_lib/services/database_service.dart';

import 'package:dima_project/layout_dimension.dart';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class NewNotePage extends StatefulWidget {
  final CourseModel course;
  final DatabaseService dbService = DatabaseService();
  NewNotePage({super.key, required this.course});

  @override
  NewNotePageState createState() => NewNotePageState();
}

class NewNotePageState extends State<NewNotePage> {
  int _currentStep = 0;
  bool _isSharedNote = false;

  bool _firstStepError = false;
  bool _sent = false;

  List<PlatformFile>? attachments;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > limitWidth) SizedBox(width: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width > limitWidth ? TabletWidth - 450 : phoneWidth,
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
                        _firstStepError = false;
                        _currentStep += 1;
                      }
                    } else {
                      _currentStep += 1;
                    }
                  } else {
                    /*

                    //Show alert Dialog
                    showDialog(
                        context: context,
                        builder: (context) => FutureBuilder(
                            future: generateAndLoadNote(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return AlertDialog(
                                  title: Text("New Note Upload"),
                                  content: Text("Your review has been created"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => {
                                              context.pop(),
                                              context.pop(),
                                              //context.push("/courses/selectedcourse", extra: widget.course),
                                            },
                                        child: Text("Ok"))
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: Text("New Note Upload"),
                                  content: SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                                );
                              }
                            }));*/
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
                          key: Key('continueOrSubmit'),
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
              key: Key("imageColumn"),
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
                key: Key("TitleForm"),
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
                  key: Key("NoteForm"),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: "Enter your Notes",
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                      )),

                  minLines: 10,
                  maxLines: 15, // allow user to enter 5 line in textfield
                  keyboardType: TextInputType.multiline, // user keyboard will have a button to move cursor to next line
                  controller: descriptionController,
                ),
              ],
            ),
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: Row(
            children: [
              Text('Upload Attachments'),
              SizedBox(width: 32),
              if (_currentStep > 1)
                FloatingActionButton.small(
                    key: Key("UploadButton"),
                    elevation: 0,
                    child: Icon(Icons.upload_file_outlined),
                    onPressed: () => print("select file mock") //selectFile(),
                    ),
            ],
          ),
          content: SizedBox(
              //upload file to firebase storage
              height: 450,
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
          isActive: _currentStep >= 2,
        ),
      ];
/*
  Future<bool> generateAndLoadNote() async {
    //done due to a the future in the alert that is called twice without reason
    if (!_sent) {
  
      UserModel author = await DatabaseService().getCurrentUser();
      author.position = null;
      String? description = descriptionController.text == "" ? null : descriptionController.text;

      await DatabaseService().addNotes(widget.course, nameController.text, _isSharedNote, attachments, description, Timestamp.now(), author);
  
      setState(() {
        _sent = true;
      });
    }

    return true;
  }
    */
/*
  Future selectFile() async {
    // allowedExtensions: ['pdf', 'png', 'jpg']
    
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    debugPrint("New_Review_Page: Selected Files: ${result?.files.length ?? 0}");
    setState(() {
      attachments == null ? attachments = result?.files : attachments?.addAll(result?.files as Iterable<PlatformFile>);
      print(attachments?.length);
    });
    
  }
  */
}
