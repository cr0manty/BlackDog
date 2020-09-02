import 'dart:async';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  static final NotificationManager instance = NotificationManager._internal();
  final StreamController<Map> _onMessage = StreamController<Map>.broadcast();

  Stream<Map> get onMessage => _onMessage.stream;

  NotificationManager._internal();

  FirebaseMessaging _fcm;

  Future configure() async {
    _fcm = FirebaseMessaging();
    await _fcm.requestNotificationPermissions();

    _fcm.onTokenRefresh.listen((token) async {
      SharedPrefs.saveFCMToken(token);
      print('FCM Token: $token');
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        if (message['data'] != null) {
          print("Message date type: ${message['data']['code']}");
          if (message['data']['code'] == 'voucher_received') {
            Voucher voucher = Voucher.fromStringJson(message['data']['voucher']);
            Account.instance.user.vouchers.add(voucher);
          } else if (message['data']['code'] == 'voucher_scanned') {
            Account.instance.user.removeVoucher(int.parse(message['data']['voucher_id']));
          }
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
