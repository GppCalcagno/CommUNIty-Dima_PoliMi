import 'package:dima_project/Atest_lib/courses.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

MaterialApp appTrue = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => CoursesScreen(isEmpty: true),
  },
);

MaterialApp appFalse = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => CoursesScreen(isEmpty: false),
  },
);

void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("No Courses", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    //build the widget
    await tester.pumpWidget(appTrue);
    await tester.pumpAndSettle();

    final name = find.byKey(Key("richtext"));
    expect(name, findsOneWidget);

    //find the widget
    final noCourses = find.text("Select a Course !");
    expect(noCourses, findsOneWidget);
  });

  testWidgets("With Courses Present", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    //build the widget

    await tester.pumpWidget(appFalse);
    await tester.pumpAndSettle();

    final image = find.text("Select a Course From Your List");
    expect(image, findsOneWidget);

    //find the widget
    final noCourses = find.text("Select a Course !");
    expect(noCourses, findsNothing);

    final course1 = find.text("first");
    expect(course1, findsOneWidget);
  });

  testWidgets("Check all Type of List", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    //build the widget

    await tester.pumpWidget(appFalse);
    await tester.pumpAndSettle();

    final image = find.text("Select a Course From Your List");
    expect(image, findsOneWidget);

    final course1 = find.text("first");
    expect(course1, findsOneWidget);

    final compactList = find.text("Compact List");
    expect(compactList, findsOneWidget);

    final slider = find.byKey(Key("switch"));
    expect(course1, findsOneWidget);

    await tester.tap(slider);
    await tester.pumpAndSettle();

    final LongtList = find.text("Extended List");
    expect(LongtList, findsOneWidget);

    final course1long = find.text("description");
    expect(course1long, findsOneWidget);
  });

  testWidgets("Add Course", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    //build the widget

    await tester.pumpWidget(appFalse);
    await tester.pumpAndSettle();

    final image = find.text("Select a Course From Your List");
    expect(image, findsOneWidget);

    final course1 = find.text("first");
    expect(course1, findsOneWidget);

    final compactList = find.text("Compact List");
    expect(compactList, findsOneWidget);

    final button = find.byKey(Key("floatingButton"));
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final dialogue = find.text("Add Course");
    expect(dialogue, findsOneWidget);

    final course1long = find.text("second");
    expect(course1long, findsOneWidget);

    await tester.tap(course1long);
    await tester.pumpAndSettle();

    final courseRefresh = find.text("first");
    expect(courseRefresh, findsOneWidget);
  });

  testWidgets("Slider Remove Short", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    //build the widget

    await tester.pumpWidget(appFalse);
    await tester.pumpAndSettle();

    final image = find.text("Select a Course From Your List");
    expect(image, findsOneWidget);

    final course1 = find.byType(Dismissible);
    expect(course1, findsOneWidget);

    await tester.drag(course1, Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    final course_past = find.byType(Dismissible);
    expect(course_past, findsNothing);
  });

  testWidgets("Slider Remove Big", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    //build the widget

    await tester.pumpWidget(appFalse);
    await tester.pumpAndSettle();

    final image = find.text("Select a Course From Your List");
    expect(image, findsOneWidget);

    final compactList = find.text("Compact List");
    expect(compactList, findsOneWidget);

    final slider = find.byKey(Key("switch"));
    expect(slider, findsOneWidget);

    await tester.tap(slider);
    await tester.pumpAndSettle();

    final course1 = find.byType(Dismissible);
    expect(course1, findsOneWidget);

    print(course1);

    await tester.drag(course1, Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    final course_past = find.byType(Dismissible);
    expect(course_past, findsNothing);
  });
}
