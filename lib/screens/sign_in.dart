import 'package:black_dog/instances/size.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
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
                                    color: HexColor('#8c8c8c')),
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }),
                      ))),
                ],
              ),
            ),
          ),
        ));
  }
}
