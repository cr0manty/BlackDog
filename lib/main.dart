import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/screens/sign_in.dart';
import 'package:black_dog/utils/connection_check.dart';
import 'package:flutter/material.dart';

import 'instances/account.dart';
import 'instances/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SharedPrefs.getInstance() == null) {
    SharedPrefs.init();
  }

  await ConnectionsCheck.instance.initialise();
  await Account.instance.init();

  runApp(BlackDogApp());
}

class BlackDogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Account.instance.state == AccountState.GUEST
            ? SignInPage
            : HomePage(),
    );
  }
}
