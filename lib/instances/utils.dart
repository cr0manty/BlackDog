import 'dart:ui';

import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Utils {
  static String get loadImage => 'assets/images/card_background.png';

  static String get defaultImage => 'assets/images/card_background.png';

  static dynamic showSuccessPopUp(BuildContext context, {String text}) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            text ?? AppLocalizations.of(context).translate('success'),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('OK'), onPressed: () => Navigator.pop(context))
          ],
        );
      },
    );
  }

  static dynamic showErrorPopUp(BuildContext context, {String text}) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            text ?? AppLocalizations.of(context).translate('error'),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('OK'), onPressed: () => Navigator.pop(context))
          ],
        );
      },
    );
  }

  static void initScreenSize(Size size) {
    ScreenSize.height = size.height;
    ScreenSize.width = size.width;
  }

  static String dateFormat(DateTime date) {
    if (date == null) {
      return null;
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  static Widget showValidateError(Map fieldsError,
      {String key, bool bottomPadding = true}) {
    if (fieldsError.containsKey(key)) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              bottom: bottomPadding ? ScreenSize.elementIndentHeight : 0),
          child: Text(fieldsError[key],
              style:
                  TextStyle(color: Colors.red.withOpacity(0.9), fontSize: 12)));
    } else if (fieldsError.containsKey('all')) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              bottom: bottomPadding ? ScreenSize.elementIndentHeight : 0),
          child: Text(fieldsError['all'],
              style:
                  TextStyle(color: Colors.red.withOpacity(0.9), fontSize: 12)));
    }
    return SizedBox(height: bottomPadding ? ScreenSize.elementIndentHeight : 0);
  }
}
