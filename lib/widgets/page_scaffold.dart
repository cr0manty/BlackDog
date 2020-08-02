import 'package:black_dog/utils/size.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  final Widget action;
  final Widget leading;
  final Widget child;
  final bool alwaysNavigation;
  final Widget title;

  PageScaffold(
      {@required this.child,
      this.action,
      this.leading,
      this.title,
      this.alwaysNavigation = false});

  Widget _appBar() {
    return Container(
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: ScreenSize.height,
          child: alwaysNavigation
              ? SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _appBar(),
                        title != null
                            ? Container(
                                padding: EdgeInsets.only(top: 5, bottom: 20),
                                child: title)
                            : Container(),
                        Expanded(child: ListView(children: <Widget>[child]))
                      ]),
                )
              : ListView(
                  shrinkWrap: true,
                  children: [
                    _appBar(),
                    title != null
                        ? Container(
                            padding: EdgeInsets.only(top: 5, bottom: 20),
                            child: title)
                        : Container(),
                    child
                  ],
                )),
    );
  }
}
