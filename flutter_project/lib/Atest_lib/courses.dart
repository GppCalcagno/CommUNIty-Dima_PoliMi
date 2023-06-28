import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/layout_dimension.dart';
import 'package:dima_project/widgets/courses/upper_gradient_picture.dart'; //not to overwrite
import 'package:dima_project/Atest_lib/services/database_service.dart';
import 'package:dima_project/Atest_lib/widgets/courses/courses_lists.dart';

import 'package:dima_project/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  CoursesScreen({super.key, required this.isEmpty});
  final bool isEmpty;

  @override
  State<CoursesScreen> createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  DatabaseService dbService = DatabaseService();
  bool isShortList = true;
  late Future<List<CourseModel>> userCourses;
  List<CourseModel> userCoursesList = [];

  @override
  void initState() {
    super.initState();
    isShortList = true;
    userCourses = dbService.getUserCourses(widget.isEmpty);
    debugPrint("Course: INIT");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        key: const Key('coursesAppBar'),
        elevation: 0,
      ),
      drawer: DrawerForNavigation(),
      body: Column(
        children: <Widget>[
          //widget to have a faided picture with a title
          UpperGradientPicture(height: height, width: width),

          Transform.translate(
            offset: Offset(0.0, -(height * 0.025)),
            child: Container(
              height: 48,
              width: width,
              //padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(isShortList ? "Compact List" : "Extended List",
                          style:
                              TextStyle(color: isShortList ? Colors.deepPurple[500] : Colors.blue[900], fontWeight: FontWeight.w500, fontSize: 20)),
                      SizedBox(width: 10),
                      Switch(
                        key: const Key("switch"),
                        activeColor: Colors.deepPurple[400],
                        inactiveTrackColor: Colors.blue[400],
                        inactiveThumbColor: Colors.blue[900],
                        value: isShortList,
                        onChanged: (bool value) {
                          setState(() {
                            isShortList = value;
                            debugPrint('Course: Change State');
                          });
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 0), () => userCourses), //delay used for testing
              builder: (BuildContext context, snapshot) {
                //snapshot.connectionState != ConnectionState.done used to refresh all time
                if (!snapshot.hasData || snapshot.connectionState != ConnectionState.done) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                } else {
                  userCoursesList = snapshot.data!;

                  if (snapshot.data!.isEmpty) {
                    return Expanded(child: EmptyList());
                  }
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width > limitWidth ? 650 : 390,
                          child: isShortList
                              ? HorizontalList(userCourses: snapshot.data!, notifyParent: refresh)
                              : VerticallList(userCourses: snapshot.data!, notifyParent: refresh),
                        ),
                        if (width > limitWidth)
                          //add beatuful images
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(28.0),
                                child: isShortList
                                    ? Image(
                                        image: AssetImage("assets/pickCourseTablet_viola.png"),
                                        height: 230,
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: AssetImage("assets/pickCourseTablet_blu.png"),
                                        height: 230,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Select a Course From Your List",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                key: Key("tabletImage"),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                }
              }),
          SizedBox(height: 45),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("floatingButton"),
        onPressed: _onTapShowDialog,
        tooltip: 'AddCourse',
        child: const Icon(Icons.add),
      ),
    );
  }

  refresh() {
    setState(() {
      userCourses = dbService.getUserCourses(widget.isEmpty);
    });
  }

  _onTapShowDialog() {
    debugPrint("Course: Add Course");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Course'),
            content: FutureBuilder(
              future: DatabaseService().getAllCourse(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 300.0, // Chan,ge as per your requirement
                    width: 300.0, // Change as per your requirement
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          title: Text(snapshot.data[index].name),
                          enabled: !userCoursesList.any(((element) => element.courseId.endsWith(snapshot.data[index].courseId))),
                          splashColor: isShortList ? Colors.deepPurple[100] : Colors.blue[100],
                          onTap: () => {
                            DatabaseService().addUserCourse(snapshot.data[index].courseId),
                            Navigator.of(context).pop(),
                            setState(() {
                              userCourses = dbService.getUserCourses(widget.isEmpty);
                            }),
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 200.0, // Change as per your requirement
                    width: 300.0,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        });
  }
}
