import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Open a Note", (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    //test@mail.it
    //password
    final emailForm = find.byKey(Key("loginmail"));

    expect(emailForm, findsOneWidget);

    final passwordForm = find.byKey(Key("loginpassword"));
    expect(passwordForm, findsOneWidget);

    await tester.enterText(emailForm, "testmail@mail.it");
    await tester.enterText(passwordForm, "password");

    final loginButton = find.byKey(Key("signInButton"));
    expect(loginButton, findsOneWidget);

    //Login Steps Done

    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    final course = find.text("Software Engineering 2");
    expect(course, findsOneWidget);
    await tester.tap(course);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final couse = find.text("Software Engineering 2");
    expect(couse, findsOneWidget);

    final notePage = find.text("📚 Notes");
    expect(notePage, findsOneWidget);
    await tester.tap(notePage);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final note = find.text("testNote");
    expect(note, findsOneWidget);

    await tester.tap(note);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    expect(find.byKey(Key("ShowNotetWidget")), findsOneWidget);
  });

  testWidgets("Edit a Note", (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    //test@mail.it
    //password
    final emailForm = find.byKey(Key("loginmail"));

    expect(emailForm, findsOneWidget);

    final passwordForm = find.byKey(Key("loginpassword"));
    expect(passwordForm, findsOneWidget);

    await tester.enterText(emailForm, "testmail@mail.it");
    await tester.enterText(passwordForm, "password");

    final loginButton = find.byKey(Key("signInButton"));
    expect(loginButton, findsOneWidget);

    //Login Steps Done

    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    final course = find.text("Software Engineering 2");
    expect(course, findsOneWidget);
    await tester.tap(course);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final couse = find.text("Software Engineering 2");
    expect(couse, findsOneWidget);

    final notePage = find.textContaining(" Notes");
    expect(notePage, findsOneWidget);
    await tester.tap(notePage);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final note = find.text("testNote");
    expect(note, findsOneWidget);

    await tester.tap(note);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final editButton = find.byKey(Key("editNoteButton"));
    expect(editButton, findsOneWidget);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));

    final title = find.byKey(Key("modifyNoteAppBar"));
    expect(title, findsOneWidget);
  });

  testWidgets("Write a Note", (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    final emailForm = find.byKey(Key("loginmail"));

    expect(emailForm, findsOneWidget);

    final passwordForm = find.byKey(Key("loginpassword"));
    expect(passwordForm, findsOneWidget);

    await tester.enterText(emailForm, "testmail@mail.it");
    await tester.enterText(passwordForm, "password");

    final loginButton = find.byKey(Key("signInButton"));
    expect(loginButton, findsOneWidget);

    //Login Steps Done

    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    final course = find.text("Software Engineering 2");
    expect(course, findsOneWidget);
    await tester.tap(course);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final couse = find.text("Software Engineering 2");
    expect(couse, findsOneWidget);

    final notePage = find.textContaining(" Notes");
    expect(notePage, findsOneWidget);
    await tester.tap(notePage);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final addButton = find.byKey(Key("addNoteButton"));
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));

    final title = find.byKey(Key("titleField"));
    expect(title, findsOneWidget);
    await tester.enterText(title, "testaddNote");
    await Future.delayed(Duration(seconds: 1));

    final forwardButton1 = find.text("Continue").at(0);
    expect(forwardButton1, findsOneWidget);
    await tester.tap(forwardButton1);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 1));

    final forwardButton2 = find.text("Continue").at(1);
    expect(forwardButton2, findsOneWidget);
    await tester.tap(forwardButton2);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 1));

    final forwardButton3 = find.text("Submit").last;
    expect(forwardButton3, findsOneWidget);
    await tester.tap(forwardButton3);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));
    final forwardButton4 = find.text("Ok").last;
    expect(forwardButton4, findsOneWidget);

    await tester.tap(forwardButton4);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final check = find.text("Software Engineering 2");
    expect(check, findsOneWidget);
  });
}
