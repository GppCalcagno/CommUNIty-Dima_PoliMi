import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/show_review_page.dart';
import 'package:dima_project/widgets/courses/review_list.dart';
import 'package:flutter/material.dart';

import 'package:dima_project/classes/review_model.dart';
import 'package:go_router/go_router.dart';

class ReviewPageTablet extends StatefulWidget {
  final CourseModel course;
  const ReviewPageTablet({super.key, required this.course});

  @override
  State<ReviewPageTablet> createState() => _ReviewPageTabletState();
}

class _ReviewPageTabletState extends State<ReviewPageTablet> {
  final evaluationFilter = ['All Votes', '1 ⭐️', '2 ⭐️', '3 ⭐️', '4 ⭐️', '5 ⭐️'];
  String selectedevaluationFilter = 'All Votes';
  int selectedevaluationNumber = 0;

  final dateOrder = ['Newer', 'Older'];
  String selecteddateOrder = 'Newer';

  final DatabaseService db = DatabaseService();

  ReviewModel? selectedReview;
  bool isEmpty = false;

  late Future<List<ReviewModel>> reviews;

  @override
  void initState() {
    super.initState();
    reviews = db.getReviews(widget.course, selecteddateOrder, selectedevaluationNumber);
    debugPrint("Course: INIT\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        key: Key("addReviewButton"),
        onPressed: () {
          context.push("/courses/reviews/newReview", extra: widget.course).then((_) => setState(() {
                reviews = db.getReviews(widget.course, selecteddateOrder, selectedevaluationNumber);
              }));
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            //Icon(Icons.filter_list),
            //SizedBox(width: 10),
            Text("Order By:", style: TextStyle(color: Colors.deepPurple[400])),
            SizedBox(width: 10),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10),
                  value: selecteddateOrder,
                  onChanged: (String? newValue) {
                    setState(() {
                      selecteddateOrder = newValue ?? 'Newer';
                      reviews = db.getReviews(widget.course, selecteddateOrder, selectedevaluationNumber);
                    });
                  },
                  items: dateOrder.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                )),
            SizedBox(width: 20),
            Text("Filter:", style: TextStyle(color: Colors.deepPurple[400])),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                value: selectedevaluationFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedevaluationFilter = newValue ?? 'All Votes';
                    selectedevaluationNumber = selectedevaluationFilter != 'All Votes' ? int.parse(selectedevaluationFilter[0]) : 0;

                    reviews = db.getReviews(widget.course, selecteddateOrder, selectedevaluationNumber);
                  });
                },
                items: evaluationFilter.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 470,
                child: FutureBuilder<List<ReviewModel>>(
                  future: reviews,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(image: AssetImage("assets/emptyReviews.png"), height: 200, width: 200, fit: BoxFit.cover),
                            SizedBox(height: 30),
                            Text("No Available Review", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                            SizedBox(height: 10),
                            Text("Be the First to share your Opinion!", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                          ],
                        );
                      }

                      return ReviewList(reviews: snapshot.data!, course: widget.course, notifyParent: refresh, notifyPick: selectReview);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              SizedBox(
                width: 730,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0),
                  child: ShowReviewWidget(review: selectedReview),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  refresh() {
    setState(() {
      reviews = db.getReviews(widget.course, selecteddateOrder, selectedevaluationNumber);
    });
  }

  selectReview(ReviewModel review) {
    setState(() {
      selectedReview = review;
    });
  }
}
