import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/Atest_lib/course_page.dart';
import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/classes/note_model.dart';

import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/Atest_lib/show_note_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

CourseModel course = CourseModel(
  courseId: "id",
  name: "coursename",
  description: "description",
);

UserModel me = UserModel(uid: "0123456789", username: "me", email: "test1.mail@mail.it", imageUrl: "profilePic2");
NoteModel note = NoteModel(id: "01", courseId: "id", name: "rev1", isShared: true, timestamp: Timestamp.now(), author: me);

MaterialApp app = MaterialApp(
  title: 'Community',
  initialRoute: '/',
  routes: {
    '/': (context) => CoursePageScreen(course: course),
    '/courses/reviews/showNote': (context) => ShowNotePage(selectedNote: note),
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

    final notesTabFinder = find.text("📚 Notes");
    expect(notesTabFinder, findsOneWidget);

    await tester.tap(notesTabFinder);
    await tester.pumpAndSettle();

    final filterby = find.byKey(Key("FilterDropdown"));
    expect(filterby, findsOneWidget);

    final orderby = find.byKey(Key("dateOrderDropdown"));
    expect(orderby, findsOneWidget);

    final addnote = find.byType(FloatingActionButton);
    expect(addnote, findsOneWidget);
  });

  testWidgets("Filter  Menu", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final notesTabFinder = find.text("📚 Notes");
    expect(notesTabFinder, findsOneWidget);

    await tester.tap(notesTabFinder);
    await tester.pumpAndSettle();

    final filterby = find.byKey(Key("FilterDropdown"));
    expect(filterby, findsOneWidget);

    //https://stackoverflow.com/questions/69012695/flutter-how-to-select-dropdownbutton-item-in-widget-test
    final item1 = find.byKey(Key("My Note")).last;
    expect(item1, findsOneWidget);

    final item2 = find.byKey(Key("My Private Notes")).last;
    expect(item2, findsOneWidget);

    final item3 = find.byKey(Key("CommUNIty Notes")).last;
    expect(item3, findsOneWidget);
  });

  testWidgets("Empty List Note", (tester) async {
    //for testing purpose if the order is "Older" return an empty list,
    //to test all the rendering, otherwise return a list of mock reviews
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final notesTabFinder = find.text("📚 Notes");
    expect(notesTabFinder, findsOneWidget);

    await tester.tap(notesTabFinder);
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

    final emptyFinder = find.text("No Available Notes");
    expect(emptyFinder, findsOneWidget);
  });

  testWidgets("Show Note", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final notesTabFinder = find.text("📚 Notes");
    expect(notesTabFinder, findsOneWidget);

    await tester.tap(notesTabFinder);
    await tester.pumpAndSettle();

    final noteFinder = find.text("note1");
    expect(noteFinder, findsOneWidget);

    await tester.tap(noteFinder);
    await tester.pumpAndSettle();

    final title = find.byKey(Key("title"));
    expect(title, findsOneWidget);

    final info = find.byKey(Key("information"));
    expect(info, findsOneWidget);

    final atts = find.byKey(Key("noAttachments"));
    expect(atts, findsOneWidget);
  });

  testWidgets("delete a note", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final notesTabFinder = find.text("📚 Notes");
    expect(notesTabFinder, findsOneWidget);

    await tester.tap(notesTabFinder);
    await tester.pumpAndSettle();

    final course1 = find.text("note1");
    expect(course1, findsOneWidget);

    await tester.drag(course1, Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    final course2 = find.text("note1");
    expect(course2, findsNothing);
  });
}
