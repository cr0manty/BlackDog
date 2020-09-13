import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PageScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ScrollController scrollController;
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
      {this.scrollController,
      this.scaffoldKey,
      this.child,
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
      color:
          alwaysNavigation ? Colors.black.withOpacity(0.4) : Colors.transparent,
      child: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            leading ?? Container(),
            action ?? Container(),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    if (title != null) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 0, bottom: 15),
        width: ScreenSize.mainTextWidth,
        child: title,
      );
    }
    return Container(height: alwaysNavigation && titleMargin ? 10 : 0);
  }

  List<Widget> _buildBodyChildren(List<Widget> listChildren) {
    if (child == null) {
      return listChildren + children;
    }
    listChildren.add(child);
    return listChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            Positioned(
                top: 0.0,
                child: Container(
                  height: ScreenSize.height,
                  width: ScreenSize.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(Utils.backgroundImage),
                    fit: BoxFit.fill,
                  )),
                )),
            ModalProgressHUD(
                progressIndicator: CupertinoActivityIndicator(),
                inAsyncCall: inAsyncCall,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Container(
                      height: ScreenSize.height,
                      width: ScreenSize.width,
                      child: ScrollConfiguration(
                        behavior: ScrollGlow(),
                        child: alwaysNavigation
                            ? Column(
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
                                                controller: scrollController,
                                                shrinkWrap: shrinkWrap,
                                                children: _buildBodyChildren(
                                                    <Widget>[_titleWidget()])),
                                          )))
                                ],
                              )
                            : Container(
                                child: ListView(
                                  controller: scrollController,
                                  shrinkWrap: shrinkWrap,
                                  children: _buildBodyChildren(
                                      [_appBar(), _titleWidget()]),
                                ),
                              ),
                      )),
                )),
          ],
        ));
  }
}
