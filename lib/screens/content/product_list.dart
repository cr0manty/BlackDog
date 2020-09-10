import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/screens/content/product_detail.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final String title;
  final int id;

  ProductList({this.title, this.id});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      scrollController: _scrollController,
      alwaysNavigation: true,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('home'),
        color: Colors.white,
        onTap: Navigator.of(context).pop,
      ),
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.caption,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      children: List.generate(_menu.length, _buildProduct),
    );
  }

  Widget _buildProduct(int index) {
    if (index == _menu.length) {
      return Container(
        padding: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        height: showProgress ? 50 : 0,
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    MenuItem menu = _menu[index];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => ProductDetail(product: menu))),
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: ScreenSize.menuItemSize,
              height: ScreenSize.menuItemSize,
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
                      style: Theme.of(context).textTheme.headline1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: ScreenSize.sectionIndent / 2),
                  SizedBox(
                      width: ScreenSize.mainTextWidth,
                      child: Text(
                        menu.priceWithCurrency(context) ?? '',
                        style: Theme.of(context).textTheme.subtitle1,
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
}
