import 'package:black_dog/screens/user/profile_settings.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class EditButton extends StatelessWidget {
  final bool fromHome;

  EditButton({this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => ProfileSettings(fromHome: fromHome))),
      padding: EdgeInsets.zero,
      child: Container(
        width: 31,
        height: 31,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: HexColor.lightElement),
        child: Icon(
          SFSymbols.pencil,
          size: 25,
          color: HexColor.darkElement,
        ),
      ),
    );
  }
}
