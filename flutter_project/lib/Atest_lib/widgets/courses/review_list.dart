import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/classes/review_model.dart';

import 'package:dima_project/Atest_lib/services/database_service.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReviewList extends StatelessWidget {
  List<ReviewModel> reviews;
  final String userID = "0123456789";
  final CourseModel course;
  final Function() notifyParent;
  Function(ReviewModel review)? notifyPick;
  ReviewList({super.key, required this.reviews, required this.course, required this.notifyParent, this.notifyPick});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return Dismissible(
          direction: userID == reviews[index].author.uid ? DismissDirection.endToStart : DismissDirection.none,
          background: Container(color: Colors.red, alignment: Alignment.centerRight, child: Icon(Icons.delete, color: Colors.white)),
          key: Key(reviews[index].id),
          onDismissed: (direction) {
            //future builder to deelte a review

            showDialog(
                context: context,
                builder: (context) => FutureBuilder(
                    future: DatabaseService().deleteReview(course, reviews[index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AlertDialog(
                          title: Text("Review"),
                          content: Text("Your review has been deleted"),
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
                          title: Text("Review"),
                          content: SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                        );
                      }
                    }));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              color: reviews[index].author.uid == userID ? Color.fromARGB(255, 134, 97, 236).withOpacity(0.45) : null,
              child: ListTile(
                minLeadingWidth: 15,
                title: Text(reviews[index].name, style: TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text("Written On: ${reviews[index].timestamp.toDate().toString().split(" ")[0]}",
                    style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                //leading: CircleAvatar(backgroundImage: NetworkImage(reviews[index].author.imageUrl)),
                trailing: Text("⭐️ ${reviews[index].evaluation}", style: TextStyle(fontSize: 18)),
                onTap: () {
                  if (notifyPick != null) {
                    notifyPick!(reviews[index]);
                  } else {
                    Navigator.pushNamed(context, "/courses/reviews/showReview");
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
