import 'dart:io';

import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BonusCard extends StatelessWidget {
  final bool isStaff;

  BonusCard({this.isStaff = false});

  void _showQRCodeModal(BuildContext context) {
    File qrCode = File(SharedPrefs.getQRCode());
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).translate('scan_qr')),
              content: Container(
                padding: EdgeInsets.only(top: 25),
                child: Image.file(
                  qrCode,
                  height: ScreenSize.qrCodeHeight,
                  width: ScreenSize.width,
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return isStaff
        ? Container()
        : GestureDetector(
            onTap: () => _showQRCodeModal(context),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: HexColor.darkElement,
                ),
                height: ScreenSize.bonusCardSize,
                padding: EdgeInsets.all(10)));
  }
}
