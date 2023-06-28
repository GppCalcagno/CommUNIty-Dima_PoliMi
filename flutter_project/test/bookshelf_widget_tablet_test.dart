import 'package:dima_project/Atest_lib/book_detail_page.dart';
import 'package:dima_project/Atest_lib/book_list_page.dart';
import 'package:dima_project/Atest_lib/book_tablet_page.dart';
import 'package:dima_project/classes/book_model.dart';

import 'package:dima_project/responsive_layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

BookModel book = BookModel(
  id: "01",
  title: "test1",
  description: "description",
  thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjzC2JyZDZ_RaWf0qp11K0lcvB6b6kYNMoqtZAQ9hiPZ4cTIOB",
);

BookModel bookNoDescription = BookModel(
  id: "01",
  title: "test",
  thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjzC2JyZDZ_RaWf0qp11K0lcvB6b6kYNMoqtZAQ9hiPZ4cTIOB",
);

MaterialApp app = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => ResponsiveLayout(mobileBody: BookList(), tabletBody: BookTabletWidget()),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/booklist/bookdetail': (context) => BookDetailScreen(book: book),
  },
);

void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Render Screen", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final bookSearch = find.byKey(const Key("searchBar"));
    expect(bookSearch, findsOneWidget);

    final bookList = find.text("test1");
    expect(bookSearch, findsOneWidget);

    final text = find.text("No book selected");
    expect(bookSearch, findsOneWidget);
  });

  testWidgets("No Book Found", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final bookSearch = find.byKey(const Key("searchBar"));
    expect(bookSearch, findsOneWidget);

    await tester.tap(bookSearch);
    await tester.pumpAndSettle();

    await tester.enterText(bookSearch, "empty");
    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final check = find.byKey(const Key("noBooksFound"));
    expect(check, findsOneWidget);
  });

  testWidgets("Book Found", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final check = find.text("test1");
    expect(check, findsOneWidget);
  });

  testWidgets("Click a Book", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final bookSelected = find.text("test1");
    expect(bookSelected, findsOneWidget);

    await tester.tap(bookSelected);
    await tester.pumpAndSettle();

    final description0 = find.text("What's it about?");
    expect(description0, findsAtLeastNWidgets(1));

    final description1 = find.text("description");
    expect(description1, findsAtLeastNWidgets(1));

    final pages = find.text("Pages");
    expect(pages, findsAtLeastNWidgets(1));

    final Language = find.text("Language");
    expect(Language, findsAtLeastNWidgets(1));

    final Pushish = find.text("Publish date");
    expect(Pushish, findsAtLeastNWidgets(1));

    final image = find.byKey(Key("BookImage"));
    expect(image, findsOneWidget);
  });
}
