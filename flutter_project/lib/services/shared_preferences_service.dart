import 'package:dima_project/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefs = SharedPreferencesService();

class SharedPreferencesService {
  static SharedPreferences? _sharedPrefs;

  static const String notificationPositionKey = 'notificationPosition';
  static const String notificationChatKey = 'notificationChat';
  static const String darkModeKey = 'darkMode';

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    } else {
      return;
    }
  }

  void setPreference(String key, bool value) {
    try {
      _sharedPrefs?.setBool(key, value) ?? false;
      if (key == notificationPositionKey) {
        if (value) {
          NotificationService().addPositionNotifications();
        } else {
          NotificationService().removePositionNotifications();
        }
      } else if (key == notificationChatKey) {
        if (value) {
          NotificationService().addChatNotifications();
        } else {
          NotificationService().removeChatNotifications();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool getPreference(String key) {
    try {
      return _sharedPrefs?.getBool(key) ?? false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /*static void resetSharedPreferences(List<String> list) async {
    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();
    for(String key in list) {
      sharedPreferences.remove(key);
    }
  }*/
}
