import 'dart:ui';

import 'package:black_dog/screens/auth/sign_in.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/screens/staff_home.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'instances/account.dart';
import 'instances/api.dart';
import 'instances/connection_check.dart';
import 'instances/notification_manager.dart';
import 'instances/shared_pref.dart';

// flutter build apk --no-shrink  - command to build release build
// need to add `--no-shrink` because of SharedPreferences not support `await` on android release build
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initialize();
  ConnectionsCheck.instance.initialise();

  await NotificationManager.instance.configure();
  Firebase.initializeApp();

  runApp(BlackDogApp());
}

class BlackDogApp extends StatefulWidget {
  @override
  _BlackDogAppState createState() => _BlackDogAppState();
}

class _BlackDogAppState extends State<BlackDogApp> {
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
    configurePopUp();

    SharedPrefs.saveLanguageCode(window.locale.languageCode);
    Account.instance.initialize();
  }

  void configurePopUp() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..displayDuration = const Duration(seconds: 1)
      ..progressColor = CupertinoColors.white
      ..indicatorSize = 50
      ..radius = 10.0
      ..indicatorColor = CupertinoColors.white
      ..textColor = CupertinoColors.white
      ..backgroundColor = HexColor.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    initWithContext(context);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
        Locale('uk', 'UA'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        AppLocalizations.cupertinoDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        Locale currentLocale;
        for (Locale locale in locales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              currentLocale = supportedLocale;
              break;
            }
          }
        }
        currentLocale ??= supportedLocales.first;
        debugPrefixPrint('Device language code: ${currentLocale.languageCode}',
            prefix: 'lang');
        debugPrefixPrint(
            'Device country code: ${currentLocale.countryCode ?? ''}',
            prefix: 'lang');

        SharedPrefs.saveLanguageCode(currentLocale.languageCode);
        return currentLocale;
      },
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromRGBO(40, 39, 41, 1),
      ),
      builder: (BuildContext context, Widget child) {
        return FlutterEasyLoading(
          child: child,
        );
      },
      home: switchPages(),
    );
  }

  Widget switchPages() {
    switch (Account.instance.state) {
      case AccountState.GUEST:
        return SignInPage();
      case AccountState.STAFF:
        return StaffHomePage();
      case AccountState.USER:
        return HomePage();
      default:
        return Container();
    }
  }

  @override
  void dispose() {
    Api.instance.dispose();
    NotificationManager.instance.dispose();
    ConnectionsCheck.instance.dispose();
    super.dispose();
  }
}
