import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final double _indent;

  RouteButton({this.icon, this.text, this.onTap})
      : assert(icon != null || text != null),
        _indent = icon != null && text != null ? 5 : 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            icon != null
                ? Icon(
                    icon,
                    size: 20,
                    color: Colors.black,
                  )
                : Container(height: 17, margin: EdgeInsets.only(top: 3),),
            SizedBox(width: _indent),
            text != null
                ? Text(
                    text,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
