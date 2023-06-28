import 'package:dima_project/chat_page.dart';
import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/classes/note_model.dart';
import 'package:dima_project/classes/position_model.dart';
import 'package:dima_project/classes/review_model.dart';
import 'package:dima_project/services/shared_preferences_service.dart';
import 'package:dima_project/course_page.dart';
import 'package:dima_project/courses.dart';
import 'package:dima_project/group_chat_list_page.dart';
import 'package:dima_project/group_chat_tablet_page.dart';
import 'package:dima_project/map_page.dart';
import 'package:dima_project/new_note_page.dart';
import 'package:dima_project/position_tablet_page.dart';
import 'package:dima_project/responsive_layout.dart';
import 'package:dima_project/initial_page.dart';
import 'package:dima_project/book_detail_page.dart';
import 'package:dima_project/book_list_page.dart';
import 'package:dima_project/classes/book_model.dart';
import 'package:dima_project/settings_page.dart';
import 'package:dima_project/position_list_page.dart';
import 'package:dima_project/show_note_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'book_tablet_page.dart';
import 'login_page.dart';
import 'modify_note_page.dart';
import 'new_review_page.dart';
import 'show_review_page.dart';

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        //da qua vedere come e se cambiarlo
        return const InitialPage();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'booklist',
            builder: (BuildContext context, GoRouterState state) {
              return const ResponsiveLayout(mobileBody: BookList(), tabletBody: BookPageTablet());
            }),
        GoRoute(
          path: 'booklist/bookdetail',
          pageBuilder: (context, state) => MaterialPage(child: BookDetailScreen(book: state.extra as BookModel)),
        ),
        GoRoute(
            path: 'settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            }),
        GoRoute(
            path: 'initialpage',
            builder: (BuildContext context, GoRouterState state) {
              return const InitialPage();
            }),
        GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            }),
        GoRoute(
            path: 'courses',
            builder: (BuildContext context, GoRouterState state) {
              return const CoursesScreen();
            }),
        GoRoute(
          path: 'courses/selectedcourse',
          pageBuilder: (context, state) => MaterialPage(child: CoursePageScreen(course: state.extra as CourseModel)),
        ),
        GoRoute(
            path: 'positionlist',
            builder: (BuildContext context, GoRouterState state) {
              return const ResponsiveLayout(mobileBody: PositionList(), tabletBody: PositionTablet());
            }),
        GoRoute(
          path: 'map',
          pageBuilder: (context, state) => MaterialPage(child: MapScreen(userPosition: state.extra as PositionModel)),
        ),
        GoRoute(
            path: 'login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            }),
        GoRoute(
          path: 'courses/reviews/newReview',
          pageBuilder: (context, state) => MaterialPage(child: NewReviewPage(course: state.extra as CourseModel)),
        ),
        GoRoute(
          path: 'courses/reviews/showReview',
          pageBuilder: (context, state) => MaterialPage(child: ShowReviewPage(review: state.extra as ReviewModel)),
        ),
        GoRoute(
          path: 'courses/reviews/newNote',
          pageBuilder: (context, state) => MaterialPage(child: NewNotePage(course: state.extra as CourseModel)),
        ),
        GoRoute(
          path: 'courses/reviews/showNote',
          pageBuilder: (context, state) => MaterialPage(child: ShowNotePage(selectedNote: state.extra as NoteModel)),
        ),
        GoRoute(
          path: 'courses/reviews/modifyNote',
          pageBuilder: (context, state) => MaterialPage(child: ModifyNotePage(note: state.extra as NoteModel)),
        ),
        GoRoute(
            path: 'groupchatlist',
            builder: (BuildContext context, GoRouterState state) {
              return const ResponsiveLayout(mobileBody: GroupChatList(), tabletBody: GroupChatTablet());
            }),
        GoRoute(
          path: 'chatpage',
          pageBuilder: (context, state) => MaterialPage(child: ChatScreen(group: state.extra as GroupChatModel)),
        ),
      ],
    ),
  ],
);


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init(); //initialize shared preferences
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = sharedPrefs.getPreference(SharedPreferencesService.darkModeKey) ? ThemeMode.dark : ThemeMode.light;

  @override
  void initState() {
    super.initState();
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
    sharedPrefs.setPreference(SharedPreferencesService.darkModeKey, _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light
          /* light theme settings */
          ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark
          /* dark theme settings */
          ),
      themeMode: _themeMode,
      title: "myApp",
    );
  }
}
