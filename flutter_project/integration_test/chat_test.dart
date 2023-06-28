import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Send a message in a group chat", (tester) async {
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

    final chat = find.text("Chat");
    expect(chat, findsOneWidget);
    await tester.tap(chat);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 3));

    final group = find.text("Software Engineering 2");
    expect(group, findsOneWidget);
    await tester.tap(group);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));

    final inputText = find.byKey(Key("inputText"));
    expect(inputText, findsOneWidget);
    await tester.enterText(inputText, "test message");
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));

    final sendButton = find.byKey(Key("sendButton"));
    expect(sendButton, findsOneWidget);
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 5));
  });
}
