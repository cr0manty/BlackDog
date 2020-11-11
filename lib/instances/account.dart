import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/base_voucher.dart';
import 'package:black_dog/models/user.dart';
import 'package:black_dog/models/voucher.dart';

import 'notification_manager.dart';
import 'shared_pref.dart';

enum AccountState { GUEST, USER, STAFF }

class Account {
  final StreamController<String> _onUserChange = StreamController<String>.broadcast();
  Account._internal();

  User _user;
  BaseVoucher _currentVoucher;
  List<Voucher> _vouchers = [];
  static final Account _instance = Account._internal();

  static Account get instance => _instance;

  AccountState state = AccountState.GUEST;

  String get name => _user.fullName;

  User get user => _user;

  BaseVoucher get currentVoucher => _currentVoucher;

  List<Voucher> get vouchers => _vouchers;

  Stream<String> get onUsernameChange => _onUserChange.stream;

  void initialize() {
    _user = SharedPrefs.getUser();

    if (_user != null) {
      state = _user.isStaff ?? false ? AccountState.STAFF : AccountState.USER;
      _onUserChange.add(_user.fullName);
    }
  }

  void onNotificationListener(NotificationMessage event) {
    switch (event.type) {
      case NotificationType.VOUCHER_RECEIVED:
        _vouchers = SharedPrefs.getActiveVouchers();
        _currentVoucher = SharedPrefs.getCurrentVoucher();
        break;
      case NotificationType.VOUCHER_SCANNED:
        _vouchers = SharedPrefs.getActiveVouchers();
        break;
      case NotificationType.QR_CODE_SCANNED:
        _currentVoucher = SharedPrefs.getCurrentVoucher();
        break;
      default:
        break;
    }
  }

  Future<bool> setUser() async {
    User user = await Api.instance.getUser();
    if (user != null) {
      _user = user;
      state = _user.isStaff ? AccountState.STAFF : AccountState.USER;
    }
    _onUserChange.add(_user.fullName);

    return _user != null;
  }

  Future refreshUser() async {
    User user = await Api.instance.getUser();
    if (user != null) {
      _user = user;
      _onUserChange.add(_user.fullName);
      SharedPrefs.saveUser(_user);
      refreshVouchers();
    }
  }

  void refreshVouchers() {
    _vouchers = SharedPrefs.getActiveVouchers();
    _currentVoucher = SharedPrefs.getCurrentVoucher();
  }
}
