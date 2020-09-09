import 'dart:convert';

import 'package:black_dog/models/user.dart';
import 'package:black_dog/models/voucher.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefs {
  static const _currentUser = 'CurrentUser';
  static const _currentToken = 'CurrentToken';
  static const _qrCode = 'QRCode';
  static const _localeCode = 'LocaleCode';
  static const _showNews = 'ShowNews';
  static const _maxNewsAmount = 'MaxPostAmount';
  static const _fcmToken = 'FCMToken';
  static const _currentVoucher = 'CurrentVoucher';
  static const _firebaseUserUid = 'FirebaseUserUID';
  static const _activeVouchers = 'ActiveVouchers';

  static SharedPreferences _prefs;

  static Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences getInstance() {
    return _prefs;
  }

  static void logout() {
    print('SharedPrefs: logout');

    _prefs.setString(_currentUser, '');
    _prefs.setString(_currentToken, '');
    _prefs.setString(_qrCode, '');
    _prefs.setString(_fcmToken, '');
    _prefs.setString(_firebaseUserUid, '');
  }

  static void saveToken(String token) {
    print('SharedPrefs: saveToken');

    _prefs.setString(
        _currentToken, (token != null && token.isNotEmpty) ? token : '');
  }

  static void saveFCMToken(String token) {
    print('SharedPrefs: saveFCMToken');

    _prefs.setString(
        _fcmToken, (token != null && token.isNotEmpty) ? token : '');
  }

  static void saveUser(User user) {
    print('SharedPrefs: saveUser');

    _prefs.setString(_currentUser, userToJson(user));
  }

  static void saveQRCode(String qrCode) {
    print('SharedPrefs: saveQRCode');

    _prefs.setString(
        _qrCode, (qrCode != null && qrCode.isNotEmpty) ? qrCode : '');
  }

  static void saveUserFirebaseUid(String uid) {
    print('SharedPrefs: saveUserFirebaseUid');
    print('Frirebase user uid: $uid');

    _prefs.setString(
        _firebaseUserUid, (uid != null && uid.isNotEmpty) ? uid : '');
  }

  static void saveShowPost(bool showPost) {
    print('SharedPrefs: saveShowPost');

    _prefs.setBool(_showNews, showPost);
  }

  static void saveMaxNews(int maxNews) {
    print('SharedPrefs: saveMaxNews');

    _prefs.setInt(_maxNewsAmount, maxNews);
  }

  static void saveLanguageCode(String code) {
    print('SharedPrefs: saveLanguageCode');

    _prefs.setString(
        _localeCode, (code != null && code.isNotEmpty) ? code : '');
  }

  static void saveCurrentVoucher(BaseVoucher voucher) {
    print('SharedPrefs: saveCurrentVoucher');

    _prefs.setString(_currentVoucher, baseVoucherToJson(voucher));
  }

  static void saveActiveVoucher(List<Voucher> vouchers) {
    print('SharedPrefs: $saveActiveVoucher');
    List<String> _voucherStrings = [];
    vouchers.forEach((Voucher voucher) {
      _voucherStrings.add(voucherToJson(voucher));
    });
    _prefs.setStringList(_activeVouchers, _voucherStrings);
  }

  static String getToken() {
    print('SharedPrefs: getToken');

    return _prefs.getString(_currentToken);
  }

  static String getFCMToken() {
    print('SharedPrefs: getFCMToken');

    return _prefs.getString(_fcmToken);
  }

  static String getQRCode() {
    print('SharedPrefs: getQRCode');

    return _prefs.getString(_qrCode) ?? '';
  }

  static String getLanguageCode() {
    print('SharedPrefs: getLanguageCode');

    return _prefs.getString(_localeCode) ?? 'en';
  }

  static bool getShowNews() {
    print('SharedPrefs: getShowNews');

    return _prefs.getBool(_showNews) ?? false;
  }

  static int getMaxNewsAmount() {
    print('SharedPrefs: getMaxNewsAmount');

    return _prefs.getInt(_maxNewsAmount) ?? 5;
  }

  static BaseVoucher getCurrentVoucher() {
    print('SharedPrefs: getCurrentVoucher');

    String jsonVoucher = _prefs.getString(_currentVoucher);
    return baseVoucherFromJson(jsonVoucher);
  }

  static String getUserFirebaseUID() {
    print('SharedPrefs: getUserFirebaseUID');

    return _prefs.getString(_firebaseUserUid);
  }

  static User getUser() {
    print('SharedPrefs: getUser');

    String jsonUser = _prefs.getString(_currentUser);
    return userFromJson(jsonUser);
  }

  static List<Voucher> getActiveVouchers() {
    print('SharedPrefs: getActiveVouchers');
    List<Voucher> vouchers = [];

    _prefs.getStringList(_activeVouchers).forEach((String voucherString) {
      Map jsonData = json.decode(voucherString);
      Voucher voucher = Voucher.fromJson(jsonData);
      vouchers.add(voucher);
    });

    return vouchers;
  }
}
