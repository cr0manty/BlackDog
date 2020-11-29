import 'package:black_dog/bloc/sign_up/sign_up_bloc.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpFields extends StatelessWidget {
  final FocusNode _phoneFocus;
  final FocusNode _password1Focus;
  final FocusNode _password2Focus;
  final TextEditingController _phoneController;
  final TextEditingController _password1Controller;
  final TextEditingController _password2Controller;

  SignUpFields(
    this._password1Controller,
    this._phoneController,
    this._password2Controller,
      this._phoneFocus,
      this._password1Focus,
    this._password2Focus,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: TextInput(
                  focusNode: _phoneFocus,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_password1Focus),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: AppLocalizations.of(context).translate('phone'),
                )),
            Utils.instance
                .showValidateError(state.fieldsError, key: 'phone_number'),
            Container(
                alignment: Alignment.center,
                child: TextInput(
                  focusNode: _password1Focus,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_password2Focus),
                  obscureText: state.obscureText,
                  controller: _password1Controller,
                  hintText: AppLocalizations.of(context).translate('password'),
                  suffixIcon: GestureDetector(
                    child: Icon(
                        state.obscureText
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill,
                        color: HexColor.darkElement),
                    onTap: () {
                      BlocProvider.of<SignUpBloc>(context).add(
                        SignUpShowPasswordEvent(
                          password: !state.obscureText,
                        ),
                      );
                    },
                  ),
                  inputAction: TextInputAction.next,
                )),
            Utils.instance
                .showValidateError(state.fieldsError, key: 'password1'),
            Container(
                alignment: Alignment.center,
                child: TextInput(
                  obscureText: state.obscureText,
                  controller: _password2Controller,
                  focusNode: _password2Focus,
                  hintText: AppLocalizations.of(context)
                      .translate('confirm_password'),
                  suffixIcon: GestureDetector(
                    child: Icon(
                        state.obscureTextConfirm
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill,
                        color: HexColor.darkElement),
                    onTap: () {
                      BlocProvider.of<SignUpBloc>(context).add(
                        SignUpShowPasswordEvent(
                          confirmPassword: state.obscureTextConfirm,
                        ),
                      );
                    },
                  ),
                  onFieldSubmitted: (_) {
                    BlocProvider.of<SignUpBloc>(context).add(
                      SignUpSignUpEvent(
                          password: _password1Controller.text,
                          passwordConfirm: _password2Controller.text,
                          phone: _phoneController.text),
                    );
                  },
                  validator: (String text) {
                    if (text != _password1Controller.text) {
                      return AppLocalizations.of(context)
                          .translate('password_mismatch');
                    }
                    return null;
                  },
                  inputAction: TextInputAction.done,
                )),
            Utils.instance
                .showValidateError(state.fieldsError, key: 'password2')
          ],
        );
      },
    );
  }
}
