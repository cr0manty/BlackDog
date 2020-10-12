import 'dart:async';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'api.dart';

enum NotificationType { VOUCHER_RECEIVED, VOUCHER_SCANNED, QR_CODE_SCANNED }

class NotificationMessage {
  NotificationType type;
  String msg;

  NotificationMessage({this.type, this.msg});
}

class NotificationManager {
  static final NotificationManager instance = NotificationManager._internal();
  final StreamController<NotificationMessage> _onMessage =
      StreamController<NotificationMessage>.broadcast();

  Stream<NotificationMessage> get onMessage => _onMessage.stream;

  NotificationManager._internal();

  FirebaseMessaging _fcm;

  Future configure() async {
    _fcm = FirebaseMessaging();
    await _fcm.requestNotificationPermissions();
    _fcm.onTokenRefresh.listen((token) async {
      Api.instance.sendFCMToken(token: token);
      debugPrefixPrint('FCM Token: $token', prefix: 'fcm');
    });

    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          NotificationMessage msg = await _messageHandler(message);
          _onMessage.add(msg);
        },
        onLaunch: (Map<String, dynamic> message) async => await _messageHandler(message),
        onResume: (Map<String, dynamic> message) async => await _messageHandler(message));
  }

  static Future _backgroundMessageHandler(Map<String, dynamic> message) async {
    _messageHandler(message);
  }

  static Future _messageHandler(Map<String, dynamic> message) async {
    debugPrefixPrint("onMessage: $message", prefix: 'fcm');

    if (SharedPrefs.getInstance() == null) {
      await SharedPrefs.initialize();
    }

    if (message.containsKey('data')) {
      debugPrefixPrint("Message date type: ${message['data']['code']}",
          prefix: 'fcm');
      if (message['data']['code'] == 'voucher_received') {
        Voucher voucher =
            Voucher.fromStringJson(message['data']['voucher'], config: true);
        await _updateVouchers(voucher: voucher);
        _updateCounter(int.parse(message['data']['updated_counter'] ?? '0'));
        return NotificationMessage(
            type: NotificationType.VOUCHER_RECEIVED,
            msg: message['notification']['title']);
      } else if (message['data']['code'] == 'voucher_scanned') {
        await _updateVouchers(id: int.parse(message['data']['voucher_id']));
        _updateCounter(int.parse(message['data']['updated_counter'] ?? '0'));
        return NotificationMessage(
            type: NotificationType.VOUCHER_SCANNED,
            msg: message['notification']['title']);
      } else if (message['data']['code'] == 'qr_code_scanned') {
        _updateCounter(int.parse(message['data']['updated_counter'] ?? '0'));
        return NotificationMessage(
            type: NotificationType.QR_CODE_SCANNED,
            msg: message['notification']['title']);
      }
    }
  }

  static Future _updateVouchers({Voucher voucher, int id}) async {
    if (id != null) {
      Account.instance.vouchers.removeWhere((item) => item.id == id);
    } else if (voucher != null) {
      String qrCode = await Api.instance.saveQRCode(voucher.qrCode);
      if (qrCode != null) {
        voucher.qrCodeLocal = qrCode;
      }
      Account.instance.vouchers.add(voucher);
    }
    SharedPrefs.saveActiveVoucher(Account.instance.vouchers);
  }

  static void _updateCounter(int counter) {
    Account.instance.currentVoucher.purchaseCount = counter;
    SharedPrefs.saveCurrentVoucher(Account.instance.currentVoucher);
  }

  Future<String> getToken() {
    return _fcm.getToken();
  }

  void dispose() {
    _onMessage?.close();
  }
}
