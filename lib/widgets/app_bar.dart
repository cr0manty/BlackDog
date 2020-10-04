import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';

class NavigationBar extends StatelessWidget {
  final Widget leading;
  final Widget action;
  final bool alwaysNavigation;

  NavigationBar(
      {Key key, this.alwaysNavigation = true, this.action, this.leading});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: alwaysNavigation
          ? HexColor.black.withOpacity(0.6)
          : HexColor.transparent,
      padding: EdgeInsets.only(
          top: alwaysNavigation ? MediaQuery.of(context).padding.top : 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leading ?? Container(),
          action ?? Container(),
        ],
      ),
    );
  }

}
