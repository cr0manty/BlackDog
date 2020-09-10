import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductDetail extends StatefulWidget {
  final MenuItem product;

  ProductDetail({@required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  AnimationController animationController;
  MenuItemVariation selectedVariation;
  Animation animation;
  int selectedVariationIndex = 0;

  Widget _buildVariation(int index) {
    MenuItemVariation variation = widget.product.variations[index];
    return GestureDetector(
        onTap: () async {
          if (selectedVariation != variation) {
            animationController.reverse().then((value) {
              setState(() {
                selectedVariation = variation;
                selectedVariationIndex = index;
              });
              animationController.forward();
            });
          }
        },
        child: selectedVariationIndex != index
            ? _buildSizeElement(index)
            : FadeTransition(
                opacity: animationController
                    .drive(CurveTween(curve: Curves.easeOut)),
                child: _buildSizeElement(index)));
  }

  Widget _buildSizeElement(int index) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: selectedVariationIndex != index
                ? HexColor.cardBackground.withOpacity(0.6)
                : HexColor.semiElement.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(widget.product.variations[index].name,
                style: Theme.of(context).textTheme.headline1)));
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      alwaysNavigation: true,
      titleMargin: false,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('back'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
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
                          image: widget.product.image,
                          fit: BoxFit.cover)
                      : Image.asset(Utils.defaultImage, fit: BoxFit.cover))),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                      width: ScreenSize.maxTextWidth,
                      child: Text(widget.product.capitalizeTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.caption)),
                  FadeTransition(
                      opacity: animationController
                          .drive(CurveTween(curve: Curves.easeOut)),
                      child: Container(
                          width: ScreenSize.maxTextWidth,
                          child: Text(
                              widget.product.priceWithCurrency(context,
                                  actualPrice: selectedVariation?.price),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.subtitle1))),
                ])),
        widget.product.variations.length != 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      height: 50,
                      width: ScreenSize.width,
                      child: ScrollConfiguration(
                          behavior: ScrollGlow(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(
                                      widget.product.variations.length,
                                      (index) => _buildVariation(index))),
                            ),
                          )))
                ],
              )
            : Container(),
        widget.product.description != null
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                child: Text(
                    AppLocalizations.of(context).translate('description'),
                    style: Theme.of(context).textTheme.subtitle1))
            : Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Text(widget.product.description ?? '',
              style: Theme.of(context).textTheme.subtitle2),
        ),
        SizedBox(height: 10)
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
