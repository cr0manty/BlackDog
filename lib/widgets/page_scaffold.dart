import 'package:black_dog/instances/size.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  final Widget action;
  final Widget leading;
  final Widget child;

  PageScaffold({@required this.child, this.action, this.leading});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: ScreenSize.height,
          child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    leading ?? Container(),
                    action ?? Container(),
                  ],
                ),
                child,
              ],
            ),
        ),
      ),
    );
  }
}
