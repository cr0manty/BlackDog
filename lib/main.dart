import 'dart:ui';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/screens/sign_in.dart';
import 'package:black_dog/utils/connection_check.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'instances/account.dart';
import 'instances/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SharedPrefs.getInstance() == null) {
    await SharedPrefs.initialize();
  }

  Account.instance.initialize();
  ConnectionsCheck.instance.initialise();

  runApp(BlackDogApp());
}

class BlackDogApp extends StatefulWidget {
  @override
  _BlackDogAppState createState() => _BlackDogAppState();
}

class _BlackDogAppState extends State<BlackDogApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('en', 'UA'),

      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FallbackCupertinoLocalisationsDelegate(),
      ],
      localeListResolutionCallback: (locale, supportedLocales) {
        if (window.locale == null) {
          return supportedLocales.first;
        }

        print(
            'Device language code: ${window.locale.languageCode}, country code: ${window.locale.countryCode}');
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == window.locale.languageCode &&
              supportedLocale.countryCode == window.locale.countryCode)
            return supportedLocale;
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color.fromRGBO(37, 36, 39, 1),
          textTheme: TextTheme(
              caption: TextStyle(
                  fontFamily: 'Lemon-Milk',
                  fontSize: 20,
                  color: HexColor.lightElement),
              headline1: TextStyle(
                  fontFamily: 'Lemon-Milk',
                  fontSize: 15,
                  color: HexColor.lightElement),
              headline2: TextStyle(
                  fontFamily: 'Lemon-Milk',
                  fontSize: 15,
                  color: HexColor.darkElement),
              subtitle1: TextStyle(
                  fontFamily: 'Century-Gothic',
                  fontSize: 20,
                  color: HexColor.lightElement),
              subtitle2: TextStyle(
                  fontFamily: 'Century-Gothic',
                  fontSize: 15,
                  color: HexColor.lightElement),
              bodyText1: TextStyle(
                  fontFamily: 'Century-Gothic',
                  fontSize: 20,
                  color: HexColor.semiElement),
              bodyText2: TextStyle(
                  fontFamily: 'Century-Gothic',
                  fontSize: 15,
                  color: HexColor.semiElement))),
      home: Account.instance.state == AccountState.GUEST
          ? SignInPage()
          : HomePage(),
    );
  }

  @override
  void dispose() {
    Api.instance.dispose();
    super.dispose();
  }
}
