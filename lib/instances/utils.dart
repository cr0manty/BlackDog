import 'dart:io';
import 'dart:ui';

import 'package:black_dog/utils/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ScreenSize {
  static double height;
  static double width;

  static double get sectionIndent => height * 0.04;

  static double get scanQRCodeIndent => height * 0.05;

  static double get scanQRCodeSize => height * 0.17;

  static double get bonusCardSize => height * 0.12;

  static double get scanQRCodeIconSize => scanQRCodeSize * 0.85;

  static double get elementIndentHeight => height * 0.03;

  static double get mainMarginTop => height * 0.07;

  static double get elementIndentWidth => width * 0.02;

  static double get labelIndent => width * 0.005;

  static double get newsImageHeight => height * 0.18;

  static double get newsImageWidth => width * 0.34;

  static double get newsSmallBlockWidth => width * 0.3;

  static double get newsSmallBlockHeight => height * 0.15;

  static double get newsListImageSize => width * 0.3;

  static double get menuBlockHeight => 90;

  static double get voucherSize => 110;

  static double get qrCodeHeight => height * 0.3;

  static double get menuItemSize => height * 0.1;

  static double get menuItemPhotoSize => height * 0.45;

  static double get newsItemPhotoSize => height * 0.35;

  static double get newsListTextSize => width - newsListImageSize - 48;

  static double get qrCodeMargin => (width - scanQRCodeSize) / 2;

  static double get currentBonusSize => height * 0.2;
}

class Utils {
  static final Utils instance = Utils._internal();
  Future _showPopUp;

  Utils._internal();

  static String get loadImage => 'assets/images/card_background.png';

  static String get defaultImage => 'assets/images/card_background.png';

  static String get bannerImage => 'assets/images/banner.png';

  static String get backgroundImage => 'assets/images/background.png';

  static String get logo => 'assets/images/logo.png';

  static String get bonusIcon => 'assets/images/coffee.svg';

  void showSuccessPopUp(BuildContext context, {String text}) {
    if (_showPopUp != null) {
      return;
    }
    _showPopUp = showCupertinoDialog(
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
    ).then((_) => _showPopUp = null);
  }

  void showErrorPopUp(BuildContext context, {String text}) {
    _showPopUp = showCupertinoDialog(
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
    ).then((_) => _showPopUp = null);
  }

  void initScreenSize(Size size) {
    ScreenSize.height = size.height;
    ScreenSize.width = size.width;
  }

  String dateFormat(DateTime date) {
    if (date == null) {
      return null;
    }
    return '${date.year}-${date.month}-${date.day}';
  }

  String showDateFormat(DateTime date) {
    if (date == null) {
      return null;
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget showValidateError(Map fieldsError,
      {String key, bool bottomPadding = true}) {
    if (fieldsError.containsKey(key)) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              bottom: bottomPadding ? ScreenSize.elementIndentHeight : 0),
          child: Text(fieldsError[key],
              style: TextStyle(
                color: Colors.red.withOpacity(0.9),
                fontSize: 12,
                fontFamily: 'Century-Gothic',
              )));
    } else if (fieldsError.containsKey('all')) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              bottom: bottomPadding ? ScreenSize.elementIndentHeight : 0),
          child: Text(fieldsError['all'],
              style: TextStyle(
                color: Colors.red.withOpacity(0.9),
                fontSize: 12,
                fontFamily: 'Century-Gothic',
              )));
    }
    return SizedBox(height: bottomPadding ? ScreenSize.elementIndentHeight : 0);
  }

  void showQRCodeModal(BuildContext context,
      {@required String codeUrl,
      String textKey = 'scan_qr',
      bool isLocal = true}) async {
    Image codeImage;
    if (isLocal) {
      File qrCode = File(codeUrl);

      if (await qrCode.exists()) {
        codeImage = Image.file(qrCode,
            height: ScreenSize.qrCodeHeight, width: ScreenSize.width);
      }
    } else {
      codeImage = Image.network(codeUrl);
      await precacheImage(codeImage.image, context);
    }
    if (codeImage == null) {
      showErrorPopUp(context);
    } else {
      if (_showPopUp != null) {
        return;
      }
      _showPopUp = showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => CupertinoAlertDialog(
                title: Text(AppLocalizations.of(context).translate(textKey),
                    style: Theme.of(context).textTheme.caption),
                content: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: codeImage,
                ),
              )).then((_) => _showPopUp = null);
    }
  }
}
