import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("log in and Navigate in a Course", (tester) async {
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

    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    //Login Steps Done

    final course = find.text("Software Engineering 2");
    expect(course, findsOneWidget);
    await tester.tap(course);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final check = find.text("Software Engineering 2");
    expect(check, findsOneWidget);
  });

  testWidgets("Logout", (tester) async {
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

    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    //Login Steps Done
    //https://stackoverflow.com/questions/53299088/how-to-open-a-drawer-in-flutter-tests
    await tester.dragFrom(tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final logout = find.text("Logout");
    expect(logout, findsOneWidget);
    await tester.tap(logout);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final check = find.byKey(Key("loginmail"));

    expect(check, findsOneWidget);
  });
}
