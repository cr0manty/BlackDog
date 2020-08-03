import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final bool iconFirst;
  final double _indent;
  final EdgeInsets padding;

  RouteButton({
    this.icon,
    this.text,
    this.onTap,
    this.color,
    this.textColor,
    this.iconColor,
    this.padding,
    this.iconFirst = true,
  })  : assert(icon != null || text != null),
        _indent = icon != null && text != null ? 5 : 0;

  List<Widget> _iconFirstBuild(BuildContext context) {
    return <Widget>[
      icon != null
          ? Icon(
              icon,
              size: 20,
              color: iconColor ?? Colors.black,
            )
          : Container(
              height: 17,
              margin: EdgeInsets.only(top: 3),
            ),
      SizedBox(width: _indent),
      text != null
          ? Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: textColor ?? HexColor.darkElement),
            )
          : Container()
    ];
  }

  List<Widget> _iconNotFirstWidget(BuildContext context) {
    return <Widget>[
      text != null
          ? Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: textColor ?? HexColor.darkElement),
            )
          : Container(),
      SizedBox(width: _indent),
      icon != null
          ? Icon(
              icon,
              size: 20,
              color: iconColor ?? HexColor.darkElement,
            )
          : Container(
              height: 17,
              margin: EdgeInsets.only(top: 3),
            )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color ?? Colors.transparent,
        ),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: iconFirst
              ? _iconFirstBuild(context)
              : _iconNotFirstWidget(context),
        ),
      ),
    );
  }
}
