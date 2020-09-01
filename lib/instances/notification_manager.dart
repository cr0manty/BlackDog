import 'dart:async';

import 'package:black_dog/instances/shared_pref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  static final NotificationManager instance = NotificationManager._internal();
  final StreamController<Map> _onMessage = StreamController<Map>.broadcast();

  Stream<Map> get onMessage => _onMessage.stream;

  NotificationManager._internal();

  FirebaseMessaging _fcm;

  void configure() {
    _fcm = FirebaseMessaging();
    _fcm.requestNotificationPermissions();

    _fcm.onTokenRefresh.listen((token) async {
      SharedPrefs.saveFCMToken(token);
      print('FCM Token: $token');
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        if (message['data'] != null) {
          _onMessage.add(message);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future<String> getToken() {
    return _fcm.getToken();
  }

  void dispose() {
    _onMessage?.close();
  }
}
