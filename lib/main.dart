
import 'package:black_dog/screens/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

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

