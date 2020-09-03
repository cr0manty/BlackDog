import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PageState { ENTER_PHONE, ENTER_CODE, NEW_PASSWORD }

class ForgotPassword extends StatefulWidget {
  final PageState pageState;
  final Map tokens;

  ForgotPassword({this.pageState = PageState.ENTER_PHONE, this.tokens});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _basicController = TextEditingController();
  final TextEditingController _basicAdditionController =
      TextEditingController();
  final FocusNode _password1Focus = FocusNode();
  final FocusNode _password2Focus = FocusNode();
  Map _validationError = {};
  bool isLoading = false;
  static const List<String> _fieldsList = [
    'phone_number',
    'code',
    'new_password1',
    'new_password2',
  ];

  List<Widget> _buildBasicField(
      {String key, VoidCallback onPressed, String hint, bool isPhone = false}) {
    return <Widget>[
      _helpText(),
      Container(
          alignment: Alignment.center,
          child: TextInput(
            controller: _basicController,
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            hintText: AppLocalizations.of(context).translate(hint ?? key),
            inputAction: TextInputAction.done,
          )),
      Utils.instance.showValidateError(_validationError, key: key),
      _confirmButton(onPressed: onPressed)
    ];
  }

  Widget _helpText() {
    return widget.pageState == PageState.ENTER_CODE
        ? Container(
            padding: EdgeInsets.only(top: 10, bottom: 30),
            child: Text(AppLocalizations.of(context).translate('reset_help'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2))
        : Container();
  }

  List<Widget> _switchPages() {
    switch (widget.pageState) {
      case PageState.ENTER_PHONE:
        return _buildBasicField(
            isPhone: true,
            key: 'phone',
            hint: 'phone',
            onPressed: _sendPhoneClick);
      case PageState.ENTER_CODE:
        return _buildBasicField(key: 'code', onPressed: _sendCodeConfirm);
      case PageState.NEW_PASSWORD:
        return _buildNewPassword();
    }
    return [];
  }

  Widget _confirmButton(
      {@required VoidCallback onPressed, String textKey = 'send'}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: CupertinoButton(
          onPressed: onPressed,
          color: HexColor.lightElement,
          child: Text(
            AppLocalizations.of(context).translate(textKey),
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: HexColor.darkElement),
          )),
    );
  }

  List<Widget> _buildNewPassword() {
    return <Widget>[
      Container(
          alignment: Alignment.center,
          child: TextInput(
            controller: _basicController,
            focusNode: _password1Focus,
            targetFocus: _password2Focus,
            keyboardType: TextInputType.visiblePassword,
            hintText: AppLocalizations.of(context).translate('new_password'),
            inputAction: TextInputAction.next,
          )),
      Utils.instance.showValidateError(_validationError, key: 'new_password1'),
      Container(
          alignment: Alignment.center,
          child: TextInput(
            focusNode: _password2Focus,
            controller: _basicAdditionController,
            keyboardType: TextInputType.visiblePassword,
            hintText:
                AppLocalizations.of(context).translate('confirm_password'),
            inputAction: TextInputAction.done,
          )),
      Utils.instance.showValidateError(_validationError, key: 'new_password2'),
      _confirmButton(onPressed: _sendNewPassword, textKey: 'save')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      inAsyncCall: isLoading,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('sign_in'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
      ),
      title: Text(AppLocalizations.of(context).translate('restore_password'),
          style: Theme.of(context).textTheme.caption),
      children: _switchPages(),
    );
  }

  void _sendPhoneClick() async {
    setState(() => isLoading = !isLoading);
    await Api.instance.passwordReset(_basicController.text).then((response) {
      _validationError = {};
      bool result = response.remove('result');
      if (result) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => ForgotPassword(
                  pageState: PageState.ENTER_CODE,
                )));
      } else {
        response.forEach((key, value) =>
            _validationError[_fieldsList.contains(key) ? key : 'all'] =
                value[0]);
        setState(() => isLoading = !isLoading);
      }
    }).catchError((error) {
      print(error);
      setState(() => isLoading = !isLoading);
      Utils.instance.showErrorPopUp(context, text: error.toString());
    });
  }

  void _sendCodeConfirm() async {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (context) => ForgotPassword(
              pageState: PageState.NEW_PASSWORD,
              tokens: {},
            )));
  }

  void _sendNewPassword() async {}
}
