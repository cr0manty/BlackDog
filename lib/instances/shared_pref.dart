import 'package:black_dog/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefs {
  static const _currentUser = 'CurrentUser';
  static const _currentToken = 'CurrentToken';
  static const _qrCode = 'QRCode';
  static const _localeCode = 'LocaleCode';
  static const _showNews = 'ShowNews';
  static const _maxNewsAmount = 'MaxPostAmount';

  static SharedPreferences _prefs;

  static Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences getInstance() {
    return _prefs;
  }

  static void logout() {
    _prefs.setString(_currentUser, '');
    _prefs.setString(_currentToken, '');
    _prefs.setString(_qrCode, '');
  }

  static void saveToken(String token) {
    _prefs.setString(
        _currentToken, (token != null && token.isNotEmpty) ? token : '');
  }

  static void saveUser(User user) {
    _prefs.setString(_currentUser, userToJson(user));
  }

  static void saveQRCode(String qrCode) {
    _prefs.setString(
        _qrCode, (qrCode != null && qrCode.isNotEmpty) ? qrCode : '');
  }

  static void saveShowPost(bool showPost) {
    _prefs.setBool(_showNews, showPost);
  }

  static void saveMaxNews(int maxNews) {
    _prefs.setInt(_maxNewsAmount, maxNews);
  }

  static void saveLanguageCode(String code) {
    _prefs.setString(
        _localeCode, (code != null && code.isNotEmpty) ? code : '');
  }

  static String getToken() {
    return _prefs.getString(_currentToken);
  }

  static String getQRCode() {
    return _prefs.getString(_qrCode) ?? '';
  }

  static String getLanguageCode() {
    return _prefs.getString(_localeCode) ?? 'en';
  }

  static bool getShowNews() {
    return _prefs.getBool(_showNews) ?? false;
  }

  static int getMaxNewsAmount() {
    return _prefs.getInt(_maxNewsAmount) ?? 0;
  }

  static User getUser() {
    String jsonUser = _prefs.getString(_currentUser);
    User user = userFromJson(jsonUser);
    return user;
  }
}
