import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../home_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DateTime selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  static const List<String> _fieldsList = [
    'email',
    'password1',
    'password2',
    'first_name',
    'phone',
    'date_birth'
  ];
  Map fieldsError = {};
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: ModalProgressHUD(
                progressIndicator: CupertinoActivityIndicator(),
                inAsyncCall: isLoading,
                child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: ScrollConfiguration(
                        behavior: ScrollGlow(),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(
                                    top: ScreenSize.sectionIndent,
                                    bottom: ScreenSize.sectionIndent * 2),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('register'),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          child: TextInput(
                                        controller: _nameController,
                                        hintText: AppLocalizations.of(context)
                                            .translate('first_name'),
                                        inputAction:
                                            TextInputAction.continueAction,
                                      ))),
                                  Utils.showValidateError(fieldsError,
                                      key: 'first_name'),
                                  Container(
                                      alignment: Alignment.center,
                                      child: TextInput(
                                        controller: _phoneController,
                                        hintText: AppLocalizations.of(context)
                                            .translate('phone'),
                                        inputAction:
                                            TextInputAction.continueAction,
                                      )),
                                  Utils.showValidateError(fieldsError,
                                      key: 'phone'),
                                  Container(
                                      alignment: Alignment.center,
                                      child: TextInput(
                                        controller: _emailController,
                                        hintText: AppLocalizations.of(context)
                                            .translate('email'),
                                        inputAction:
                                            TextInputAction.continueAction,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      )),
                                  Utils.showValidateError(fieldsError,
                                      key: 'email'),
                                  Container(
                                      alignment: Alignment.center,
                                      child: TextInput(
                                        obscureText: _obscureText,
                                        controller: _password1Controller,
                                        hintText: AppLocalizations.of(context)
                                            .translate('password'),
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                              _obscureText
                                                  ? Icons.remove_red_eye
                                                  : Icons.visibility_off,
                                              color: HexColor.darkElement),
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                        inputAction: TextInputAction.done,
                                      )),
                                  Utils.showValidateError(fieldsError,
                                      key: 'password1'),
                                  Container(
                                      alignment: Alignment.center,
                                      child: TextInput(
                                        obscureText: _obscureTextConfirm,
                                        controller: _password2Controller,
                                        hintText: AppLocalizations.of(context)
                                            .translate('confirm_password'),
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                              _obscureTextConfirm
                                                  ? Icons.remove_red_eye
                                                  : Icons.visibility_off,
                                              color: HexColor.darkElement),
                                          onTap: () {
                                            setState(() {
                                              _obscureTextConfirm =
                                                  !_obscureTextConfirm;
                                            });
                                          },
                                        ),
                                        validator: (String text) {
                                          if (text !=
                                              _password1Controller.text) {
                                            return AppLocalizations.of(context)
                                                .translate('password_mismatch');
                                          }
                                          return null;
                                        },
                                        inputAction: TextInputAction.done,
                                      )),
                                  Utils.showValidateError(fieldsError,
                                      key: 'password2'),
                                  GestureDetector(
                                      onTap: () =>
                                          _showModalBottomSheet(context),
                                      child: Container(
                                          height: 50,
                                          width: ScreenSize.width - 32,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              color: HexColor.lightElement),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                Utils.dateFormat(
                                                        selectedDate) ??
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'birth_date'),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                              Icon(
                                                SFSymbols.calendar,
                                                color: Colors.black,
                                              )
                                            ],
                                          ))),
                                  Utils.showValidateError(fieldsError,
                                      key: 'date_birth'),
                                ],
                              ),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenSize.sectionIndent),
                                  child: Column(
                                    children: <Widget>[
                                      CupertinoButton(
                                          onPressed: registerClick,
                                          color: HexColor.lightElement,
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('register'),
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .copyWith(
                                                    color:
                                                        HexColor.darkElement),
                                          )),
                                      CupertinoButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    'already_have_account'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          )),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )))));
  }

  void _showModalBottomSheet(context) {
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
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) =>
                        setState(() => selectedDate = newDate),
                    minimumYear: 1900,
                    maximumYear: 2100,
                    mode: CupertinoDatePickerMode.date,
                  )));
        });
  }

  Map<String, String> _sendData() {
    return {
      'first_name': _nameController.text,
      'password1': _password1Controller.text,
      'password2': _password2Controller.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'date_birth': Utils.dateFormat(selectedDate),
    };
  }

  Future registerClick() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => isLoading = !isLoading);
    fieldsError = {};

    await Api.instance.register(_sendData()).then((response) async {
      bool result = response.remove('result');
      if (result && await Account.instance.setUser()) {
        Navigator.of(context).push(BottomRoute(page: HomePage()));
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
      setState(() => isLoading = !isLoading);
      Utils.showErrorPopUp(context);
    });
  }
}
