import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/status_bar_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'app_bar.dart';

class PageScaffold extends StatelessWidget {
  final ScrollController scrollController;
  final NavigationBar navigationBar;
  final Widget child;
  final List<Widget> children;
  final Widget title;
  final bool inAsyncCall;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final bool titleMargin;
  final bool alwaysNavigation;

  PageScaffold(
      {this.scrollController,
      this.child,
      this.children,
      this.navigationBar,
      this.title,
      this.padding,
      this.shrinkWrap = false,
      this.alwaysNavigation = false,
      this.inAsyncCall = false,
      this.titleMargin = true})
      : assert(child != null || children != null);

  Widget _titleWidget() {
    if (title != null) {
      return Container(
        alignment: Alignment.topCenter,
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

  Widget navigationBody(BuildContext context) {
    if (alwaysNavigation) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Container(
                  padding: padding ?? EdgeInsets.zero,
                  child:  ListView(
                        controller: scrollController,
                        shrinkWrap: shrinkWrap,
                        children: _buildBodyChildren(<Widget>[_titleWidget()]),
                  )))
        ],
      );
    }
    return Container(
      child: ListView(
        controller: scrollController,
        shrinkWrap: shrinkWrap,
        children: _buildBodyChildren([_titleWidget()]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: navigationBar,
        child: Stack(
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
                      margin: EdgeInsets.only(
                          top: alwaysNavigation
                              ? MediaQuery.of(context).padding.top + 10
                              : 0),
                      height: ScreenSize.height,
                      width: ScreenSize.width,
                      child:  navigationBody(context)),
                )),
            StatusBarColor(enabled: !alwaysNavigation),
          ],
        ));
  }
}
