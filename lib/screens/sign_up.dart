import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  final TextEditingController _dateOfBirthController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map fieldsError = {};
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  bool isLoading = false;

  Widget _showValidateError({String key, bool bottomPadding = true}) {
    if (fieldsError.containsKey(key)) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              bottom: bottomPadding ? ScreenSize.elementIndentHeight : 0),
          child: Text(fieldsError[key],
              style:
                  TextStyle(color: Colors.red.withOpacity(0.9), fontSize: 12)));
    } else if (fieldsError.containsKey('all')) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              bottom: bottomPadding ? ScreenSize.elementIndentHeight : 0),
          child: Text(fieldsError['all'],
              style:
                  TextStyle(color: Colors.red.withOpacity(0.9), fontSize: 12)));
    }
    return SizedBox(height: bottomPadding ? ScreenSize.elementIndentHeight : 0);
  }

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
                              'Регистрация',
                              style: TextStyle(fontSize: 30),
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
                                    hintText: 'Имя',
                                    inputAction: TextInputAction.continueAction,
                                  ))),
                              _showValidateError(key: 'first_name'),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: TextInput(
                                    controller: _phoneController,
                                    hintText: 'Номер',
                                    inputAction: TextInputAction.continueAction,
                                  ))),
                              _showValidateError(key: 'phone'),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: TextInput(
                                    controller: _emailController,
                                    hintText: 'Email',
                                    inputAction: TextInputAction.continueAction,
                                  ))),
                              _showValidateError(key: 'email'),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: TextInput(
                                    obscureText: _obscureText,
                                    controller: _password1Controller,
                                    hintText: 'Пароль',
                                    suffixIcon: GestureDetector(
                                      child: Icon(
                                          _obscureText
                                              ? Icons.remove_red_eye
                                              : Icons.visibility_off,
                                          color: HexColor('#6c6c6c')),
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    inputAction: TextInputAction.done,
                                  ))),
                              _showValidateError(key: 'password1'),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: TextInput(
                                    obscureText: _obscureTextConfirm,
                                    controller: _password2Controller,
                                    hintText: 'Подтвердите Пароль',
                                    suffixIcon: GestureDetector(
                                      child: Icon(
                                          _obscureTextConfirm
                                              ? Icons.remove_red_eye
                                              : Icons.visibility_off,
                                          color: HexColor('#6c6c6c')),
                                      onTap: () {
                                        setState(() {
                                          _obscureTextConfirm =
                                              !_obscureTextConfirm;
                                        });
                                      },
                                    ),
                                    validator: (String text) {
                                      if (text != _password1Controller.text) {
                                        return 'Пароли не совпадают!';
                                      }
                                      return null;
                                    },
                                    inputAction: TextInputAction.done,
                                  ))),
                              _showValidateError(key: 'password2'),
                              GestureDetector(
                                  onTap: () => _showModalBottomSheet(context),
                                  child: Container(
                                      height: 50,
                                      width: ScreenSize.width - 32,
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            Utils.dateFormat(selectedDate) ??
                                                'Дата Рождения',
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
                              _showValidateError(key: 'date_birth'),
                            ],
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenSize.sectionIndent * 2),
                              child: Column(
                                children: <Widget>[
                                  CupertinoButton(
                                      onPressed: registerClick,
                                      color: Colors.white,
                                      child: Text(
                                        'Зарегестрироваться',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.black),
                                      )),
                                  CupertinoButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: Text(
                                        'Уже есть аккаунт? Войдите.',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                      )),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ))));
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
                          TextStyle(fontSize: 18, color: Colors.white),
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
    setState(() => isLoading = !isLoading);
    fieldsError = {};

    Map response = await Api.instance.registartion(_sendData());

    bool result = response.remove('result');
    if (result) {
      Navigator.of(context).push(BottomRoute(page: HomePage()));
    } else {
      response.forEach((key, value) {
        if (key == 'email' ||
            key == 'password1' ||
            key == 'password2' ||
            key == 'first_name' ||
            key == 'phone' ||
            key == 'date_birth') {
          fieldsError[key] = value[0];
        } else {
          fieldsError['all'] = value[0];
        }
      });
    }

    setState(() => isLoading = !isLoading);
  }
}
