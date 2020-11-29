import 'dart:io';
import 'dart:ui';

import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:screen/screen.dart';

class Utils {
  static final Utils instance = Utils._internal();
  double brightness;
  Future _showPopUp;

  Utils._internal();

  static String get loadImage => 'assets/images/card_background.png';

  static String get bannerImage => 'assets/images/banner.png';

  static String get backgroundImage => 'assets/images/background.png';

  static String get logo => 'assets/images/logo.png';

  void initScreenSize(MediaQueryData query) {
    ScreenSize.height = query.size.height;
    ScreenSize.width = query.size.width;
    ScreenSize.pixelRatio = query.devicePixelRatio;
    initTextSize(query);
  }

  void initTextSize(MediaQueryData query) {
    TextSize.extraSmall = 12;
    TextSize.small = 15;
    TextSize.large = 20;
    TextSize.extra = 30;

    if (query.textScaleFactor > 1) {
      TextSize.extraSmall /= query.textScaleFactor;
      TextSize.small /= query.textScaleFactor;
      TextSize.large /= query.textScaleFactor;
      TextSize.extra /= query.textScaleFactor;
    }
  }

  bool get popUpOnScreen => _showPopUp != null;

  String showDateFormat(DateTime date) {
    if (date == null) {
      return null;
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  void logoutAsk(BuildContext context, VoidCallback onConfirm) {
    _showPopUp = showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              content: Text(AppLocalizations.of(context).translate('exit_text'),
                  style: Utils.instance.getTextStyle('subtitle2')),
              actions: [
                CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).translate('exit'),
                        style: Utils.instance
                            .getTextStyle('subtitle2')
                            .copyWith(color: HexColor.errorRed)),
                    onPressed: () {
                      onConfirm();
                      _showPopUp = null;
                    }),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(AppLocalizations.of(context).translate('cancel'),
                      style: Utils.instance
                          .getTextStyle('subtitle2')
                          .copyWith(color: CupertinoColors.activeBlue)),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            )).then((value) => _showPopUp = null);
  }

  void infoDialog(BuildContext context, String content,
      {String label}) {
    if (_showPopUp != null) {
      return;
    }

    String contentText = !ConnectionsCheck.instance.isOnline
        ? AppLocalizations.of(context).translate('no_internet')
        : content;

    _showPopUp = showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              title: label != null
                  ? Text(
                      label,
                      style: Utils.instance.getTextStyle('subtitle1'),
                    )
                  : null,
              content: Text(contentText,
                  style: Utils.instance.getTextStyle('subtitle2')),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK',
                      style: Utils.instance
                          .getTextStyle('subtitle2')
                          .copyWith(color: CupertinoColors.activeBlue)),
                  onPressed: () {
                    _showPopUp = null;
                    Navigator.of(context).pop();
                  },
                )
              ],
            )).then((value) => _showPopUp = null);
  }

  Widget showValidateError(
    Map fieldsError, {
    String key,
    bool bottomPadding = true,
  }) {
    fieldsError ??= {};
    if (fieldsError.containsKey(key)) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              bottom: bottomPadding ? ScreenSize.elementIndentHeight : 0),
          child: Text(fieldsError[key],
              style: Utils.instance.getTextStyle('error')));
    }
    return SizedBox(height: bottomPadding ? ScreenSize.elementIndentHeight : 0);
  }

  void showQRCodeModal(BuildContext context,
      {@required String codeUrl,
      String textKey = 'scan_qr',
      bool isLocal = true}) async {
    Widget codeImage;
    if (isLocal) {
      File qrCode = File(codeUrl);

      if (qrCode.existsSync()) {
        codeImage = Image.file(qrCode,
            height: ScreenSize.qrCodeHeight, width: ScreenSize.width);
      }
    } else {
      codeImage = ImageView(codeUrl);
    }
    if (codeImage == null) {
      infoDialog(
        context,
        AppLocalizations.of(context).translate('error'),
      );
    } else {
      if (_showPopUp != null) {
        return;
      }
      brightness = await Screen.brightness;
      await Screen.setBrightness(1.0);

      _showPopUp = showCupertinoDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: true,
          builder: (context) => CupertinoAlertDialog(
                title: Text(AppLocalizations.of(context).translate(textKey),
                    style: Utils.instance.getTextStyle('headline1')),
                content: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: codeImage,
                ),
              )).then((_) {
        _showPopUp = null;
        Screen.setBrightness(brightness);
      });
    }
  }

  void showTermPolicy(
      BuildContext context, Future func, String textKey, String key) {
    func.then((value) {
      if (value['result'] && ConnectionsCheck.instance.isOnline) {
        if (_showPopUp != null) {
          return;
        }
        _showPopUp = showCupertinoDialog(
            context: context,
            useRootNavigator: false,
            barrierDismissible: true,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(AppLocalizations.of(context).translate(textKey),
                      style: Utils.instance.getTextStyle('headline1')),
                  content: Text(value[key],
                      style: Utils.instance.getTextStyle('subtitle2')),
                )).then((_) => _showPopUp = null);
      } else {
        infoDialog(
          context,
          AppLocalizations.of(context).translate(
            ConnectionsCheck.instance.isOnline ? 'error' : 'no_internet',
          ),
        );
      }
    });
  }

  TextStyle getTextStyle(String name) {
    switch (name) {
      case 'caption':
        return TextStyle(
            fontFamily: 'Lemon-Milk',
            fontSize: TextSize.large,
            color: HexColor.lightElement);
      case 'headline1':
        return TextStyle(
            fontFamily: 'Lemon-Milk',
            fontSize: TextSize.small,
            color: HexColor.lightElement);
      case 'headline2':
        return TextStyle(
            fontFamily: 'Lemon-Milk',
            fontSize: TextSize.small,
            color: HexColor.darkElement);
      case 'subtitle1':
        return TextStyle(
            fontFamily: 'Century-Gothic',
            fontSize: TextSize.large,
            color: HexColor.lightElement);
      case 'subtitle2':
        return TextStyle(
            fontFamily: 'Century-Gothic',
            fontSize: TextSize.small,
            color: HexColor.lightElement);
      case 'bodyText1':
        return TextStyle(
            fontFamily: 'Century-Gothic',
            fontSize: TextSize.large,
            color: HexColor.semiElement);
      case 'bodyText2':
        return TextStyle(
            fontFamily: 'Century-Gothic',
            fontSize: TextSize.small,
            color: HexColor.semiElement);
      case 'error':
        return TextStyle(
          color: HexColor('#ff0000').withOpacity(0.9),
          fontSize: 12,
          fontFamily: 'Century-Gothic',
        );
      default:
        return TextStyle(
            fontFamily: 'Century-Gothic',
            fontSize: TextSize.small,
            color: HexColor.semiElement);
    }
  }

  void closePopUp(BuildContext context) {
    if (_showPopUp != null) {
      Navigator.of(context).pop();
      _showPopUp = null;
    }
  }
}
