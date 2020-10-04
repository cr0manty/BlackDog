import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/status_bar_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'app_bar.dart';

class PageScaffold extends StatefulWidget {
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
  final VoidCallback onRefresh;

  PageScaffold(
      {this.scrollController,
      this.child,
      this.children,
      this.navigationBar,
      this.title,
      this.padding,
      this.onRefresh,
      this.shrinkWrap = false,
      this.alwaysNavigation = false,
      this.inAsyncCall = false,
      this.titleMargin = true})
      : assert(child != null || children != null);

  @override
  State<StatefulWidget> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold>
    with SingleTickerProviderStateMixin {
  Widget _titleWidget() {
    if (widget.title != null) {
      return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 0, bottom: 15),
        width: ScreenSize.mainTextWidth,
        child: widget.title,
      );
    }
    return Container(
        height: widget.alwaysNavigation && widget.titleMargin ? 10 : 0);
  }

  List<Widget> _buildBodyChildren(List<Widget> listChildren) {
    if (widget.child == null) {
      return listChildren + widget.children;
    }
    listChildren.add(widget.child);
    return listChildren;
  }

  Widget buildRefresh(BuildContext context, Widget child) {
    if (widget.onRefresh == null) {
      return child;
    }
    return Container(
      margin: EdgeInsets.only(
          top: widget.alwaysNavigation
              ? MediaQuery.of(context).padding.top + 50
              : 0),
      child: CustomScrollView(slivers: <Widget>[
        CupertinoSliverRefreshControl(onRefresh: widget.onRefresh),
        SliverList(
            delegate:
                SliverChildListDelegate(_buildBodyChildren([_titleWidget()])))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: widget.navigationBar,
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
                inAsyncCall: widget.inAsyncCall,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Container(
                      margin: EdgeInsets.only(
                          top: widget.alwaysNavigation
                              ? MediaQuery.of(context).padding.top + 10
                              : 0),
                      height: ScreenSize.height,
                      width: ScreenSize.width,
                      child: buildRefresh(
                          context,
                          Container(
                            padding: widget.padding ?? EdgeInsets.zero,
                            child: ListView(
                              controller: widget.scrollController,
                              shrinkWrap: widget.shrinkWrap,
                              children: _buildBodyChildren([_titleWidget()]),
                            ),
                          ))),
                )),
            StatusBarColor(enabled: !widget.alwaysNavigation),
          ],
        ));
  }
}
