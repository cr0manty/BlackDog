import 'dart:async';

import 'package:black_dog/network/api.dart';
import 'package:black_dog/instances/connection_check.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/screens/content/product_detail.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';

class ProductList extends StatefulWidget {
  final String title;
  final int id;

  ProductList({this.title, this.id});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _connectionChange;

  List<MenuItem> _menu = [];
  bool showProgress = true;
  int page = 0;

  Future _getMenu() async {
    List<MenuItem> menu = await Api.instance.getMenu(widget.id);
    setState(() {
      _menu = menu;
    });
  }

  void _scrollListener() async {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        _menu.length % Api.defaultPerPage == 0) {
      setState(() => showProgress = true);
      await _getMenu();
      setState(() => showProgress = false);
    }
  }

  @override
  void initState() {
    _getMenu();
    _scrollController.addListener(_scrollListener);
    _connectionChange =
        ConnectionsCheck.instance.onChange.listen((_) => _getMenu());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      scrollController: _scrollController,
      alwaysNavigation: true,
      shrinkWrap: true,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500), () async {
          _menu = [];
          page = 0;
          await _getMenu();
        });
      },
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: CupertinoColors.white,
        onTap: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.title,
        style: Utils.instance.getTextStyle('caption'),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      children: List.generate(_menu.length, _buildProduct),
    );
  }

  bool get needMargin => _menu.length % Api.defaultPerPage == 0;

  Widget _buildProduct(int index) {
    if (index == _menu.length) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: needMargin ? 10 : 0),
        alignment: Alignment.center,
        height: showProgress && needMargin ? 50 : 0,
        child: needMargin ? CupertinoActivityIndicator() : Container(),
      );
    }

    MenuItem menu = _menu[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => ProductDetail(product: menu))),
      child: Container(
        color: HexColor.transparent,
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: ScreenSize.menuItemSize,
              height: ScreenSize.menuItemSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageView(menu.image)),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: ScreenSize.mainTextWidth,
                    child: Text(
                      menu.capitalizeTitle,
                      style: Utils.instance.getTextStyle('headline1'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: ScreenSize.sectionIndent / 2),
                  SizedBox(
                      width: ScreenSize.mainTextWidth,
                      child: Text(
                        menu.priceWithCurrency(context) ?? '',
                        style: Utils.instance.getTextStyle('subtitle1'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _connectionChange?.cancel();
    super.dispose();
  }
}
