import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailFilter = TextEditingController();
  bool newPassword = false;
  String accountError = '';

  List<Widget> _buildEmailConfirm() {
    return <Widget>[
      Container(
          alignment: Alignment.center,
          child: TextInput(
            controller: _emailFilter,
            keyboardType: TextInputType.emailAddress,
            hintText: AppLocalizations.of(context).translate('email'),
            inputAction: TextInputAction.continueAction,
          )),
      Utils.showValidateError({'accountError': accountError},
          key: 'accountError'),
      Container(
        margin: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: CupertinoButton(
            onPressed: _sendClick,
            color: HexColor.lightElement,
            child: Text(
              AppLocalizations.of(context).translate('send'),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: HexColor.darkElement),
            )),
      ),
    ];
  }

  List<Widget> _buildNewPassword() {
    return <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('sign_in'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      title: Text(AppLocalizations.of(context).translate('restore_password'),
          style: Theme.of(context).textTheme.caption),
      children: newPassword ? _buildEmailConfirm() : _buildNewPassword(),
    );
  }

  void _sendClick() async {
    Map response = await Api.instance.passwordReset(_emailFilter.text);
    if (response['result']) {
      setState(() {
        newPassword = true;
      });
    } else {
      accountError = response['email'] ?? '';
    }
  }
}
