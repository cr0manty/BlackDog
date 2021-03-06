import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class SocialAuth extends StatelessWidget {
  final String textKey;

  SocialAuth({@required this.textKey});

  Widget _buildButtons() {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton(
            onPressed: _onGoogleClick,
            child: Icon(
              SFSymbols.logo_google,
              size: 30,
              color: HexColor.lightElement,
            ),
          ),
          SizedBox(width: 10),
          CupertinoButton(
            onPressed: _onFacebookClick,
            child: Icon(
              SFSymbols.logo_facebook,
              size: 30,
              color: HexColor.lightElement,
            ),
          ),
          SizedBox(width: 10),
          CupertinoButton(
            onPressed: _onAppleClick,
            child: Icon(
              SFSymbols.logo_apple,
              size: 30,
              color: HexColor.lightElement,
            ),
          ),
        ]);
  }

  void _onGoogleClick() {}

  void _onFacebookClick() {}

  void _onAppleClick() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate(textKey),
            style: Utils.instance.getTextStyle('bodyText2'),
            textAlign: TextAlign.center,
          ),
          _buildButtons()
        ],
      ),
    );
  }
}
