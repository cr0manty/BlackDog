import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/status_bar_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'app_bar.dart';

class PageScaffold extends StatefulWidget {
  final ScrollController scrollController;
  final Widget action;
  final Widget leading;
  final Widget child;
  final List<Widget> children;
  final Widget title;
  final bool inAsyncCall;
  final double horizontalPadding;
  final bool shrinkWrap;
  final double titleMargin;
  final bool alwaysNavigation;
  final VoidCallback onRefresh;
  final Widget bottomWidget;

  PageScaffold(
      {this.scrollController,
      this.child,
      this.children,
      this.action,
      this.leading,
      this.title,
      this.horizontalPadding,
      this.onRefresh,
      this.bottomWidget,
      this.shrinkWrap = false,
      this.alwaysNavigation = false,
      this.inAsyncCall = false,
      this.titleMargin = 10})
      : assert(child != null || children != null),
        assert(bottomWidget != null && alwaysNavigation == true ||
            bottomWidget == null);

  @override
  State<StatefulWidget> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold>
    with SingleTickerProviderStateMixin {
  Widget _titleWidget() {
    if (widget.title != null) {
      return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 15, bottom: 15),
        width: ScreenSize.mainTextWidth,
        child: widget.title,
      );
    }
    return Container(height: widget.alwaysNavigation ? widget.titleMargin : 0);
  }

  List<Widget> _buildBodyChildren(List<Widget> listChildren) {
    if (widget.child == null) {
      return listChildren + widget.children;
    }
    listChildren.add(widget.child);
    return listChildren;
  }

  Widget buildRefresh(BuildContext context, List<Widget> children) {
    if (widget.onRefresh == null) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 0),
          child: ListView(
              controller: widget.scrollController,
              shrinkWrap: widget.shrinkWrap,
              children: children));
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 0),
      child: CustomScrollView(slivers: <Widget>[
        CupertinoSliverRefreshControl(onRefresh: widget.onRefresh),
        SliverList(delegate: SliverChildListDelegate(children))
      ]),
    );
  }

  Widget buildNavigationBody() {
    if (widget.alwaysNavigation) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          NavigationBar(
            action: widget.action,
            leading: widget.leading,
            alwaysNavigation: widget.alwaysNavigation,
          ),
          Expanded(
              child:
                  buildRefresh(context, _buildBodyChildren([_titleWidget()]))),
          widget.bottomWidget ?? Container()
        ],
      );
    }
    return buildRefresh(
        context,
        _buildBodyChildren([
          NavigationBar(
            action: widget.action,
            leading: widget.leading,
            alwaysNavigation: widget.alwaysNavigation,
          ),
          _titleWidget()
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
              onTap: FocusScope.of(context).unfocus,
              child: Container(
                  height: ScreenSize.height,
                  width: ScreenSize.width,
                  child: buildNavigationBody()),
            )),
        StatusBarColor(enabled: !widget.alwaysNavigation),
      ],
    ));
  }
}
