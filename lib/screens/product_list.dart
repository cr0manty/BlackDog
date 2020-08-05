import 'package:black_dog/instances/api.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/screens/product_detail.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class ProductList extends StatefulWidget {
  final String title;
  final int id;

  ProductList({this.title, this.id});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<MenuItem> _menu = [];

  Future _getMenu() async {
    List<MenuItem> menu = await Api.instance.getMenu(widget.id);
    setState(() {
      _menu = menu;
    });
  }

  @override
  void initState() {
    super.initState();
    _getMenu();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
        icon: SFSymbols.chevron_left,
        text: AppLocalizations.of(context).translate('home'),
        color: Colors.white,
        onTap: Navigator.of(context).pop,
      ),
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.caption,
      ),
      children: List.generate(_menu.length, _buildProduct),
    );
  }

  Widget _buildProduct(int index) {
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
                  child: menu.image != null
                      ? Image.network(menu.image, fit: BoxFit.cover)
                      : Container(color: HexColor.semiElement)),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    menu.capitalizeTitle,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: ScreenSize.sectionIndent / 2),
                  Text(
                    menu.priceWithCurrency ?? '',
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
