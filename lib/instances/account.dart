import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/models/user.dart';
import 'package:geolocator/geolocator.dart';

import 'shared_pref.dart';

enum AccountState { GUEST, USER, STAFF }

class Account {
  Account._internal();

  User _user;
  Position _position;
  static final Account _instance = Account._internal();

  static Account get instance => _instance;

  AccountState state = AccountState.GUEST;

  String get name => _user.fullName;

  User get user => _user;

  Position get position => _position ?? Position(longitude: 49.989128, latitude: 36.230987);

  void initialize() {
    _user = SharedPrefs.getUser();

    if (_user != null) {
      state = _user.isStaff ?? false ? AccountState.STAFF : AccountState.USER;
    }
    initCurrentLocation();
  }

  Future<bool> setUser() async {
    _user = await Api.instance.getUser();
    state = _user.isStaff ? AccountState.STAFF : AccountState.USER;
    return _user != null;
  }

  Future refreshUser() async {
    _user = await Api.instance.getUser();
    SharedPrefs.saveUser(_user);
  }

  void initCurrentLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
  }
}
