import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/cupertino.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Container(
      alignment: Alignment.centerRight,
      child: CupertinoButton(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => ForgotPassword()));
          },
          child: Text(
            AppLocalizations.of(context).translate('forgot_password'),
            style: Utils.instance.getTextStyle('bodyText2'),
          )),
    );
  }
}
