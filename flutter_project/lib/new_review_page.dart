import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/layout_dimension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dima_project/classes/user_model.dart';

class NewReviewPage extends StatefulWidget {
  final CourseModel course;
  const NewReviewPage({super.key, required this.course});

  @override
  NewReviewPageState createState() => NewReviewPageState();
}

class NewReviewPageState extends State<NewReviewPage> {
  int _currentStep = 0;
  int _evaulation = 0;
  bool _firstStepError = false;
  bool _sent = false;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
        title: const Text('New Review'),
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
                      if (nameController.text.isEmpty || _evaulation == 0) {
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
                            future: generateAndLoadReview(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return AlertDialog(
                                  title: Text("Review"),
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
                                  title: Text("Review"),
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
                      image: AssetImage("assets/newReviewTablet.png"),
                      height: 200,
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
          title: const Text('Title and Evaluation'),
          content: Container(
              //height: 475,
              child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                key: const Key('textFiledTitle'),
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  errorText: _firstStepError ? "Please enter a title and an evaluation" : null,
                  labelText: 'Title',
                  //prefixIcon: Icon(Icons.text_fields),
                ),
              ),
              const SizedBox(height: 50),
              const Text('⭐️ Evaluation ⭐️', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 15),
              Wrap(
                direction: Axis.horizontal,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FloatingActionButton.small(
                      key: Key('evaluation$index'),
                      //https://stackoverflow.com/questions/51125024/there-are-multiple-heroes-that-share-the-same-tag-within-a-subtree
                      heroTag: "btn$index",
                      backgroundColor: _evaulation == index + 1 ? Colors.deepPurpleAccent[100] : Colors.deepPurpleAccent[900],
                      onPressed: () {
                        setState(() {
                          debugPrint("New_Review_Page: Evaluation $index");
                          _evaulation = index + 1;
                        });
                      },
                      child: Text(
                        (index + 1).toString(),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
            ],
          )),
          isActive: _currentStep >= 0,
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          title: const Text('Description'),
          content: Container(
            //height: 475,
            child: Column(
              children: [
                SizedBox(height: 10),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: "Enter an Optional Description for your Review",
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
          title: const Text('Summary'),
          content: SizedBox(
              height: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10),
                  Text(
                    nameController.text,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  //print ⭐️ according to the evaluation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Evaluation: ", style: TextStyle(fontSize: 18)),
                      Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(_evaulation, (index) {
                          return const Icon(Icons.star, color: Colors.yellow);
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  //print description with scrollable view if too long using NestedScrollView
                  Container(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Text(
                        descriptionController.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )),
          isActive: _currentStep >= 2,
        ),
      ];

  Future<bool> generateAndLoadReview() async {
    //done due to a the future in the alert that is called twice without reason
    if (!_sent) {
      debugPrint("New_Review_Page: Generating Review");
      UserModel author = await DatabaseService().getCurrentUser();
      author.position = null;
      String? description = descriptionController.text == "" ? null : descriptionController.text;

      await DatabaseService().addReview(widget.course, nameController.text, _evaulation, description, Timestamp.now(), author);
      debugPrint("New_Review_Page: uploaded Review");

      setState(() {
        _sent = true;
      });
    }

    return true;
  }
}
