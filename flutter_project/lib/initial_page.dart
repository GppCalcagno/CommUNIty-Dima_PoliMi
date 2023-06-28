// ignore_for_file: prefer_const_constructors
import 'package:dima_project/services/notification_service.dart';
import 'package:dima_project/services/shared_preferences_service.dart';
import 'package:dima_project/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'courses.dart';
import 'firebase_options.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    //WidgetsFlutterBinding.ensureInitialized();

    return FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform), //avvio DB
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        } else if (snapshot.hasData) {
          return FutureBuilder(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("ERROR DURING LOGIN");
              }
              if (snapshot.hasData) {
                debugPrint("initial_page: USER LOGGED IN");
                
                NotificationService().notificationSetup().then((value) => debugPrint("initial_page: NOTIFICATION SERVICE SETUP"));
                if (sharedPrefs.getPreference(SharedPreferencesService.notificationPositionKey)) {
                  debugPrint('initial_page: POSITION NOTIFICATIONS');
                  NotificationService().addPositionNotifications();
                }
                if (sharedPrefs.getPreference(SharedPreferencesService.notificationChatKey)) {
                  debugPrint('initial_page: CHAT NOTIFICATIONS');
                  NotificationService().addChatNotifications();
                }

                return CoursesScreen();
              } else {
                debugPrint("initial_page: USER NOT LOGGED");
                return LoginScreen();
              }
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

}
