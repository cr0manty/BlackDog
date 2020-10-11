import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'change_password.dart';

class ProfileSettings extends StatefulWidget {
  final bool fromHome;

  ProfileSettings({this.fromHome});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map fieldsError = {};
  bool isLoading = false;

  @override
  void initState() {
    _nameController.text = Account.instance.user.firstName;
    _lastNameController.text = Account.instance.user.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      alwaysNavigation: true,
      inAsyncCall: isLoading,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context)
            .translate(widget.fromHome ? 'home' : 'profile'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      action: RouteButton(
        text: AppLocalizations.of(context).translate('save'),
        color: HexColor.lightElement,
        onTap: _saveChanges,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 10, bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                    AppLocalizations.of(context).translate('first_name'),
                    style: Utils.instance.getTextStyle('bodyText1'))),
            TextInput(
                controller: _nameController,
                focusNode: _nameFocus,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_lastNameFocus),
                hintText: AppLocalizations.of(context).translate('first_name'),
                keyboardType: TextInputType.name,
                inputAction: TextInputAction.next),
            Utils.instance.showValidateError(fieldsError, key: 'first_name'),
            Container(
                padding: EdgeInsets.only(left: 10, bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context).translate('last_name'),
                    style: Utils.instance.getTextStyle('bodyText1'))),
            TextInput(
                controller: _lastNameController,
                onFieldSubmitted: (_) => _saveChanges(),
                focusNode: _lastNameFocus,
                hintText: AppLocalizations.of(context).translate('last_name'),
                keyboardType: TextInputType.text,
                inputAction: TextInputAction.done),
            Utils.instance.showValidateError(fieldsError, key: 'last_name'),
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
                          style: Utils.instance
                              .getTextStyle('headline2')
                              .copyWith(color: HexColor.darkElement))),
                )),
          ],
        ),
      ),
    );
  }

  Map<String, String> _sendData() {
    return {
      'first_name': _nameController.text,
      'last_name': _lastNameController.text,
    };
  }

  bool _validator() {
    bool isValid = true;
    if (_nameController.text == null || _nameController.text.isEmpty) {
      isValid = false;
      fieldsError['first_name'] =
          AppLocalizations.of(context).translate('fields_required');
    }
    if (_lastNameController.text == null || _lastNameController.text.isEmpty) {
      isValid = false;
      fieldsError['last_name'] =
          AppLocalizations.of(context).translate('fields_required');
    }
    return isValid;
  }

  Future _saveChanges() async {
    FocusScope.of(context).unfocus();
    fieldsError = {};

    if (!_validator()) {
      setState(() {});
      return;
    }
    setState(() => isLoading = !isLoading);

    await Api.instance.updateUser(_sendData()).then((response) {
      bool result = response.remove('result');
      if (result) {
        EasyLoading.instance
          ..backgroundColor = HexColor.successGreen.withOpacity(0.8);
        EasyLoading.showSuccess('');
      } else {
        response.forEach((key, value) {
          if (key == 'last_name' || key == 'first_name') {
            fieldsError[key] = value[0];
          } else {
            Utils.instance.infoDialog(context, value[0]);
            return;
          }
        });
      }
      setState(() => isLoading = !isLoading);
      return;
    }).catchError((error) {
      debugPrefixPrint(error, prefix: 'error');
      setState(() => isLoading = !isLoading);
      EasyLoading.instance..backgroundColor = HexColor.errorRed;
      EasyLoading.showError('');
    });
  }
}
