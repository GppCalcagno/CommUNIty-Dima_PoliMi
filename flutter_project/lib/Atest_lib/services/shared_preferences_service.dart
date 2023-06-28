
final sharedPrefs = SharedPreferencesService();

class SharedPreferencesService {
  
  static const String notificationPositionKey = 'notificationPosition';
  static const String notificationChatKey = 'notificationChat';
  static const String darkModeKey = 'darkMode';

  void setPreference(String key, bool value) {
    return;
  }

  bool getPreference(String key) {
    return true;
  }

}