import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:flutter_svg/svg.dart';

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
                width: ScreenSize.width -52,
                margin: EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  Utils.bannerImage,
                  fit: BoxFit.fill,
                )));
  }
}
