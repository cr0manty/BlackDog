import 'dart:ui';

import 'package:black_dog/screens/auth/sign_in.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/home_page.dart';
import 'file:///C:/Users/Cr0manty/AndroidStudioProjects/BlackDog/lib/screens/staff/staff_home.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
    SharedPrefs.saveLanguageCode(window.locale.languageCode);
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
    debugPrefixPrint(
        'Device country code: ${locale.countryCode ?? ''}',
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
