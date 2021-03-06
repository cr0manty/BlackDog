import 'package:black_dog/network/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/page_scaffold.dart';
import 'package:black_dog/widgets/route_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

enum PageState { ENTER_PHONE, NEW_PASSWORD }

class ForgotPassword extends StatefulWidget {
  final PageState pageState;
  final String token;

  ForgotPassword({this.token, this.pageState = PageState.ENTER_PHONE});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _basicController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _basicAdditionController =
      TextEditingController();
  final FocusNode _password1Focus = FocusNode();
  final FocusNode _password2Focus = FocusNode();
  Map _validationError = {};
  bool isLoading = false;
  static const List<String> _fieldsList = [
    'new_password1',
    'new_password2',
  ];

  List<Widget> _buildPhoneRequest() {
    return <Widget>[
      Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: TextInput(
            controller: _basicController,
            onFieldSubmitted: (_) => _sendPhoneClick(),
            keyboardType: TextInputType.phone,
            hintText: AppLocalizations.of(context).translate('phone'),
            inputAction: TextInputAction.done,
          )),
      Utils.instance.showValidateError(_validationError, key: 'phone'),
      _confirmButton(onPressed: _sendPhoneClick)
    ];
  }

  List<Widget> _switchPages() {
    switch (widget.pageState) {
      case PageState.ENTER_PHONE:
        return _buildPhoneRequest();
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
            style: Utils.instance
                .getTextStyle('caption')
                .copyWith(color: HexColor.darkElement),
          )),
    );
  }

  List<Widget> _buildNewPassword() {
    return <Widget>[
      Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: TextInput(
            controller: _basicController,
            focusNode: _password1Focus,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_password2Focus),
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
            onFieldSubmitted: (_) => _sendNewPassword(),
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
      titleMargin: 0,
      padding: EdgeInsets.symmetric(horizontal: 16),
      leading: RouteButton(
        defaultIcon: true,
        text: AppLocalizations.of(context).translate('sign_in'),
        color: HexColor.lightElement,
        onTap: () => Navigator.of(context).pop(),
      ),
      title: Text(AppLocalizations.of(context).translate('restore_password'),
          style: Utils.instance.getTextStyle('caption')),
      children: _switchPages(),
    );
  }

  void onSuccessCode(String uid) async {
    await Api.instance.loginByFirebaseUserUid(uid).then((result) {
      if (result) {
        SharedPrefs.saveUserFirebaseUid(uid);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => ForgotPassword(
                  pageState: PageState.NEW_PASSWORD,
                )));
      } else {
        Navigator.of(context).pop();
        setState(() {
          isLoading = !isLoading;
          _validationError['phone'] =
              AppLocalizations.of(context).translate('phone_not_found');
        });
      }
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = !isLoading;
        _validationError['phone'] =
            AppLocalizations.of(context).translate('phone_not_found');
      });
    });
  }

  void _firebaseVerifyPhone() async {
    _codeController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _validationError = {};
    });

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _basicController.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) {},
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
          Navigator.of(context).pop();
          Utils.instance.infoDialog(
            context,
            authException.message,
          );
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() => isLoading = false);
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
                        )),
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
                            Utils.instance
                                .infoDialog(context, error.toString());
                          });
                          if (result != null && result.user != null) {
                            onSuccessCode(result.user.uid);
                          }
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text(
                            AppLocalizations.of(context).translate('cancel'),
                            style: Utils.instance
                                .getTextStyle('subtitle2')
                                .copyWith(color: HexColor.errorRed)),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Navigator.of(context).pop();
          verificationId = verificationId;
          print('Time out: $verificationId');
          Utils.instance.infoDialog(
            context,
            AppLocalizations.of(context).translate('error'),
          );
        });
  }

  void _sendPhoneClick() async {
    FocusScope.of(context).unfocus();
    _codeController.clear();
    setState(() {
      isLoading = !isLoading;
      _validationError = {};
    });

    bool exist =
        await Api.instance.checkPhoneNumberExist(_basicController.text); //
    if (exist) {
      _firebaseVerifyPhone();
    } else {
      setState(() {
        isLoading = !isLoading;
        _validationError['phone'] =
            AppLocalizations.of(context).translate('phone_not_found');
      });
    }
  }

  Future showSuccessPopUp() {
    setState(() => isLoading = false);

    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                  AppLocalizations.of(context)
                      .translate('success_password_change'),
                  style: Utils.instance.getTextStyle('headline1')),
              content: Text(
                  AppLocalizations.of(context)
                      .translate('success_password_change_help'),
                  style: Utils.instance.getTextStyle('bodyText2')),
              actions: [
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context).translate('done'),
                      style: Utils.instance
                          .getTextStyle('subtitle2')
                          .copyWith(color: CupertinoColors.activeBlue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            )).then((value) => Navigator.of(context).pop());
  }

  void _sendNewPassword() async {
    FocusScope.of(context).unfocus();
    _codeController.clear();
    setState(() {
      isLoading = !isLoading;
      _validationError = {};
    });

    _validationError = {};
    await Api.instance.changePassword({
      'new_password1': _basicController.text,
      'new_password2': _basicAdditionController.text
    }).then((response) async {
      bool result = response.remove('result');
      if (!result) {
        response.forEach((key, value) {
          if (_fieldsList.contains(key)) {
            _validationError[key] = value[0];
          } else {
            Utils.instance.infoDialog(context, value[0]);
            return;
          }
        });
      } else {
        showSuccessPopUp();
      }
      setState(() => isLoading = !isLoading);
      return;
    }).catchError((error) {
      setState(() => isLoading = !isLoading);
      print(error);
      Utils.instance.infoDialog(
        context,
        AppLocalizations.of(context).translate('error'),
      );
    });
  }
}
