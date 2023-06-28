import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/services/shared_preferences_service.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/main.dart';

import 'package:dima_project/widgets/drawer.dart';
import 'package:dima_project/widgets/settings/user_profile_widget.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  DatabaseService dbService = DatabaseService();
  late Future<UserModel> currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = dbService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text("Settings"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
                icon:
                    !sharedPrefs.getPreference(SharedPreferencesService.darkModeKey) ? Icon(Icons.dark_mode_rounded, color: Colors.blueGrey, size: 30,) : Icon(Icons.light_mode_rounded, color: Colors.amber.shade200, size: 30),
                onPressed: () async {
                  MyApp.of(context)!.toggleTheme();

                  setState(() {
                    currentUser = dbService.getCurrentUser();
                  });
                }),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 0), () => currentUser), //delay used for testing
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Icon(Icons.error));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return UserProfileWidget(currentUser: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      drawer: const DrawerForNavigation(),
    );
  }
}
