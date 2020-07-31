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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.grey.withOpacity(0.4),
        ),
        margin: EdgeInsets.only(top: isStaff ? 0 : 16, left: 16, right: 18),
        padding: EdgeInsets.only(left: 11, right: 10, top: 12, bottom: 14),
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
                  style: TextStyle(color: Colors.white, fontSize: 24),
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
