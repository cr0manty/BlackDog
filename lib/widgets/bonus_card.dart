import 'dart:io';

import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:black_dog/instances/utils.dart';

class BonusCard extends StatelessWidget {
  final bool isStaff;

  BonusCard({this.isStaff = false});

  @override
  Widget build(BuildContext context) {
    return isStaff
        ? Container()
        : GestureDetector(
            onTap: () => Utils.showQRCodeModal(context,
                codeUrl: SharedPrefs.getQRCode()),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: HexColor.darkElement,
                ),
                height: ScreenSize.bonusCardSize,
                margin: EdgeInsets.only(bottom: 5)));
  }
}
