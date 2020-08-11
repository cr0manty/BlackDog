import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map fieldsError = {};
  bool isLoading = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      alwaysNavigation: true,
      inAsyncCall: isLoading,
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('editing'),
        color: HexColor.lightElement,
        onTap: Navigator.of(context).pop,
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
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: TextInput(
                    obscureText: _obscureText1,
                    controller: _password1Controller,
                    hintText:
                        AppLocalizations.of(context).translate('new_password'),
                    suffixIcon: GestureDetector(
                      child: Icon(
                          _obscureText1
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          color: HexColor.darkElement),
                      onTap: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                    ),
                    inputAction: TextInputAction.done,
                  )),
              Utils.showValidateError(fieldsError, key: 'new_password1'),
              Container(
                  alignment: Alignment.center,
                  child: TextInput(
                    obscureText: _obscureText2,
                    controller: _password2Controller,
                    hintText: AppLocalizations.of(context)
                        .translate('confirm_password'),
                    suffixIcon: GestureDetector(
                      child: Icon(
                          _obscureText2
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          color: HexColor.darkElement),
                      onTap: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                    inputAction: TextInputAction.done,
                  )),
              Utils.showValidateError(fieldsError, key: 'new_password2'),
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
    setState(() => isLoading = !isLoading);
    fieldsError = {};

    await Api.instance.changePassword(_sendData()).then((response) {
      bool result = response.remove('result');
      if (result) {
        Utils.showSuccessPopUp(context, text: response['detail']);
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
      setState(() => isLoading = !isLoading);
      Utils.showErrorPopUp(context);
    });
  }
}
