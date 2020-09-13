import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:black_dog/widgets/soacial_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../home_page.dart';
import '../staff_home.dart';

enum SignUpPageType { MAIN_DATA, ADDITION_DATA }

class SignUpPage extends StatefulWidget {
  final SignUpPageType signUpPageType;

  SignUpPage({this.signUpPageType = SignUpPageType.MAIN_DATA});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DateTime selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _password1Focus = FocusNode();
  final FocusNode _password2Focus = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  static const List<String> _fieldsList = [
    'password1',
    'password2',
    'first_name',
    'last_name',
    'phone_number',
    'birth_date'
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
              inputAction: TextInputAction.done,
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

  Widget _buildAddition() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _nameFocus,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_lastNameFocus),
              controller: _nameController,
              keyboardType: TextInputType.name,
              hintText: AppLocalizations.of(context).translate('first_name'),
            )),
        Utils.instance.showValidateError(fieldsError, key: 'first_name'),
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _lastNameFocus,
              onFieldSubmitted: (_) => _showModalBottomSheet(context),
              controller: _lastNameController,
              keyboardType: TextInputType.name,
              hintText: AppLocalizations.of(context).translate('last_name'),
            )),
        Utils.instance.showValidateError(fieldsError, key: 'last_name'),
        GestureDetector(
            onTap: () => _showModalBottomSheet(context),
            child: Container(
                height: 50,
                width: ScreenSize.width - 32,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor.lightElement),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Utils.instance.showDateFormat(selectedDate) ??
                          AppLocalizations.of(context).translate('birth_date'),
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Icon(
                      SFSymbols.calendar,
                      color: Colors.black,
                    )
                  ],
                ))),
        Utils.instance.showValidateError(fieldsError, key: 'birth_date'),
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
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                              widget.signUpPageType ==
                                      SignUpPageType.ADDITION_DATA
                                  ? _buildAddition()
                                  : _buildFields(),
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
                                              onPressed:
                                                  widget.signUpPageType ==
                                                          SignUpPageType
                                                              .ADDITION_DATA
                                                      ? _additionRegister
                                                      : _mainRegistration,
                                              color: HexColor.lightElement,
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        widget.signUpPageType ==
                                                                SignUpPageType
                                                                    .MAIN_DATA
                                                            ? 'continue'
                                                            : 'register'),
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1
                                                    .copyWith(
                                                        color: HexColor
                                                            .darkElement),
                                              ))),
                                      CupertinoButton(
                                        onPressed: Navigator.of(context).pop,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'already_have_account'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
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

  void _showModalBottomSheet(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime today = DateTime.now();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle:
                          Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: today,
                    onDateTimeChanged: (DateTime newDate) =>
                        setState(() => selectedDate = newDate),
                    minimumYear: today.year - 200,
                    maximumYear: today.year + 2,
                    mode: CupertinoDatePickerMode.date,
                  )));
        });
  }

  Map<String, String> _sendData() {
    return widget.signUpPageType == SignUpPageType.MAIN_DATA
        ? {
            'password1': _password1Controller.text,
            'password2': _password2Controller.text,
            'phone_number': _phoneController.text,
          }
        : {
            'birth_date': Utils.instance.dateFormat(selectedDate),
            'first_name': _nameController.text,
            'last_name': _lastNameController.text,
            'firebase_uid': SharedPrefs.getUserFirebaseUID()
          };
  }

  Future registerWithPhone() async {
    _codeController.clear();

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
          showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text(
                        AppLocalizations.of(context).translate('enter_code'),
                        style: Theme.of(context).textTheme.headline1),
                    content: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CupertinoTextField(
                        style: Theme.of(context).textTheme.subtitle2,
                        controller: _codeController,
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(
                            AppLocalizations.of(context).translate('done')),
                        onPressed: () async {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: _codeController.text.trim());
                          UserCredential result = await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          if (result != null && result.user != null) {
                            Api.instance
                                .updateUser({'firebase_uid': result.user.uid});
                            SharedPrefs.saveUserFirebaseUid(result.user.uid);
                            Navigator.of(context)
                                .pushReplacement(CupertinoPageRoute(
                                    builder: (context) => SignUpPage(
                                          signUpPageType:
                                              SignUpPageType.ADDITION_DATA,
                                        )));
                          }
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text(
                            AppLocalizations.of(context).translate('cancel')),
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

  Future _additionRegister() async {
    setState(() => isLoading = !isLoading);
    Map response = await Api.instance.updateUser(_sendData());
    bool result = response.remove('result');
    if (result && await Account.instance.setUser()) {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
              builder: (context) => Account.instance.user.isStaff
                  ? StaffHomePage()
                  : HomePage()),
          (route) => false);
    } else {
      response.forEach((key, value) {
        if (_fieldsList.contains(key)) {
          fieldsError[key] = value[0];
        } else {
          fieldsError['all'] = value[0];
        }
      });
    }
    setState(() => isLoading = !isLoading);
  }

  Future _mainRegistration({Function onEnd}) async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = !isLoading);
    fieldsError = {};

    await Api.instance.register(_sendData()).then((response) async {
      bool result = response.remove('result');
      if (result) {
        registerWithPhone();
      } else {
        response.forEach((key, value) {
          if (_fieldsList.contains(key)) {
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
      EasyLoading.instance..backgroundColor = Colors.red.withOpacity(0.8);
      EasyLoading.showError('');
    });
  }
}
