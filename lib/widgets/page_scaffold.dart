import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PageScaffold extends StatelessWidget {
  final Widget action;
  final Widget leading;
  final Widget child;
  final List<Widget> children;
  final bool alwaysNavigation;
  final Widget title;
  final bool inAsyncCall;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final bool titleMargin;

  PageScaffold(
      {this.child,
      this.children,
      this.action,
      this.leading,
      this.title,
      this.padding,
      this.shrinkWrap = false,
      this.alwaysNavigation = false,
      this.inAsyncCall = false,
      this.titleMargin = true})
      : assert(child != null || children != null);

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

  Widget _titleWidget() {
    if (title != null) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 5, bottom: 20),
        child: title,
      );
    }
    return Container(height: alwaysNavigation && titleMargin ? 20 : 0);
  }

  List<Widget> _buildBodyChildren(List<Widget> listChildren) {
    if (child == null) {
      return listChildren + children;
    }
    listChildren.add(Container(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    ));
    return listChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      progressIndicator: CupertinoActivityIndicator(),
      inAsyncCall: inAsyncCall,
      child: Container(
          height: ScreenSize.height,
          child: alwaysNavigation
              ? SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                      _appBar(),
                      Expanded(
                          child: Container(
                              padding: padding ?? EdgeInsets.zero,
                              child: ScrollConfiguration(
                                behavior: ScrollGlow(),
                                child: ListView(
                                    shrinkWrap: shrinkWrap,
                                    children: _buildBodyChildren(
                                        <Widget>[_titleWidget()])),
                              )))
                    ]))
              : ScrollConfiguration(
                  behavior: ScrollGlow(),
                  child: ListView(
                    shrinkWrap: shrinkWrap,
                    children: _buildBodyChildren([_appBar(), _titleWidget()]),
                  ),
                )),
    ));
  }
}
