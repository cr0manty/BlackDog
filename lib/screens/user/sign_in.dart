import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/screens/user/sign_up.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'fortgot_password.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  static const List<String> _fieldsList = ['email', 'password'];
  Map fieldsError = {};
  bool _obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Utils.initScreenSize(MediaQuery.of(context).size);

    return Scaffold(
        body: ModalProgressHUD(
            progressIndicator: CupertinoActivityIndicator(),
            inAsyncCall: isLoading,
                child: Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: ScrollConfiguration(
                    behavior: ScrollGlow(),
                    child: CustomScrollView(slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
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
                                AppLocalizations.of(context)
                                    .translate('sign_in'),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    child: TextInput(
                                      controller: _emailFilter,
                                      keyboardType: TextInputType.emailAddress,
                                      hintText: AppLocalizations.of(context)
                                          .translate('email'),
                                      inputAction:
                                          TextInputAction.continueAction,
                                    )),
                                Utils.showValidateError(fieldsError,
                                    key: 'email'),
                                Container(
                                    alignment: Alignment.center,
                                    child: TextInput(
                                      obscureText: _obscureText,
                                      controller: _passwordFilter,
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
                                    key: 'password', bottomPadding: false),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: CupertinoButton(
                                      padding: EdgeInsets.only(
                                          top: 8, bottom: 8, left: 8),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    ForgotPassword()));
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('forgot_password'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
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
                                          color: HexColor.lightElement,
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('sign_in'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      color: HexColor
                                                          .darkElement))),
                                    ),
                                    CupertinoButton(
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          Navigator.of(context).push(
                                              BottomRoute(page: SignUpPage()));
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .translate('no_account'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2)),
                                  ],
                                )),
                          ],
                        ),
                      )
                    ]),
                  )),
            )));
  }

  Future loginClick() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => isLoading = !isLoading);
    fieldsError = {};
    await Api.instance
        .login(_emailFilter.text, _passwordFilter.text)
        .then((response) async {
      bool result = response.remove('result');
      if (result && await Account.instance.setUser()) {
        Navigator.of(context).pushAndRemoveUntil(
            BottomRoute(page: HomePage(isInitView: false)), (route) => false);
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
