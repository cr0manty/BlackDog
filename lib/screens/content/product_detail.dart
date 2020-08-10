import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      titleMargin: false,
      shrinkWrap: true,
      alwaysNavigation: true,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('back'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                  child: widget.product.image != null
                      ? FadeInImage.assetNetwork(
                                    placeholder: Utils.loadImage,
                                    image:widget.product.image, fit: BoxFit.cover)
                      : Image.asset(Utils.defaultImage, fit: BoxFit.cover))),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(widget.product.capitalizeTitle,
                      style: Theme.of(context).textTheme.caption),
                  Text(widget.product.priceWithCurrency,
                      style: Theme.of(context).textTheme.subtitle1)
                ])),
        Divider(color: HexColor.semiElement),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Text(AppLocalizations.of(context).translate('description'),
              style: Theme.of(context).textTheme.subtitle1),
        ),
        Text(widget.product.description ?? '',
            style: Theme.of(context).textTheme.subtitle2)
      ],
    );
  }
}
