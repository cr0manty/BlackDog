import 'dart:ui';

import 'package:black_dog/bloc/staff_bloc/staff_bloc.dart';
import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/notification_manager.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/network/api.dart';
import 'package:black_dog/router/router.dart';
import 'package:black_dog/screens/auth/sign_in.dart';
import 'package:black_dog/screens/home_page/home_view.dart';
import 'package:black_dog/screens/staff/staff_home_view.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class BlackDogApp extends StatefulWidget {
  @override
  _BlackDogAppState createState() => _BlackDogAppState();
}

class _BlackDogAppState extends State<BlackDogApp> {
  AppRouteGenerator router = AppRouteGenerator();
  void initWithContext(BuildContext context) async {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: HexColor.transparent));
    precacheImage(AssetImage(Utils.loadImage), context);
    precacheImage(AssetImage(Utils.bannerImage), context);
    precacheImage(AssetImage(Utils.logo), context);
    precacheImage(AssetImage(Utils.backgroundImage), context);
  }

  @override
  void initState() {
    super.initState();
    Account.instance.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initWithContext(context);
  }

  Locale _setSupportedLanguage(Locale locale) {
    debugPrefixPrint('Device language code: ${locale.languageCode}',
        prefix: 'lang');
    debugPrefixPrint('Device country code: ${locale.countryCode ?? ''}',
        prefix: 'lang');

    SharedPrefs.saveLanguageCode(locale.languageCode);
    return locale;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
        // Locale('uk', 'UA'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        AppLocalizations.cupertinoDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        for (Locale locale in locales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return _setSupportedLanguage(supportedLocale);
            }
          }
        }
        return _setSupportedLanguage(supportedLocales.first);
      },
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromRGBO(40, 39, 41, 1),
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: initialRoute,
    );
  }

  String get initialRoute {
    switch (Account.instance.state) {
      case AccountState.GUEST:
        return "/sign_in";
      default:
        return '/';
    }
  }

  @override
  void dispose() {
    router.dispose();
    Api.instance.dispose();
    NotificationManager.instance.dispose();
    ConnectionsCheck.instance.dispose();
    super.dispose();
  }
}
