import 'package:dima_project/classes/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  // TO TEST THIS FILE RUN THIS COMMAND IN THE TERMINAL
  // flutter drive --driver=integration_test/grant_permission.dart --target=integration_test/network_test.dart
  testWidgets("Share your position", (tester) async {
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

    //Login Steps Done
    //https://stackoverflow.com/questions/53299088/how-to-open-a-drawer-in-flutter-tests
    await tester.dragFrom(tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final settings = find.text("Network");
    expect(settings, findsOneWidget);
    await tester.tap(settings);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final sharePosition = find.byTooltip("Share your position");
    expect(sharePosition, findsOneWidget);
    await tester.tap(sharePosition);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));

    final descriptionField = find.byType(TextFormField);
    expect(descriptionField, findsOneWidget);
    await tester.enterText(descriptionField, "Test description");
    
    await Future.delayed(Duration(seconds: 2));

    final courseDropdown = find.byType(DropdownButtonFormField<CourseModel>);
    expect(courseDropdown, findsOneWidget);
    await tester.tap(courseDropdown);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 1));

    final selectedCourse = find.text("Software Engineering 2").last;
    expect(selectedCourse, findsOneWidget);
    await tester.tap(selectedCourse);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 1));

    final shareButton = find.text('SHARE');
    expect(shareButton, findsOneWidget);
    await tester.tap(shareButton);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));

    final snack = find.byType(SnackBar); // find snackbar with success message
    expect(snack, findsOneWidget);

    await Future.delayed(Duration(seconds: 3));

    // Logout
    /*await tester.dragFrom(tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final logout = find.text("Logout");
    expect(logout, findsOneWidget);
    await tester.tap(logout);
    await tester.pumpAndSettle();*/

  });

    testWidgets("Open map", (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 5));

    /*final emailForm = find.byKey(Key("loginmail"));

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

    //Login Steps Done
    //https://stackoverflow.com/questions/53299088/how-to-open-a-drawer-in-flutter-tests
    await tester.dragFrom(tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final settings = find.text("Network");
    expect(settings, findsOneWidget);
    await tester.tap(settings);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));*/

    final listFinder = find.byType(Scrollable);
    final selectedPosition = find.text('test1'); // find user test1
    // Scroll until the item to be found appears.
    await tester.scrollUntilVisible(
      selectedPosition,
      500.0,
      scrollable: listFinder,
    );
    
    await Future.delayed(Duration(seconds: 5));

    expect(selectedPosition, findsOneWidget);
    await tester.tap(selectedPosition);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));

    final userAddress = find.byType(Card);
    expect(userAddress, findsAtLeastNWidgets(1));

    await Future.delayed(Duration(seconds: 3));

  });


}
