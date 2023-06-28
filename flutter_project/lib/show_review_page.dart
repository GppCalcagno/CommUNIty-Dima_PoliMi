import 'package:dima_project/classes/review_model.dart';
import 'package:flutter/material.dart';

class ShowReviewPage extends StatelessWidget {
  final ReviewModel? review;
  const ShowReviewPage({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
        title: Text("Review Details"),
      ),
      body: ShowReviewWidget(review: review),
    );
  }
}

class ShowReviewWidget extends StatelessWidget {
  const ShowReviewWidget({
    super.key,
    required this.review,
  });

  final ReviewModel? review;

  @override
  Widget build(BuildContext context) {
    if (review == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            size: 150,
            color: Colors.deepPurple[300],
          ),
          SizedBox(height: 30),
          Text(
            "Select a Review",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 80),
        ],
      );
    }

    return Column(
      key: Key("showReview"),
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          " Title: " + review!.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10),
        //print ⭐️ according to the evaluation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30),
            const Text("Evaluation: ", style: TextStyle(fontSize: 18)),
            Wrap(
              direction: Axis.horizontal,
              children: List.generate(review!.evaluation, (index) {
                return const Icon(Icons.star, color: Colors.yellow);
              }),
            ),
          ],
        ),
        SizedBox(height: 7),

        Text(
          "Written By: ${review!.author.username} on ${review!.timestamp.toDate().toString().split(" ")[0]}",
          style: TextStyle(fontSize: 15),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 15),
        //print description with scrollable view if too long using NestedScrollView
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                review?.description ?? "No description available",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        //add images from assets
        Expanded(child: Image(image: AssetImage("assets/showReviewPic.png"))),
        SizedBox(height: 10),
      ],
    );
  }
}
