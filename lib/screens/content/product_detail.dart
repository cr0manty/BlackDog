import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/models/menu_item.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/image_view.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class ProductDetail extends StatefulWidget {
  final MenuItem product;

  ProductDetail({@required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  MenuItem product;
  AnimationController animationController;
  MenuItemVariation selectedVariation;
  Animation animation;
  int selectedVariationIndex = 0;

  Widget _buildVariation(int index) {
    MenuItemVariation variation = product.variations[index];
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
              opacity: animationController.drive(
                CurveTween(
                  curve: Curves.easeOut,
                ),
              ),
              child: _buildSizeElement(index),
            ),
    );
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
        child: Text(
          product.variations[index].name,
          style: Utils.instance.getTextStyle('headline1'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    product = widget.product;
    animationController =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    animationController.forward();
  }

  Future _getProduct() async {
    MenuItem getProduct = await Api.instance.getProduct(product.id);
    if (getProduct != null) {
      setState(() => product = getProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      alwaysNavigation: true,
      titleMargin: 20,
      onRefresh: () async => await Future.delayed(
        Duration(milliseconds: 500),
        () async => await _getProduct(),
      ),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('back'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      children: <Widget>[
        Center(
          child: Container(
            width: ScreenSize.width - 32,
            height: ScreenSize.detailViewImage,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ImageView(
                product.image,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  width: ScreenSize.mainTextWidth,
                  child: Text(product.capitalizeTitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Utils.instance.getTextStyle('caption'))),
              FadeTransition(
                  opacity: animationController
                      .drive(CurveTween(curve: Curves.easeOut)),
                  child: Text(
                      product.priceWithCurrency(context,
                          actualPrice: selectedVariation?.price),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Utils.instance.getTextStyle('subtitle1'))),
            ],
          ),
        ),
        product.variations.length != 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 50,
                    width: ScreenSize.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(product.variations.length,
                                (index) => _buildVariation(index))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              )
            : Container(),
        product.description != null && product.description.isNotEmpty
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Text(
                  AppLocalizations.of(context).translate('description'),
                  style: Utils.instance.getTextStyle('subtitle1'),
                ),
              )
            : Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            product.description ?? '',
            style: Utils.instance.getTextStyle('subtitle2'),
          ),
        ),
      ],
    );
  }
}
