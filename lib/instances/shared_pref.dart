import 'package:black_dog/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefs {
  static const _currentUser = 'CurrentUser';
  static const _currentToken = 'CurrentToken';

  static SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences getInstance() {
    return _prefs;
  }

  static void logout() {
    _prefs.setString(_currentUser, "");
    _prefs.setString(_currentToken, "");
  }

  static void saveToken(String token) {
    _prefs.setString(
        _currentToken, (token != null && token.length > 0) ? token : "");
  }

  static void saveUser(User user) {
    _prefs.setString(_currentUser, userToJson(user));
  }


  static String getToken() {
    return _prefs.getString(_currentToken);
  }

  static User getUser() {
    String jsonUser = _prefs.getString(_currentUser);
    User user = userFromJson(jsonUser);
    return user;
  }
}