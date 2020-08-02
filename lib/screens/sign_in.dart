import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/screens/sign_up.dart';
import 'package:black_dog/utils/size.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map fieldsError = {};
  bool _obscureText = true;
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
    Utils.initScreenSize(MediaQuery.of(context).size);

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: ModalProgressHUD(
                progressIndicator: CupertinoActivityIndicator(),
                inAsyncCall: isLoading,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.only(
                                top: ScreenSize.elementIndentHeight),
                            child: Text(
                              'Вход',
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
                                    controller: _emailFilter,
                                    keyboardType: TextInputType.emailAddress,
                                    hintText: 'Email',
                                    inputAction: TextInputAction.continueAction,
                                  ))),
                              _showValidateError(key: 'email'),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: TextInput(
                                    obscureText: _obscureText,
                                    controller: _passwordFilter,
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
                              _showValidateError(
                                  key: 'password', bottomPadding: false),
                              Container(
                                alignment: Alignment.centerRight,
                                child: CupertinoButton(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 8),
                                    onPressed: () {},
                                    child: Text(
                                      'Забыли пароль?',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.6)),
                                    )),
                              ),
                            ],
                          ),
                          Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(
                                  bottom: ScreenSize.elementIndentHeight),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: ScreenSize.width - 64,
                                    child: CupertinoButton(
                                        onPressed: loginClick,
                                        color: Colors.white,
                                        child: Text(
                                          'Вход',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black),
                                        )),
                                  ),
                                  CupertinoButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            BottomRoute(page: SignUpPage()));
                                      },
                                      child: Text(
                                        'Нет аккаунта? Зарегистрируйтесь.',
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

  Future loginClick() async {
    setState(() => isLoading = !isLoading);
    fieldsError = {};
    Map response =
        await Api.instance.login(_emailFilter.text, _passwordFilter.text);

    bool result = response.remove('result');
    if (result && await Account.instance.setUser()) {
      Navigator.of(context).push(BottomRoute(page: HomePage()));
    } else {
      response.forEach((key, value) {
        if (key == 'email' || key == 'password') {
          fieldsError[key] = value[0];
        } else {
          fieldsError['all'] = value[0];
        }
      });
    }
    setState(() => isLoading = !isLoading);
  }
}
