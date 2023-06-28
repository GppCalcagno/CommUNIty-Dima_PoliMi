import 'dart:async';
import 'dart:convert';
import 'package:dima_project/api_keys.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  // Initialize Firebase Messaging
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  // Initialize Flutter Local Notifications
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    playSound: channel.playSound,
    priority: Priority.high,
    importance: channel.importance,
  );

  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      return true;
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
      return true;
    } else {
      debugPrint('User declined or has not accepted permission');
      return false;
    }
  }

  Future<void> notificationSetup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/launcher_icon'); // da vedere
    const iosSetting = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('flutterLocalNotificationsPlugin: SETUP SUCCESS');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });

    await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground notification
      debugPrint('Got a message whilst in the foreground! ${message.messageId}');
      showNotification(message.data['title'], message.data['body']);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background notification
      debugPrint('onMessageOpenedApp: $message');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint('Handling a background message ${message.messageId}');
  }

  NotificationDetails getNotificationDetails() {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: _androidNotificationDetails,
    );
    return platformChannelSpecifics;
  }

  Future<void> showNotification(String title, String body) async {
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      getNotificationDetails(),
      //payload: 'Notification Payload',
    );
  }


  addPositionNotifications() async {
    //await _fcm.subscribeToTopic("positionTopic"); // subscribe to topic for receiving push notifications
    Future<String> token = _fcm.getToken().then((value) => value.toString());
    DatabaseService().addPositionToken(await token); // add user token to database
  }

  removePositionNotifications() async {
    //await _fcm.unsubscribeFromTopic("positionTopic"); // unsubscribe from topic
    Future<String> token = _fcm.getToken().then((value) => value.toString());
    DatabaseService().removePositionToken(await token); // remove user token from database
  }

  addChatNotifications() async {
    //await _fcm.subscribeToTopic("chatTopic"); // subscribe to topic for receiving push notifications
    Future<String> token = _fcm.getToken().then((value) => value.toString());
    List<GroupChatModel> groups = await DatabaseService().getUserGroups();
    for (GroupChatModel group in groups) {
      DatabaseService().addChatToken(await token, group.groupId); // add user token to group tokens
    }
  }

  removeChatNotifications() async {
    //await _fcm.unsubscribeFromTopic("chatTopic"); // unsubscribe from topic
    Future<String> token = _fcm.getToken().then((value) => value.toString());
    List<GroupChatModel> groups = await DatabaseService().getUserGroups();
    for (GroupChatModel group in groups) {
      DatabaseService().removeChatToken(await token, group.groupId); // remove user token from group tokens
    }
  }




  Future<void> sendPushNotification(List<String> tokens, String title, String body, Map<String, dynamic> data) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmServerKey',
    };

    final payload = <String, dynamic>{
      'registration_ids': tokens,
      //'to': '/topics/$topic',
      'notification': {
        'title': title,
        'body': body,
      },
      'data': data,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully.');
    } else {
      debugPrint('Failed to send notification. Error: ${response.body}');
    }
  }
}