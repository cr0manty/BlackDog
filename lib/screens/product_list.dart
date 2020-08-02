import 'package:black_dog/instances/api.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:html/dom.dart' as dom;

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
      leading: RouteButton(
        icon: SFSymbols.chevron_left,
        text: 'На Главную',
        color: Colors.white,
        onTap: Navigator.of(context).pop,
      ),
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 30),
      ),
      child: Container(
        height: ScreenSize.height,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: List.generate(_menu.length, _buildNews),
        ),
      ),
    );
  }

  Widget _buildNews(int index) {
    MenuItem menu = _menu[index];
    return GestureDetector(
      child: Container(
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
                      : Container(color: Colors.grey,)),
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
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: ScreenSize.sectionIndent / 2),
                  Text(
                    menu.priceWithCurrency ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.white),
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
