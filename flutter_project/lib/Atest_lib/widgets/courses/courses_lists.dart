import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/Atest_lib/services/database_service.dart';
import 'package:flutter/material.dart';

class VerticallList extends StatelessWidget {
  final List<CourseModel> userCourses;

  final Function() notifyParent;
  VerticallList({super.key, required this.userCourses, required this.notifyParent});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userCourses.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => Dismissible(
        background: Container(color: Colors.red, alignment: Alignment.centerRight, child: Icon(Icons.delete, color: Colors.white)),
        key: Key(userCourses[index].courseId),
        onDismissed: (direction) {
          //future builder to deelte a review
          showDialog(
              context: context,
              builder: (context) => FutureBuilder(
                  future: DatabaseService().removeUserCourse(userCourses[index].courseId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return AlertDialog(
                        title: Text("Courses"),
                        content: Text("Your Courses has been detached"),
                        actions: [
                          TextButton(
                              onPressed: () => {
                                    Navigator.pop(context),
                                    notifyParent(),
                                    //context.push("/courses/selectedcourse", extra: widget.course),
                                  },
                              child: Text("Ok"))
                        ],
                      );
                    } else {
                      return AlertDialog(
                        title: Text("Courses"),
                        content: SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                      );
                    }
                  }));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue[800],
          ),
          height: 170,
          margin: EdgeInsets.all(5),
          child: ListTile(
            title: Text(
              userCourses[index].name,
              style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              userCourses[index].description ?? "",
              style: TextStyle(color: Colors.grey[200], fontSize: 14, fontWeight: FontWeight.w400),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => print("go to the course page"),
          ),
        ),
      ),
    );
  }
}

class HorizontalList extends StatelessWidget {
  final List<CourseModel> userCourses;
  final Function() notifyParent;
  HorizontalList({super.key, required this.userCourses, required this.notifyParent});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userCourses.length,
      itemBuilder: (context, index) => Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(color: Colors.red, alignment: Alignment.centerRight, child: Icon(Icons.delete, color: Colors.white)),
        key: Key(userCourses[index].courseId),
        onDismissed: (direction) {
          //future builder to deelte a review

          showDialog(
              context: context,
              builder: (context) => FutureBuilder(
                  future: DatabaseService().removeUserCourse(userCourses[index].courseId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return AlertDialog(
                        title: Text("Courses"),
                        content: Text("Your Courses has been detached"),
                        actions: [
                          TextButton(
                              onPressed: () => {
                                    Navigator.pop(context),
                                    notifyParent(),
                                    //context.push("/courses/selectedcourse", extra: widget.course),
                                  },
                              child: Text("Ok"))
                        ],
                      );
                    } else {
                      return AlertDialog(
                        title: Text("Courses"),
                        content: SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                      );
                    }
                  }));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepPurple[400],
          ),
          //height: 450,
          //width: 250,
          margin: EdgeInsets.all(5),
          child: ListTile(
              title: Text(
                userCourses[index].name,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () => print("go to the course page")),
        ),
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Image(image: AssetImage("assets/emptyList.png"), height: 200, width: 200, fit: BoxFit.cover),
        SizedBox(height: 30),
        Text("Select a Course !", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
