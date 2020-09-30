import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/user/sign_in.dart';
import 'package:black_dog/screens/user/sign_up_confirm.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../home_page.dart';
import '../staff_home.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DateTime selectedDate;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _password1Focus = FocusNode();
  final FocusNode _password2Focus = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  static const List<String> _fieldsList = [
    'password1',
    'password2',
    'phone_number',
  ];
  Map fieldsError = {};
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  bool isLoading = false;

  Widget _buildFields() {
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
        Utils.instance.showValidateError(fieldsError, key: 'phone_number'),
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _password1Focus,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_password2Focus),
              obscureText: _obscureText,
              controller: _password1Controller,
              hintText: AppLocalizations.of(context).translate('password'),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureText ? Icons.remove_red_eye : Icons.visibility_off,
                    color: HexColor.darkElement),
                onTap: () => setState(() => _obscureText = !_obscureText),
              ),
              inputAction: TextInputAction.next,
            )),
        Utils.instance.showValidateError(fieldsError, key: 'password1'),
        Container(
            alignment: Alignment.center,
            child: TextInput(
              obscureText: _obscureTextConfirm,
              controller: _password2Controller,
              focusNode: _password2Focus,
              hintText:
                  AppLocalizations.of(context).translate('confirm_password'),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureTextConfirm
                        ? Icons.remove_red_eye
                        : Icons.visibility_off,
                    color: HexColor.darkElement),
                onTap: () =>
                    setState(() => _obscureTextConfirm = !_obscureTextConfirm),
              ),
              onFieldSubmitted: (_) => onFieldSubmitted(registerWithPhone),
              validator: (String text) {
                if (text != _password1Controller.text) {
                  return AppLocalizations.of(context)
                      .translate('password_mismatch');
                }
                return null;
              },
              inputAction: TextInputAction.done,
            )),
        Utils.instance.showValidateError(fieldsError, key: 'password2')
      ],
    );
  }

  void onFieldSubmitted(Function function) {
    if (_phoneController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_phoneFocus);
    } else if (_password1Controller.text.isEmpty) {
      FocusScope.of(context).requestFocus(_password1Focus);
    } else if (_password2Controller.text.isEmpty) {
      FocusScope.of(context).unfocus();
    } else {
      function();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
            top: 0.0,
            child: Container(
              height: ScreenSize.height,
              width: ScreenSize.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(Utils.backgroundImage),
                fit: BoxFit.fill,
              )),
            )),
        ModalProgressHUD(
            progressIndicator: CupertinoActivityIndicator(),
            inAsyncCall: isLoading,
            child: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: Container(
                  height: ScreenSize.height,
                  width: ScreenSize.width,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                      key: _formKey,
                      child: ScrollConfiguration(
                        behavior: ScrollGlow(),
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(
                                    top: ScreenSize.mainMarginTop,
                                    bottom: ScreenSize.sectionIndent * 2),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('register'),
                                  style: Utils.instance.getTextStyle('caption'),
                                ),
                              ),
                              _buildFields(),
                              // widget.signUpPageType == SignUpPageType.MAIN_DATA
                              //     ? SocialAuth(textKey: 'sign_up_with')
                              //     : Container(), // todo: after release
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                          width: ScreenSize.width - 64,
                                          child: CupertinoButton(
                                              onPressed: _mainRegistration,
                                              color: HexColor.lightElement,
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('register'),
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: Utils.instance
                                                    .getTextStyle('headline1')
                                                    .copyWith(
                                                        color: HexColor
                                                            .darkElement),
                                              ))),
                                      CupertinoButton(
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pushAndRemoveUntil(
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        SignInPage()),
                                                (route) => false),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'already_have_account'),
                                          textAlign: TextAlign.center,
                                          style: Utils.instance
                                              .getTextStyle('bodyText2'),
                                        ),
                                      ),
                                    ],
                                  ))
                            ])),
                      ))),
            )),
      ]),
    );
  }

  Map<String, String> _sendData() {
    return {
      'password1': _password1Controller.text,
      'password2': _password2Controller.text,
      'phone_number': _phoneController.text,
    };
  }

  Future registerWithPhone(String token) async {
    _codeController.clear();
    setState(() => fieldsError = {});

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) {},
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
          EasyLoading.instance..backgroundColor = Colors.red.withOpacity(0.8);
          EasyLoading.showError('');
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() => isLoading = !isLoading);
          showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text(
                        AppLocalizations.of(context).translate('enter_code'),
                        style: Utils.instance.getTextStyle('headline1')),
                    content: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CupertinoTextField(
                        style: Utils.instance.getTextStyle('subtitle2'),
                        controller: _codeController,
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(
                            AppLocalizations.of(context).translate('done'),
                            style: Utils.instance
                                .getTextStyle('subtitle2')
                                .copyWith(color: CupertinoColors.activeBlue)),
                        onPressed: () async {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: _codeController.text.trim());
                          final result = await FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .catchError((error) {
                            Navigator.of(context).pop();
                            EasyLoading.instance
                              ..backgroundColor = Colors.red.withOpacity(0.8);
                            EasyLoading.showError('');
                          });
                          if (result != null && result.user != null) {
                            SharedPrefs.saveUserFirebaseUid(result.user.uid);
                            Navigator.of(context)
                                .pushReplacement(CupertinoPageRoute(
                                    builder: (context) => SignUpConfirmPage(
                                          token: token,
                                        )));
                          }
                          return null;
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text(
                            AppLocalizations.of(context).translate('cancel'),
                            style: Utils.instance
                                .getTextStyle('subtitle2')
                                .copyWith(color: HexColor.errorLog)),
                        onPressed: () {
                          setState(() => isLoading = false);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print('Time out: $verificationId');
        });
  }

  Future _mainRegistration({Function onEnd}) async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
      fieldsError = {};
    });

    await Api.instance.register(_sendData()).then((response) async {
      bool result = response.remove('result');
      if (result) {
        registerWithPhone(response['key']);
      } else {
        response.forEach((key, value) {
          if (_fieldsList.contains(key)) {
            fieldsError[key] = value[0];
          } else {
            fieldsError['all'] = value[0];
          }
        });
      }
      setState(() => isLoading = false);
      return;
    }).catchError((error) {
      print(error);
      setState(() => isLoading = false);
      EasyLoading.instance..backgroundColor = Colors.red.withOpacity(0.8);
      EasyLoading.showError('');
    });
  }
}
