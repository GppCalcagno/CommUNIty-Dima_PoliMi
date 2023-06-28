import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/Atest_lib/course_page.dart';
import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/Atest_lib/show_review_page.dart';
import 'package:dima_project/classes/review_model.dart';
import 'package:dima_project/classes/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

CourseModel course = CourseModel(
  courseId: "id",
  name: "coursename",
  description: "description",
);

UserModel me = UserModel(uid: "0123456789", username: "me", email: "test1.mail@mail.it", imageUrl: "profilePic2");
ReviewModel rev = ReviewModel(id: "01", name: "review1", evaluation: 5, description: "description1", timestamp: Timestamp.now(), author: me);

MaterialApp app = MaterialApp(
  title: 'Community',
  initialRoute: '/',
  routes: {
    '/': (context) => CoursePageScreen(course: course),
    '/courses/reviews/showReview': (context) => ShowReviewPage(review: rev),
  },
);

void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Render Screen", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final titleFinder = find.text("coursename");
    expect(titleFinder, findsOneWidget);

    final infoButtonFinder = find.byKey(Key("infoButton"));
    expect(infoButtonFinder, findsOneWidget);

    final reviewTabFinder = find.text("✅ Review");
    expect(reviewTabFinder, findsOneWidget);

    final notesTabFinder = find.text("📚 Notes");
    expect(notesTabFinder, findsOneWidget);

    final filterby = find.byKey(Key("evaluationFilterDropdown"));
    expect(filterby, findsOneWidget);

    final orderby = find.byKey(Key("dateOrderDropdown"));
    expect(orderby, findsOneWidget);

    final addrev = find.byType(FloatingActionButton);
    expect(addrev, findsOneWidget);
  });

  testWidgets("Description Info", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final infoButtonFinder = find.byKey(Key("infoButton"));
    expect(infoButtonFinder, findsOneWidget);

    await tester.tap(infoButtonFinder);
    await tester.pumpAndSettle();

    final titleFinder = find.text("description");
    expect(titleFinder, findsOneWidget);
  });

  testWidgets("Evaluation Menu", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final filterby = find.byKey(Key("evaluationFilterDropdown"));
    expect(filterby, findsOneWidget);

    //https://stackoverflow.com/questions/69012695/flutter-how-to-select-dropdownbutton-item-in-widget-test
    final item1 = find.byKey(Key("All Votes")).last;
    expect(item1, findsOneWidget);

    final item2 = find.byKey(Key("1 ⭐️")).last;
    expect(item2, findsOneWidget);

    final item3 = find.byKey(Key("3 ⭐️")).last;
    expect(item3, findsOneWidget);
  });

  testWidgets("Empty List", (tester) async {
    //for testing purpose if the order is "Older" return an empty list,
    //to test all the rendering, otherwise return a list of mock reviews

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final orderby = find.byKey(Key("dateOrderDropdown"));
    expect(orderby, findsOneWidget);

    await tester.tap(orderby);
    await tester.pumpAndSettle();

    //https://stackoverflow.com/questions/69012695/flutter-how-to-select-dropdownbutton-item-in-widget-test
    final Older = find.byKey(Key("Older")).last;
    expect(orderby, findsOneWidget);

    await tester.tap(Older);
    await tester.pumpAndSettle();

    final emptyFinder = find.text("No Available Review");
    expect(emptyFinder, findsOneWidget);
  });

  testWidgets("Show Review", (tester) async {
    //for testing purpose if the order is "Older" return an empty list,
    //to test all the rendering, otherwise return a list of mock reviews

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final noteFinder = find.text("review1");
    expect(noteFinder, findsOneWidget);

    await tester.tap(noteFinder);
    await tester.pumpAndSettle();

    final appbarFinder = find.text("Review Details");
    expect(appbarFinder, findsOneWidget);

    final titleFinder = find.byKey(Key("title"));
    expect(titleFinder, findsOneWidget);

    final evalFinder = find.byKey(Key("evaluation"));
    expect(evalFinder, findsOneWidget);

    final authorFinder = find.byKey(Key("author"));
    expect(authorFinder, findsOneWidget);

    final descriptionFinder = find.byKey(Key("description"));
    expect(descriptionFinder, findsOneWidget);

    final imageFinder = find.byKey(Key("image"));
    expect(imageFinder, findsOneWidget);
  });

  testWidgets("delete a rev", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final course1 = find.text("review1");
    expect(course1, findsOneWidget);

    await tester.drag(course1, Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    final course2 = find.text("review1");
    expect(course2, findsNothing);
  });
}
