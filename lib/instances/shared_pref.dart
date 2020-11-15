import 'dart:convert';

import 'package:black_dog/models/base_voucher.dart';
import 'package:black_dog/models/restaurant.dart';
import 'package:black_dog/models/restaurant_config.dart';
import 'package:black_dog/models/user.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefs {
  static const _currentUser = 'CurrentUser';
  static const _currentToken = 'CurrentToken';
  static const _qrCode = 'QRCode';
  static const _localeCode = 'LocaleCode';
  static const _showNews = 'ShowNews';
  static const _maxNewsAmount = 'MaxPostAmount';
  static const _currentVoucher = 'CurrentVoucher';
  static const _firebaseUserUid = 'FirebaseUserUID';
  static const _activeVouchers = 'ActiveVouchers';
  static const _abutUs = 'AboutUs';
  static const _abutUsList = 'AboutUsList';

  static SharedPreferences _prefs;

  static Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences getInstance() {
    return _prefs;
  }

  static void logout() {
    debugPrefixPrint('logout', prefix: 'SharedPrefs');

    _prefs.setString(_currentUser, '');
    _prefs.setString(_currentToken, '');
    _prefs.setString(_qrCode, '');
    _prefs.setString(_firebaseUserUid, '');
  }

  static void saveToken(String token) {
    debugPrefixPrint('saveToken', prefix: 'SharedPrefs');

    _prefs.setString(
        _currentToken, (token != null && token.isNotEmpty) ? token : '');
  }

  static void saveUser(User user) {
    debugPrefixPrint('saveUser', prefix: 'SharedPrefs');

    _prefs.setString(_currentUser, userToJson(user));
  }

  static void saveQRCode(String qrCode) {
    debugPrefixPrint('saveQRCode', prefix: 'SharedPrefs');

    _prefs.setString(
        _qrCode, (qrCode != null && qrCode.isNotEmpty) ? qrCode : '');
  }

  static void saveUserFirebaseUid(String uid) {
    debugPrefixPrint('saveUserFirebaseUid', prefix: 'SharedPrefs');
    debugPrefixPrint('Frirebase user uid: $uid', prefix: 'SharedPrefs');

    _prefs.setString(
        _firebaseUserUid, (uid != null && uid.isNotEmpty) ? uid : '');
  }

  static void saveShowPost(bool showPost) {
    debugPrefixPrint('saveShowPost', prefix: 'SharedPrefs');

    _prefs.setBool(_showNews, showPost);
  }

  static void saveMaxNews(int maxNews) {
    debugPrefixPrint('saveMaxNews', prefix: 'SharedPrefs');

    _prefs.setInt(_maxNewsAmount, maxNews);
  }

  static void saveLanguageCode(String code) {
    debugPrefixPrint('saveLanguageCode', prefix: 'SharedPrefs');

    _prefs.setString(
        _localeCode, (code != null && code.isNotEmpty) ? code : '');
  }

  static void saveCurrentVoucher(BaseVoucher voucher) {
    debugPrefixPrint('saveCurrentVoucher', prefix: 'SharedPrefs');

    _prefs.setString(_currentVoucher, baseVoucherToJson(voucher));
  }

  static void saveActiveVoucher(List<Voucher> vouchers) {
    debugPrefixPrint('saveActiveVoucher', prefix: 'SharedPrefs');
    List<String> _voucherStrings = [];
    vouchers.forEach((Voucher voucher) {
      _voucherStrings.add(voucherToJson(voucher));
    });
    _prefs.setStringList(_activeVouchers, _voucherStrings);
  }

  static void saveAboutUsList(List<RestaurantConfig> configs) {
    debugPrefixPrint('saveAboutUsList', prefix: 'SharedPrefs');
    List<String> _configStrings = [];
    configs.forEach((RestaurantConfig config) {
      _configStrings.add(restaurantConfigToJson(config));
    });
    _prefs.setStringList(_abutUsList, _configStrings);
  }

  static void saveAboutUs(Restaurant restaurant) {
    debugPrefixPrint('saveAboutUs', prefix: 'SharedPrefs');
    _prefs.setString(_abutUs, restaurantToJson(restaurant));
  }

  static String getToken() {
    debugPrefixPrint('getToken', prefix: 'SharedPrefs');

    return _prefs.getString(_currentToken) ?? '';
  }

  static String getQRCode() {
    debugPrefixPrint('getQRCode', prefix: 'SharedPrefs');

    return _prefs.getString(_qrCode) ?? '';
  }

  static String getLanguageCode() {
    debugPrefixPrint('getLanguageCode', prefix: 'SharedPrefs');

    return _prefs.getString(_localeCode) ?? 'en';
  }

  static bool getShowNews() {
    debugPrefixPrint('getShowNews', prefix: 'SharedPrefs');

    return _prefs.getBool(_showNews) ?? false;
  }

  static int getMaxNewsAmount() {
    debugPrefixPrint('getMaxNewsAmount', prefix: 'SharedPrefs');

    return _prefs.getInt(_maxNewsAmount) ?? 5;
  }

  static BaseVoucher getCurrentVoucher() {
    debugPrefixPrint('getCurrentVoucher', prefix: 'SharedPrefs');

    String jsonVoucher = _prefs.getString(_currentVoucher);
    return baseVoucherFromJson(jsonVoucher);
  }

  static String getUserFirebaseUID() {
    debugPrefixPrint('getUserFirebaseUID', prefix: 'SharedPrefs');

    return _prefs.getString(_firebaseUserUid);
  }

  static User getUser() {
    debugPrefixPrint('getUser', prefix: 'SharedPrefs');

    String jsonUser = _prefs.getString(_currentUser);
    return userFromJson(jsonUser);
  }

  static List<Voucher> getActiveVouchers() {
    debugPrefixPrint('getActiveVouchers', prefix: 'SharedPrefs');
    List<Voucher> vouchers = [];
    List<String> activeVouchers = _prefs.getStringList(_activeVouchers) ?? [];

    activeVouchers.forEach((String voucherString) {
      Map jsonData = json.decode(voucherString);
      vouchers.add(Voucher.fromJson(jsonData));
    });

    return vouchers;
  }

  static List<RestaurantConfig> getAboutUsList() {
    debugPrefixPrint('getLastLogs', prefix: 'SharedPrefs');
    List<RestaurantConfig> configs = [];

    List<String> configsList = _prefs.getStringList(_abutUsList) ?? [];

    configsList.forEach((String voucherString) {
      Map jsonData = json.decode(voucherString);
      configs.add(RestaurantConfig.fromJson(jsonData));
    });

    return configs;
  }

  static Restaurant getAboutUs() {
    debugPrefixPrint('getAboutUs', prefix: 'SharedPrefs');

    String lastLogs = _prefs.getString(_abutUs);
    return restaurantFromJson(lastLogs);
  }
}
