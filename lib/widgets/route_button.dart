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

  RouteButton(
      {this.icon,
      this.text,
      this.onTap,
      this.color,
      this.textColor,
      this.iconColor,
      this.iconFirst = true})
      : assert(icon != null || text != null),
        _indent = icon != null && text != null ? 5 : 0;

  List<Widget> _iconFirstBuild() {
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
              style: TextStyle(fontSize: 15, color: textColor ?? Colors.black),
            )
          : Container()
    ];
  }

  List<Widget> _iconNotFirstWidget() {
    return <Widget>[
      text != null
          ? Text(
              text,
              style: TextStyle(fontSize: 15, color: textColor ?? Colors.black),
            )
          : Container(),
      SizedBox(width: _indent),
      icon != null
          ? Icon(
              icon,
              size: 20,
              color: iconColor ?? Colors.black,
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: iconFirst ? _iconFirstBuild() : _iconNotFirstWidget(),
        ),
      ),
    );
  }
}
