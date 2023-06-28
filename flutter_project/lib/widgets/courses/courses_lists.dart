import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                          content: Text("Your course has been detached"),
                          actions: [
                            TextButton(
                                onPressed: () => {
                                      context.pop(),
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
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: SizedBox(
              height: 170,
              child: Card(
                elevation: 3,
                color: Color.fromARGB(255, 37, 113, 200).withOpacity(0.8),
                child: ListTile(
                  title: Text(
                    userCourses[index].name,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    userCourses[index].description ?? "",
                    style: TextStyle(color: Colors.grey[200], fontSize: 14, fontWeight: FontWeight.w400),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => context.go("/courses/selectedcourse", extra: userCourses[index]),
                ),
              ),
            ),
          )

          /*
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 37, 113, 200).withOpacity(0.8),
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
            onTap: () => context.go("/courses/selectedcourse", extra: userCourses[index]),
          ),
        ),
        */
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
      scrollDirection: Axis.vertical,
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
                          content: Text("Your course has been detached"),
                          actions: [
                            TextButton(
                                onPressed: () => {
                                      context.pop(),
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
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
              elevation: 3,
              color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
              child: ListTile(
                title: Text(
                  userCourses[index].name,
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
                onTap: () => context.go("/courses/selectedcourse", extra: userCourses[index]),
              ),
            ),
          )

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
