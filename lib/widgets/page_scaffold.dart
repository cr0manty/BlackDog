import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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

  Widget _appBar(BuildContext context) {
    return Container(
      color:
          alwaysNavigation ? Colors.black.withOpacity(0.4) : Colors.transparent,
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
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              header: WaterDropHeader(),
              onRefresh: () async {
                // monitor network fetch
                await Future.delayed(Duration(milliseconds: 1000));
                // if failed,use refreshFailed()
                _refreshController.refreshCompleted();
              },
              child: ModalProgressHUD(
                  progressIndicator: CupertinoActivityIndicator(),
                  inAsyncCall: inAsyncCall,
                  child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusNode()),
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
                                    _appBar(context),
                                    Expanded(
                                        child: Container(
                                            padding: padding ?? EdgeInsets.zero,
                                            child: ScrollConfiguration(
                                              behavior: ScrollGlow(),
                                              child: ListView(
                                                  controller: scrollController,
                                                  shrinkWrap: shrinkWrap,
                                                  children: _buildBodyChildren(<
                                                      Widget>[_titleWidget()])),
                                            )))
                                  ],
                                )
                              : Container(
                                  child: ListView(
                                    controller: scrollController,
                                    shrinkWrap: shrinkWrap,
                                    children: _buildBodyChildren(
                                        [_appBar(context), _titleWidget()]),
                                  ),
                                ),
                        )),
                  )),
            )
          ],
        ));
  }
}
