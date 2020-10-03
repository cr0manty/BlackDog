import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';

class UserCard extends StatelessWidget {
  final String username;
  final Function onPressed;
  final Widget additionWidget;
  final Widget trailing;
  final double topPadding;

  UserCard(
      {@required this.username,
      @required this.onPressed,
      this.additionWidget,
      this.trailing,
      this.topPadding = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin:
            EdgeInsets.only(top: topPadding, left: 16, right: 16, bottom: 8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor.cardBackground),
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  width: ScreenSize.mainTextWidth,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    username,
                    style: Utils.instance.getTextStyle('subtitle1'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              trailing ?? Container()
            ],
          ),
          additionWidget != null
              ? SizedBox(height: ScreenSize.elementIndentHeight)
              : Container(),
          additionWidget ?? Container()
        ]),
      ),
    );
  }
}

class BonusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Utils.instance
            .showQRCodeModal(context, codeUrl: SharedPrefs.getQRCode()),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: HexColor.darkElement,
            ),
            height: ScreenSize.bonusCardSize,
            width: ScreenSize.width - 52,
            margin: EdgeInsets.only(bottom: 3),
            child: Image.asset(
              Utils.bannerImage,
              fit: BoxFit.fill,
            )));
  }
}
