import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'change_password.dart';

class ProfileSettings extends StatefulWidget {
  final bool fromHome;

  ProfileSettings({this.fromHome});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map fieldsError = {};
  bool isLoading = false;

  @override
  void initState() {
    _nameController.text = Account.instance.user.firstName;
    _phoneController.text = Account.instance.user.phone;
    _emailController.text = Account.instance.user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      inAsyncCall: isLoading,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context)
            .translate(widget.fromHome ? 'home' : 'profile'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      action: RouteButton(
        text: AppLocalizations.of(context).translate('save'),
        color: HexColor.lightElement,
        onTap: _saveNewUser,
      ),
      child: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: TextInput(
                controller: _nameController,
                hintText: AppLocalizations.of(context).translate('first_name'),
                inputAction: TextInputAction.continueAction,
                keyboardType: TextInputType.name,
              )),
              Utils.showValidateError(fieldsError, key: 'first_name'),
              Container(
                  child: TextInput(
                controller: _phoneController,
                hintText: AppLocalizations.of(context).translate('phone'),
                inputAction: TextInputAction.continueAction,
                keyboardType: TextInputType.phone,
              )),
              Utils.showValidateError(fieldsError, key: 'phone'),
              Container(
                  child: TextInput(
                controller: _emailController,
                hintText: AppLocalizations.of(context).translate('email'),
                inputAction: TextInputAction.continueAction,
                keyboardType: TextInputType.emailAddress,
              )),
              Utils.showValidateError(fieldsError, key: 'email'),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: ScreenSize.width - 64,
                  child: CupertinoButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                  builder: (context) => ChangePassword())),
                      color: HexColor.lightElement,
                      child: Text(
                          AppLocalizations.of(context)
                              .translate('change_password'),
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(color: HexColor.darkElement))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> _sendData() {
    return {
      'first_name': _nameController.text,
      'email': _emailController.text,
      'phone_number': _phoneController.text,
    };
  }

  Future _saveNewUser() async {
    setState(() => isLoading = !isLoading);
    fieldsError = {};

    await Api.instance.updateUser(_sendData()).then((response) {
      bool result = response.remove('result');
      if (result) {
        Navigator.of(context).pop();
      } else {
        response.forEach((key, value) {
          if (key == 'email' || key == 'first_name' || key == 'phone') {
            fieldsError[key] = value[0];
          } else {
            fieldsError['all'] = value[0];
          }
        });
      }
      setState(() => isLoading = !isLoading);
      return;
    }).catchError((error) {
      setState(() => isLoading = !isLoading);
      Utils.showErrorPopUp(context);
    });
  }
}
