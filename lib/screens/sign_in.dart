import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/size.dart';
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
  bool _obscureText = true;
  bool isLoading = false;

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
            child: Container(
              padding: EdgeInsets.all(16),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    padding:
                        EdgeInsets.only(top: ScreenSize.elementIndentHeight),
                    child: Text(
                      'Вход',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                child: TextInput(
                              controller: _emailFilter,
                              hintText: 'Email',
                            ))),
                        SizedBox(height: ScreenSize.elementIndentHeight),
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
                                  }),
                            ))),
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(
                          bottom: ScreenSize.elementIndentHeight * 2),
                      child: CupertinoButton(
                          onPressed: () async {
                            setState(() => isLoading = !isLoading);
                            Map response = await Api.instance
                                .login(_emailFilter.text, _passwordFilter.text);

                            bool result = response.remove('result');
                            if (result && await Account.instance.setUser()) {
                              Navigator.of(context)
                                  .push(BottomRoute(page: HomePage()));
                            } else {
                              Utils.showErrorPopUp(context,
                                  text: response.values.toList()[0][0] ??
                                      'Error');
                            }
                            setState(() => isLoading = !isLoading);
                          },
                          color: Colors.white,
                          child: Text(
                            'Вход',
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ))),
                ],
              ),
            ),
          ),
        )));
  }
}
