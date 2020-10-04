import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';

class NavigationBar extends StatelessWidget
    with ObstructingPreferredSizeWidget {
  final Widget leading;
  final Widget action;
  final bool alwaysNavigation;

  NavigationBar({this.alwaysNavigation = true, this.action, this.leading});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: alwaysNavigation
          ? HexColor.black.withOpacity(0.6)
          : HexColor.transparent,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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

  @override
  Size get preferredSize => Size.fromHeight(alwaysNavigation ? 50 : 0);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return false;
  }
}
