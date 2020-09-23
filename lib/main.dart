import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/screens/staff_home.dart';
import 'package:black_dog/screens/user//sign_in.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'instances/account.dart';
import 'instances/api.dart';
import 'instances/connection_check.dart';
import 'instances/notification_manager.dart';
import 'instances/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SharedPrefs.getInstance() == null) {
    await SharedPrefs.initialize();
  }

  ConnectionsCheck.instance.initialise();
  await NotificationManager.instance.configure();

  // Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  Firebase.initializeApp();

  runApp(BlackDogApp());
}

class BlackDogApp extends StatefulWidget {
  @override
  _BlackDogAppState createState() => _BlackDogAppState();
}

class _BlackDogAppState extends State<BlackDogApp> {
  void initWithContext(BuildContext context) {
    precacheImage(AssetImage(Utils.defaultImage), context);
    precacheImage(AssetImage(Utils.loadImage), context);
    precacheImage(AssetImage(Utils.bannerImage), context);
    precacheImage(AssetImage(Utils.logo), context);
    precacheImage(AssetImage(Utils.backgroundImage), context);
  }

  @override
  void initState() {
    Account.instance.initialize();
    configurePopUp();
    super.initState();
  }

  void configurePopUp() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..displayDuration = const Duration(seconds: 1)
      ..progressColor = Colors.white
      ..indicatorSize = 50
      ..radius = 10.0
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..backgroundColor = Colors.red.withOpacity(0.8);
  }

  @override
  Widget build(BuildContext context) {
    initWithContext(context);

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
        print('Device language code: ${currentLocale.languageCode}');
        print('Device country code: ${currentLocale.countryCode ?? ''}');

        SharedPrefs.saveLanguageCode(currentLocale.languageCode);
        return currentLocale;
      },
      theme: ThemeData(
        textSelectionColor: Colors.grey.withOpacity(0.5),
        textSelectionHandleColor: Colors.grey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: HexColor.backgroundColor,
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
