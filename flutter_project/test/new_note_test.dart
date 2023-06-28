import 'package:dima_project/Atest_lib/classes/course_model.dart';

import 'package:dima_project/Atest_lib/new_note_page.dart';
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
    '/': (context) => NewNotePage(course: course),
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

    final appbarFinder = find.text("New Note");
    expect(appbarFinder, findsOneWidget);

    final titleFinder = find.text("Title & Setting");
    expect(titleFinder, findsOneWidget);

    final titleForm = find.byKey(Key("TitleForm"));
    expect(titleForm, findsOneWidget);

    await tester.enterText(titleForm, "fakeTitle");

    final isShared = find.byType(Switch);
    expect(isShared, findsOneWidget);

    //test the switch of the shared\private note
    await tester.tap(isShared);
    await tester.pumpAndSettle();

    final noteText = find.text("Note Text");
    expect(noteText, findsOneWidget);

    final noteFormFinder = find.byKey(Key("NoteForm"));
    expect(noteFormFinder, findsOneWidget);

    await tester.enterText(noteFormFinder, "fakeNote");

    final UploadAtts = find.text("Upload Attachments");
    expect(UploadAtts, findsOneWidget);

    final continueFinder = find.byKey(Key('continueOrSubmit'));
    expect(continueFinder, findsAtLeastNWidgets(3));
  });

  testWidgets("No Title", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final appbarFinder = find.text("New Note");
    expect(appbarFinder, findsOneWidget);

    final titleFinder = find.text("Title & Setting");
    expect(titleFinder, findsOneWidget);

    final titleForm = find.byKey(Key("TitleForm"));
    expect(titleForm, findsOneWidget);

    final continueFinder = find.byKey(Key('continueOrSubmit'));
    expect(continueFinder, findsAtLeastNWidgets(3));

    await tester.tap(continueFinder.at(0));
    await tester.pumpAndSettle();

    final check = find.text("Please enter a title");
    expect(check, findsOneWidget);
  });

  testWidgets("Go Back", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final appbarFinder = find.text("New Note");
    expect(appbarFinder, findsOneWidget);

    final titleFinder = find.text("Title & Setting");
    expect(titleFinder, findsOneWidget);

    final titleForm = find.byKey(Key("TitleForm"));
    expect(titleForm, findsOneWidget);

    await tester.enterText(titleForm, "fakeTitle");

    final continueFinder = find.byKey(Key('continueOrSubmit'));
    expect(continueFinder, findsAtLeastNWidgets(3));

    await tester.tap(continueFinder.at(0));
    await tester.pumpAndSettle();

    final check = find.text("Please enter a title");
    expect(check, findsNothing);

    final goback = find.byIcon(Icons.arrow_back).at(1);
    expect(goback, findsOneWidget);

    await tester.tap(goback);
    await tester.pumpAndSettle();

    final titleFinder1 = find.text("Title & Setting");
    expect(titleFinder1, findsOneWidget);
  });

  testWidgets("Add Review Tablet", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final image = find.byKey(Key("imageColumn"));
    expect(image, findsOneWidget);

    final appbarFinder = find.text("New Note");
    expect(appbarFinder, findsOneWidget);

    final titleFinder = find.text("Title & Setting");
    expect(titleFinder, findsOneWidget);

    final titleForm = find.byKey(Key("TitleForm"));
    expect(titleForm, findsOneWidget);

    await tester.enterText(titleForm, "fakeTitle");

    final isShared = find.byType(Switch);
    expect(isShared, findsOneWidget);

    final noteText = find.text("Note Text");
    expect(noteText, findsOneWidget);

    final noteFormFinder = find.byKey(Key("NoteForm"));
    expect(noteFormFinder, findsOneWidget);

    await tester.enterText(noteFormFinder, "fakeNote");

    final UploadAtts = find.text("Upload Attachments");
    expect(UploadAtts, findsOneWidget);

    final continueFinder = find.byKey(Key('continueOrSubmit'));
    expect(continueFinder, findsAtLeastNWidgets(3));
  });
}
