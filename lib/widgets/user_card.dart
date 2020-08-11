import 'dart:ui';

import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final bool isStaff;
  final String username;
  final Function onPressed;
  final Widget additionWidget;
  final Widget trailing;

  UserCard({
    @required this.username,
    @required this.onPressed,
    this.additionWidget,
    this.trailing,
    this.isStaff = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
            top: isStaff ? 0 : 16, left: 16, right: 16, bottom: 8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor.cardBackground),
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                onPressed: onPressed,
                child: Text(
                  username,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              trailing ?? Container()
            ],
          ),
          additionWidget != null
              ? SizedBox(height: ScreenSize.elementIndentHeight)
              : Container(),
          additionWidget ?? Container()
        ]),
      ),
    );
  }
}
