import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/responsive_layout.dart';

import 'package:dima_project/Atest_lib/widgets/courses/pages/notes_widget.dart';
import 'package:dima_project/Atest_lib/widgets/courses/pages/notes_widget_tablet.dart';
import 'package:dima_project/Atest_lib/widgets/courses/pages/review_widget.dart';
import 'package:dima_project/Atest_lib/widgets/courses/pages/review_widget_tablet.dart';

import 'package:dima_project/widgets/drawer.dart';
import 'package:flutter/material.dart';

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
          actions: [
            IconButton(
              key: Key("infoButton"),
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(course.name),
                      content: SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(course.description ?? "No description Available"),
                              ],
                            ),
                          )),
                      actions: [
                        TextButton(
                          key: Key("closeInfoButton"),
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
              Tab(icon: Text("✅ Review")),
              Tab(icon: Text("📚 Notes")),
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
