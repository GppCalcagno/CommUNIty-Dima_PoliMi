import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/Atest_lib/new_review_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

CourseModel course = CourseModel(
  courseId: "id",
  name: "coursename",
  description: "description",
);

MaterialApp app = MaterialApp(
  title: 'Community',
  initialRoute: '/',
  routes: {
    '/': (context) => NewReviewPage(course: course),
    //'': (context) => Widget(selectedNote: note),
  },
);

void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Add Review Phone", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final appbarFinder = find.text("New Review");
    expect(appbarFinder, findsOneWidget);

    final titleFinder = find.text("Title and Evaluation");
    expect(titleFinder, findsOneWidget);

    final titleForm = find.byKey(Key("TitleForm"));
    expect(titleForm, findsOneWidget);

    await tester.enterText(titleForm, "fakeTitle");

    final evaluationForm = find.byKey(Key("btn2"));
    expect(evaluationForm, findsOneWidget);

    await tester.tap(evaluationForm);

    final continueFinder = find.byKey(Key('continueOrSubmit')).at(0);
    expect(continueFinder, findsOneWidget);
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    final descriptionFinder = find.text("Description");
    expect(descriptionFinder, findsOneWidget);

    final descriptionForm = find.byKey(Key("DescriptionForm"));
    expect(descriptionForm, findsOneWidget);
    await tester.enterText(descriptionForm, "fakeDescription");

    final continueFinder2 = find.byKey(Key('continueOrSubmit')).at(1);
    expect(continueFinder2, findsOneWidget);

    await tester.tap(continueFinder2);
    await tester.pumpAndSettle();

    final check1 = find.text("fakeTitle");
    expect(check1, findsAtLeastNWidgets(1));

    final check2 = find.text("fakeDescription");
    expect(check2, findsAtLeastNWidgets(1));
  });

  testWidgets("No title or Vote", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final continueFinder = find.byKey(Key('continueOrSubmit')).first;
    expect(continueFinder, findsOneWidget);
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    final check = find.text("Please enter a title and an evaluation");
    expect(check, findsOneWidget);
  });

  testWidgets("Go Back", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final titleForm = find.byKey(Key("TitleForm"));
    expect(titleForm, findsOneWidget);

    await tester.enterText(titleForm, "fakeTitle");

    final evaluationForm = find.byKey(Key("btn2"));
    expect(evaluationForm, findsOneWidget);

    await tester.tap(evaluationForm);

    final continueFinder = find.byKey(Key('continueOrSubmit')).at(0);
    expect(continueFinder, findsOneWidget);
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    final goback = find.byIcon(Icons.arrow_back).at(1);
    expect(goback, findsOneWidget);

    await tester.tap(goback);
    await tester.pumpAndSettle();

    final titleForm1 = find.byKey(Key("TitleForm"));
    expect(titleForm1, findsOneWidget);
  });

  testWidgets("Add Review Tablet", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final appbarFinder = find.text("New Review");
    expect(appbarFinder, findsOneWidget);

    final image = find.byKey(Key("imageColumn"));
    expect(image, findsOneWidget);

    final titleFinder = find.text("Title and Evaluation");
    expect(titleFinder, findsOneWidget);

    final titleForm = find.byKey(Key("TitleForm"));
    expect(titleForm, findsOneWidget);

    await tester.enterText(titleForm, "fakeTitle");

    final evaluationForm = find.byKey(Key("btn2"));
    expect(evaluationForm, findsOneWidget);

    await tester.tap(evaluationForm);

    final continueFinder = find.byKey(Key('continueOrSubmit')).at(0);
    expect(continueFinder, findsOneWidget);
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    final descriptionFinder = find.text("Description");
    expect(descriptionFinder, findsOneWidget);

    final descriptionForm = find.byKey(Key("DescriptionForm"));
    expect(descriptionForm, findsOneWidget);
    await tester.enterText(descriptionForm, "fakeDescription");

    final continueFinder2 = find.byKey(Key('continueOrSubmit')).at(1);
    expect(continueFinder2, findsOneWidget);

    await tester.tap(continueFinder2);
    await tester.pumpAndSettle();

    final check1 = find.text("fakeTitle");
    expect(check1, findsAtLeastNWidgets(1));

    final check2 = find.text("fakeDescription");
    expect(check2, findsAtLeastNWidgets(1));
  });
}
