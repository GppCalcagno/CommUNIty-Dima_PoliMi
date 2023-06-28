import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Open a Review", (tester) async {
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

    final rev = find.byKey(Key("testReview"));
    expect(rev, findsOneWidget);
    await tester.tap(rev);

    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final check = find.byKey(Key("showReview"));
    expect(check, findsOneWidget);
  });

  testWidgets("Write a Review", (tester) async {
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

    final newRev = find.byKey(Key("addReviewButton"));
    expect(newRev, findsOneWidget);
    await tester.tap(newRev);

    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final title = find.byKey(Key('textFiledTitle'));
    expect(title, findsOneWidget);
    await tester.enterText(title, "Test Title");

    final eval = find.byKey(Key('evaluation1'));
    expect(eval, findsOneWidget);
    await tester.tap(eval);
    await Future.delayed(Duration(seconds: 3));

    final forwardButton1 = find.text("Continue").at(0);
    expect(forwardButton1, findsOneWidget);

    await tester.tap(forwardButton1);
    await tester.pumpAndSettle();
    print("first step");

    await Future.delayed(Duration(seconds: 1));

    final forwardButton2 = find.text("Continue").at(1);
    expect(forwardButton2, findsOneWidget);

    await tester.tap(forwardButton2);
    await tester.pumpAndSettle();
    print("second step");

    await Future.delayed(Duration(seconds: 1));

    final forwardButton3 = find.text("Submit").last;
    expect(forwardButton3, findsOneWidget);

    await tester.tap(forwardButton3);
    await tester.pumpAndSettle();
    print("third step");

    await Future.delayed(Duration(seconds: 1));

    final forwardButton4 = find.text("Ok").last;
    expect(forwardButton4, findsOneWidget);

    await tester.tap(forwardButton4);
    await tester.pumpAndSettle();
    print("fourth step");

    await Future.delayed(Duration(seconds: 3));

    final check = find.text("Software Engineering 2");
    expect(check, findsOneWidget);
  });
}
