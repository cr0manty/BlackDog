import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class ProductDetail extends StatefulWidget {
  final MenuItem product;

  ProductDetail({@required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      leading: RouteButton(
        icon: SFSymbols.chevron_left,
        text: AppLocalizations.of(context).translate('products'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                    width: ScreenSize.width - 32,
                    height: ScreenSize.menuItemPhotoSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.product.image,
                          fit: BoxFit.cover,
                        ))),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 34),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(widget.product.capitalizeTitle,
                            style:Theme.of(context).textTheme.caption),
                        Text(widget.product.priceWithCurrency,
                            style: Theme.of(context).textTheme.subtitle1)
                      ])),
              Text(AppLocalizations.of(context).translate('description'),
                  style: Theme.of(context).textTheme.subtitle1),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(widget.product.description ?? '',
                  style: Theme.of(context).textTheme.subtitle2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
