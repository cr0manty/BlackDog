import 'dart:async';
import 'dart:io';

import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'api.dart';

enum NotificationType { VOUCHER_RECEIVED, VOUCHER_SCANNED, QR_CODE_SCANNED }

class NotificationManager {
  static final NotificationManager instance = NotificationManager._internal();
  final StreamController<NotificationType> _onMessage =
      StreamController<NotificationType>.broadcast();

  Stream<NotificationType> get onMessage => _onMessage.stream;

  NotificationManager._internal();

  FirebaseMessaging _fcm;

  Future configure() async {
    _fcm = FirebaseMessaging();
    await _fcm.requestNotificationPermissions();
    _fcm.onTokenRefresh.listen((token) async {
      Api.instance.sendFCMToken(token: token);
      print('FCM Token: $token');
    });

    _fcm.configure(
        onMessage: _foregroundMessageHandler,
        onLaunch: _foregroundMessageHandler,
        onResume: _foregroundMessageHandler,
        onBackgroundMessage: Platform.isIOS ? null : _backgroundMessageHandler);
  }

  static Future _backgroundMessageHandler(Map<String, dynamic> message) async {
    _messageHandler(message);
  }

  Future _foregroundMessageHandler(Map<String, dynamic> message) async {
    NotificationType notificationType = await _messageHandler(message);
    _onMessage.add(notificationType);
  }

  static Future _messageHandler(Map<String, dynamic> message) async {
    print("onMessage: $message");

    if (SharedPrefs.getInstance() == null) {
      await SharedPrefs.initialize();
    }

    if (message.containsKey('data')) {
      print("Message date type: ${message['data']['code']}");
      if (message['data']['code'] == 'voucher_received') {
        Voucher voucher = Voucher.fromStringJson(message['data']['voucher']);
        _updateVouchers(voucher: voucher);
        _updateCounter(int.parse(message['data']['updated_counter'] ?? '0'));
        return NotificationType.VOUCHER_RECEIVED;
      } else if (message['data']['code'] == 'voucher_scanned') {
        _updateVouchers(id: int.parse(message['data']['voucher_id']));
        _updateCounter(int.parse(message['data']['updated_counter'] ?? '0'));
        return NotificationType.VOUCHER_SCANNED;
      } else if (message['data']['code'] == 'qr_code_scanned') {
        _updateCounter(int.parse(message['data']['updated_counter'] ?? '0'));
        return NotificationType.QR_CODE_SCANNED;
      }
    }
  }

  static void _updateVouchers({Voucher voucher, int id}) {
    List<Voucher> vouchers = SharedPrefs.getActiveVouchers();

    if (id != null) {
      vouchers.removeWhere((item) => item.id == id);
    } else if (voucher != null) {
      vouchers.add(voucher);
    }
    SharedPrefs.saveActiveVoucher(vouchers);
  }

  static void _updateCounter(int counter) {
    BaseVoucher currentVoucher = SharedPrefs.getCurrentVoucher();
    currentVoucher.purchaseCount = counter;
    SharedPrefs.saveCurrentVoucher(currentVoucher);
  }

  Future<String> getToken() {
    return _fcm.getToken();
  }

  void dispose() {
    _onMessage?.close();
  }
}
