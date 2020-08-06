import 'package:black_dog/instances/api.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/screens/sign_in.dart';
import 'package:black_dog/utils/connection_check.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: HexColor.darkElement.withOpacity(0.6),
        statusBarBrightness: Brightness.dark));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('uk', 'UA'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        AppLocalizations.cupertinoDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        for (Locale locale in locales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              print('Device language code: ${locale.languageCode}');
              print('Device country code: ${locale.countryCode ?? ''}');
              SharedPrefs.saveLanguageCode(locale.languageCode);
              return supportedLocale;
            }
          }
        }

        print('Device language code: ${supportedLocales.first.languageCode}');
        print(
            'Device country code: ${supportedLocales.first.countryCode ?? ''}');

        SharedPrefs.saveLanguageCode(supportedLocales.first.languageCode);
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
