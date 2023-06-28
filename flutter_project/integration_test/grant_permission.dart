import 'dart:io';
import 'package:integration_test/integration_test_driver.dart';

//https://stackoverflow.com/questions/71597057/flutter-location-permission-from-integration-test-not-working

Future<void> main() async {
 await Process.run(
   'adb',
   [
     'shell',
     'pm',
     'grant',
     'com.example.dima_project',
     'android.permission.ACCESS_COARSE_LOCATION'
   ],
 );
  await Process.run(
    'adb',
    [
      'shell',
      'pm',
      'grant',
      'com.example.dima_project',
      'android.permission.ACCESS_FINE_LOCATION'
    ],
  );
 await integrationDriver();
}