import 'package:black_dog/insatnces/shared_pref.dart';
import 'package:black_dog/models/user.dart';

enum AccountState {
  GUEST, USER, STAFF
}

class Account {
  Account._internal();
  User _user;
  static final Account _instance = Account._internal();

  static Account get instance => _instance;
  
  AccountState state = AccountState.GUEST;

  Future init() async {
    _user = SharedPrefs.getUser();
    
    if (_user != null) {
      state = _user.isStaff ? AccountState.STAFF : AccountState.USER;
    }
  }
  
  Future signInUser(String email, String password) async {
    
  }

  Future stuffScanQRCode() async {

  }

}