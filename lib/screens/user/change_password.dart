import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final FocusNode _password1Focus = FocusNode();
  final FocusNode _password2Focus = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map fieldsError = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      shrinkWrap: true,
      inAsyncCall: isLoading,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('editing'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      action: RouteButton(
        text: AppLocalizations.of(context).translate('save'),
        color: HexColor.lightElement,
        onTap: _changePassword,
      ),
      child: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: TextInput(
                    controller: _password1Controller,
                    focusNode: _password1Focus,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_password2Focus),
                    hintText:
                        AppLocalizations.of(context).translate('new_password'),
                    inputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                  )),
              Utils.instance
                  .showValidateError(fieldsError, key: 'new_password1'),
              Container(
                  alignment: Alignment.center,
                  child: TextInput(
                    controller: _password2Controller,
                    focusNode: _password2Focus,
                    onFieldSubmitted: (_) => _changePassword(),
                    hintText: AppLocalizations.of(context)
                        .translate('confirm_password'),
                    inputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                  )),
              Utils.instance
                  .showValidateError(fieldsError, key: 'new_password2'),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> _sendData() {
    return {
      'new_password1': _password1Controller.text,
      'new_password2': _password2Controller.text
    };
  }

  Future _changePassword() async {
    setState(() {
      isLoading = !isLoading;
      fieldsError = {};
    });

    await Api.instance.changePassword(_sendData()).then((response) {
      bool result = response.remove('result');
      if (result) {
        EasyLoading.instance
          ..backgroundColor = HexColor.successGreen.withOpacity(0.8);
        EasyLoading.showSuccess('');
        Navigator.of(context).pop();
      } else {
        response.forEach((key, value) {
          if (key == 'new_password1' || key == 'new_password2') {
            fieldsError[key] = value[0];
          } else {
            fieldsError['all'] = value[0];
          }
        });
      }
      setState(() => isLoading = !isLoading);
      return;
    }).catchError((error) {
      print(error);
      setState(() => isLoading = !isLoading);
      EasyLoading.instance..backgroundColor = HexColor.errorRed;
      EasyLoading.showError('');
    });
  }
}
