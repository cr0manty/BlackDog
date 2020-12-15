import 'dart:async';
import 'dart:io';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../network/api.dart';

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
      debugPrefixPrint('FCM Token: $token', prefix: 'fcm');
    });

    _fcm.configure(
      onMessage: _messageHandler,
      onLaunch: _messageHandler,
      onResume: _messageHandler,
    );
  }

  Future _messageHandler(Map<String, dynamic> message) async {
    debugPrefixPrint("onMessage: $message", prefix: 'fcm');

    if (SharedPrefs.getInstance() == null) {
      await SharedPrefs.initialize();
    }
    Map messageData = Platform.isAndroid ? message['data'] : message;

    if (messageData['code'] == 'voucher_received') {
      Voucher voucher = Voucher.fromStringJson(
        messageData['voucher'],
        config: true,
      );
      await _updateVouchers(voucher: voucher);
      _updateCounter(
        int.parse(messageData['updated_counter'] ?? '0'),
      );
      _onMessage.add(
        NotificationMessage(
          type: NotificationType.VOUCHER_RECEIVED,
          msg: voucher.name,
        ),
      );
    } else if (messageData['code'] == 'voucher_scanned') {
      await _updateVouchers(
        id: int.parse(
          messageData['voucher_id'],
        ),
      );
      _updateCounter(
        int.parse(messageData['updated_counter'] ?? '0'),
      );
      _onMessage.add(
        NotificationMessage(
          type: NotificationType.VOUCHER_SCANNED,
          msg: Platform.isAndroid
              ? message['notification']['title']
              : messageData['aps']['alert']['title'],
        ),
      );
    } else if (messageData['code'] == 'qr_code_scanned') {
      _updateCounter(int.parse(messageData['updated_counter'] ?? '0'));
      _onMessage.add(
        NotificationMessage(
          type: NotificationType.QR_CODE_SCANNED,
          msg: Platform.isAndroid
              ? message['notification']['title']
              : messageData['aps']['alert']['title'],
        ),
      );
    }
  }

  Future _updateVouchers({Voucher voucher, int id}) async {
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

  void _updateCounter(int counter) {
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
