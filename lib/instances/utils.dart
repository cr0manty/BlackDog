import 'dart:ui';

import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';

abstract class Utils {
  static void showPopUp() {}

  static dynamic showSuccessPopUp() {}

  static dynamic showErrorPopUp(BuildContext context, {String text = 'Error'}) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(text),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('OK'), onPressed: () => Navigator.pop(context))
          ],
        );
      },
    );
  }

  static void initScreenSize(Size size) {
    if (ScreenSize.height == null || ScreenSize.width == null) {
      ScreenSize.height = size.height;
      ScreenSize.width = size.width;
    }
  }
}
