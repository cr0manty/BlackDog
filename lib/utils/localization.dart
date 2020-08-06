import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  static _AppLocalizationsDelegate delegate = _AppLocalizationsDelegate();

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String fileName =
        '${locale.languageCode}_${locale.countryCode.toLowerCase()}.json';
    String jsonString = await rootBundle.loadString('assets/lang/$fileName');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  static const List _supportedLanguages = ['en', 'ru', 'ua'];

  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return _supportedLanguages.contains(locale.languageCode) ||
        _supportedLanguages.contains(locale.countryCode.toLowerCase());
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
