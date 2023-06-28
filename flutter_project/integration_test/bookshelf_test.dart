import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Open a Book From a Bookshelf", (tester) async {
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

    final bookshelf = find.text("Bookshelf");
    expect(bookshelf, findsOneWidget);
    await tester.tap(bookshelf);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final book = find.byKey(Key("booklist_item_1"));
    expect(book, findsOneWidget);
    await tester.tap(book);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 1));

    final bookdetail = find.byKey(Key("BookDetailWidget"));
    expect(bookdetail, findsOneWidget);
  });
}
