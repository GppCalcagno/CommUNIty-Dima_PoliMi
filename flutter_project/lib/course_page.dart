import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/responsive_layout.dart';
import 'package:dima_project/widgets/courses/pages/notes_widget.dart';
import 'package:dima_project/widgets/courses/pages/notes_widget_tablet.dart';
import 'package:dima_project/widgets/courses/pages/review_widget.dart';
import 'package:dima_project/widgets/courses/pages/review_widget_tablet.dart';
import 'package:dima_project/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'layout_dimension.dart';

class CoursePageScreen extends StatelessWidget {
  final CourseModel course;
  const CoursePageScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        resizeToAvoidBottomInset: false,
        drawer: DrawerForNavigation(),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(course.name),
                      content: SizedBox(
                          height: 150,
                          width: MediaQuery.of(context).size.width > limitWidth ? 650 : 360,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(course.description ?? "No description Available"),
                              ],
                            ),
                          )),
                      actions: [
                        TextButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text("📘 Review", style: TextStyle(fontSize: 17, color: Colors.white))),
              Tab(icon: Text("📔 Notes", style: TextStyle(fontSize: 17, color: Colors.white))),
            ],
          ),
          title: Text(course.name),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ResponsiveLayout(mobileBody: ReviewPage(course: course), tabletBody: ReviewPageTablet(course: course)),
            ResponsiveLayout(mobileBody: NoteWidget(course: course), tabletBody: NoteWidgetTablet(course: course)),
          ],
        ),
      ),
    );
  }
}
