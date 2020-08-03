import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefs {
  static const _currentUser = 'CurrentUser';
  static const _currentToken = 'CurrentToken';
  static const _qrCode = 'QRCode';
  static const _restaurant = 'Restaurant';

  static SharedPreferences _prefs;

  static Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences getInstance() {
    return _prefs;
  }

  static void logout() {
    _prefs.setString(_currentUser, "");
    _prefs.setString(_currentToken, "");
    _prefs.setString(_qrCode, "");
  }

  static void saveToken(String token) {
    _prefs.setString(
        _currentToken, (token != null && token.isNotEmpty) ? token : "");
  }

  static void saveUser(User user) {
    _prefs.setString(_currentUser, userToJson(user));
  }

  static String getToken() {
    return _prefs.getString(_currentToken);
  }

  static String getQRCode() {
    return _prefs.getString(_qrCode) ?? '';
  }

  static Restaurant getRestaurant() {
    String jsonRestaurant = _prefs.getString(_restaurant);
    Restaurant restaurant = restaurantFromJson(jsonRestaurant);
    return restaurant;
  }

  static void saveQRCode(String qrCode) {
    _prefs.setString(
        _qrCode, (qrCode != null && qrCode.isNotEmpty) ? qrCode : "");
  }

  static void saveRestaurant(Restaurant restaurant) {
    _prefs.setString(_restaurant, restaurantToJson(restaurant));
  }

  static User getUser() {
    String jsonUser = _prefs.getString(_currentUser);
    User user = userFromJson(jsonUser);
    return user;
  }
}
