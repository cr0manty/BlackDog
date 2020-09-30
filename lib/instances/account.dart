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

  String get name => _user.fullName;

  User get user => _user;

  void initialize() {
    _user = SharedPrefs.getUser();

    if (_user != null) {
      state = _user.isStaff ?? false ? AccountState.STAFF : AccountState.USER;
    }
  }

  Future<bool> setUser() async {
    User user = await Api.instance.getUser();
    if (user != null) {
      _user = user;
      state = _user.isStaff ? AccountState.STAFF : AccountState.USER;
    }
    return _user != null;
  }

  Future refreshUser() async {
    User user = await Api.instance.getUser();
    if (user != null) {
      _user = user;
      SharedPrefs.saveUser(_user);
    }
  }
}
