import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/screens/staff_home.dart';
import 'package:black_dog/screens/auth/sign_up.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/screens/home_page.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../user/forgot_password.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  static const List<String> _fieldsList = ['phone_number', 'password'];
  Map fieldsError = {};
  bool _obscureText = true;
  bool isLoading = false;

  Widget _forgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: CupertinoButton(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => ForgotPassword()));
          },
          child: Text(
            AppLocalizations.of(context).translate('forgot_password'),
            style: Utils.instance.getTextStyle('bodyText2'),
          )),
    );
  }

  void onFieldSubmitted() {
    if (_phoneController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_phoneFocus);
    } else if (_passwordController.text.isEmpty) {
      FocusScope.of(context).unfocus();
    } else {
      loginClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils.instance.initScreenSize(MediaQuery.of(context));

    return CupertinoPageScaffold(
        child: Stack(
      children: [
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
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
                height: ScreenSize.height,
                width: ScreenSize.width,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: CustomScrollView(slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(
                                    top: ScreenSize.mainMarginTop),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('sign_in'),
                                  style: Utils.instance.getTextStyle('caption'),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            child: Image.asset(Utils.logo,
                                height: ScreenSize.logoHeight,
                                width: ScreenSize.logoWidth),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextInput(
                                focusNode: _phoneFocus,
                                controller: _phoneController,
                                alignment: Alignment.center,
                                keyboardType: TextInputType.phone,
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_passwordFocus),
                                hintText: AppLocalizations.of(context)
                                    .translate('phone'),
                              ),
                              Utils.instance.showValidateError(fieldsError,
                                  key: 'phone_number'),
                              TextInput(
                                alignment: Alignment.center,
                                obscureText: _obscureText,
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                hintText: AppLocalizations.of(context)
                                    .translate('password'),
                                onFieldSubmitted: (_) => onFieldSubmitted(),
                                suffixIcon: GestureDetector(
                                    child: Icon(
                                        _obscureText
                                            ? CupertinoIcons.eye_fill
                                            : CupertinoIcons.eye_slash_fill,
                                        color: HexColor.darkElement),
                                    onTap: () => setState(
                                        () => _obscureText = !_obscureText)),
                                inputAction: TextInputAction.done,
                              ),
                              Utils.instance.showValidateError(fieldsError,
                                  key: 'password', bottomPadding: false),
                              _forgotPassword()
                            ],
                          ),
                          // SocialAuth(textKey: 'sign_in_with'), //todo: after release
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
                                            textAlign: TextAlign.center,
                                            style: Utils.instance
                                                .getTextStyle('caption')
                                                .copyWith(
                                                    color:
                                                        HexColor.darkElement))),
                                  ),
                                  CupertinoButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    SignUpPage()));
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .translate('no_account'),
                                          textAlign: TextAlign.center,
                                          style: Utils.instance
                                              .getTextStyle('bodyText2'))),
                                ],
                              )),
                        ],
                      ),
                    )
                  ]),
                )),
          ),
        ),
      ],
    ));
  }

  Future loginClick() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = !isLoading;
      fieldsError = {};
    });

    await Api.instance
        .login(_phoneController.text, _passwordController.text)
        .then((response) async {
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
      return;
    }).catchError((error) {
      setState(() => isLoading = !isLoading);
      print(error);
      EasyLoading.instance..backgroundColor = HexColor.errorRed;
      EasyLoading.showError('');
    });
  }
}
