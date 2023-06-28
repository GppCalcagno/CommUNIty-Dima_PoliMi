import 'package:dima_project/Atest_lib/login_page.dart';
import 'package:dima_project/Atest_lib/courses.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

MaterialApp app = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => const LoginScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/courses': (context) => CoursesScreen(isEmpty: true),
  },
);

void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Login Empty Input", (tester) async {
    //build the widget

    await tester.pumpWidget(app);

    //find the widget
    final emailField = find.byKey(const Key("mail"));
    expect(emailField, findsOneWidget);

    final passwordField = find.byKey(const Key("password"));
    expect(passwordField, findsOneWidget);

    final button = find.byKey(const Key("signInButton"));
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(find.text("Please enter your email"), findsOneWidget);
    expect(find.text("Please enter your Password"), findsOneWidget);
  });

  testWidgets("login WIth Correct Input", (tester) async {
    await tester.pumpWidget(app);

    //find the widget
    final emailField = find.byKey(const Key("mail"));
    expect(emailField, findsOneWidget);

    final passwordField = find.byKey(const Key("password"));
    expect(passwordField, findsOneWidget);

    final button = find.byKey(const Key("signInButton"));
    expect(button, findsOneWidget);

    await tester.enterText(emailField, "testmail@mail.it");
    await tester.enterText(passwordField, "password");

    var enteredText = tester.widget<TextFormField>(emailField).controller!.text;
    expect(enteredText, "testmail@mail.it");

    await tester.tap(button);
    //Quando c'è un future
    //https://stackoverflow.com/questions/42448410/how-can-i-run-a-unit-test-when-the-tapped-widget-launches-a-timer
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final courseScreen = find.byKey(const Key("coursesAppBar"));
    expect(courseScreen, findsOneWidget);
  });

  testWidgets("Forget Password", (WidgetTester tester) async {
    await tester.pumpWidget(app);

    //find the widget
    final button = find.text("Forgot Password?");
    expect(button, findsOneWidget);

    await tester.tap(button);
    //Quando c'è un future
    //https://stackoverflow.com/questions/42448410/how-can-i-run-a-unit-test-when-the-tapped-widget-launches-a-timer
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final dialog = find.text("Don't Worry!");
    expect(dialog, findsOneWidget);
  });

  testWidgets("Registration With Empty Input", (WidgetTester tester) async {
    await tester.pumpWidget(app);

    final regbutton = find.text("No Account? Sign Up");
    expect(regbutton, findsOneWidget);

    await tester.tap(regbutton);
    await tester.pump();

    //find the widget
    final emailField = find.byKey(const Key("reg_mail"));
    expect(emailField, findsOneWidget);

    final passwordField = find.byKey(const Key("reg_pass"));
    expect(passwordField, findsOneWidget);

    final button = find.byKey(const Key("reg_btn"));
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Please enter your email"), findsOneWidget);
    expect(find.text("Please enter your Password"), findsOneWidget);
  });

  testWidgets("Registration With Wrong Input", (WidgetTester tester) async {
    await tester.pumpWidget(app);

    final regbutton = find.text("No Account? Sign Up");
    expect(regbutton, findsOneWidget);

    await tester.tap(regbutton);
    await tester.pump();

    //find the widget
    final emailField = find.byKey(const Key("reg_mail"));
    expect(emailField, findsOneWidget);

    final passwordField = find.byKey(const Key("reg_pass"));
    expect(passwordField, findsOneWidget);

    final button = find.byKey(const Key("reg_btn"));
    expect(button, findsOneWidget);

    await tester.enterText(emailField, "test");
    await tester.enterText(passwordField, "pass");

    var enteredTextmail = tester.widget<TextFormField>(emailField).controller!.text;
    expect(enteredTextmail, "test");

    var enteredText = tester.widget<TextFormField>(passwordField).controller!.text;
    expect(enteredText, "pass");

    final icons = find.byIcon(Icons.close);
    expect(icons, findsNWidgets(2));
  });

  testWidgets("Registration With Correct Input", (WidgetTester tester) async {
    await tester.pumpWidget(app);

    final image = find.byKey(const Key("loginImage"));
    expect(image, findsNothing);

    final regbutton = find.text("No Account? Sign Up");
    expect(regbutton, findsOneWidget);

    await tester.tap(regbutton);
    await tester.pump();

    //find the widget
    final emailField = find.byKey(const Key("reg_mail"));
    expect(emailField, findsOneWidget);

    final passwordField = find.byKey(const Key("reg_pass"));
    expect(passwordField, findsOneWidget);

    final button = find.byKey(const Key("reg_btn"));
    expect(button, findsOneWidget);

    await tester.enterText(emailField, "gpp.calcagno@gmail.com");
    await tester.enterText(passwordField, "password1");

    var enteredTextmail = tester.widget<TextFormField>(emailField).controller!.text;
    expect(enteredTextmail, "gpp.calcagno@gmail.com");

    var enteredText = tester.widget<TextFormField>(passwordField).controller!.text;
    expect(enteredText, "password1");
    await tester.pump();

    final email_icon = find.byKey(const Key("reg_email_check"));
    expect(email_icon, findsOneWidget);
    final pass_icon = find.byKey(const Key("reg_pass_check"));
    expect(pass_icon, findsOneWidget);

    final icons = find.byIcon(Icons.check);
    expect(icons, findsNWidgets(2));

    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final courseScreen = find.byKey(const Key("coursesAppBar"));
    expect(courseScreen, findsOneWidget);
  });
}
