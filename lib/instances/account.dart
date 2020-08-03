import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/user.dart';

import 'shared_pref.dart';

enum AccountState { GUEST, USER, STAFF }

class Account {
  Account._internal();

  User _user;
  static final Account _instance = Account._internal();

  static Account get instance => _instance;

  AccountState state = AccountState.GUEST;

  String get name => _user.firstName;

  Future initialize() async {
    _user = SharedPrefs.getUser();

    if (_user != null) {
      state = _user.isStaff ? AccountState.STAFF : AccountState.USER;
    }
  }

  Future stuffScanQRCode() async {}

  Future<bool> setUser() async {
    _user = await Api.instance.getUser();
    state = _user.isStaff ? AccountState.STAFF : AccountState.USER;
    Api.instance.initialize();
    return _user != null;
  }
}
