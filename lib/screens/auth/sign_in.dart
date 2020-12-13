import 'package:black_dog/bloc/sign_in/sign_in_bloc.dart';
import 'package:black_dog/bloc/sign_up/sign_up_bloc.dart';
import 'package:black_dog/screens/auth/sign_up.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'forgot_password.dart';

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
  SignInBloc _signInBloc;

  void onFieldSubmitted() {
    if (_phoneController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_phoneFocus);
    } else if (_passwordController.text.isEmpty) {
      FocusScope.of(context).unfocus();
    } else {
      _signInBloc.add(SignInLoginClickEvent(
          _phoneController.text, _passwordController.text));
    }
  }

  @override
  void initState() {
    super.initState();
    _signInBloc = BlocProvider.of<SignInBloc>(context);
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
          BlocConsumer<SignInBloc, SignInState>(
            listener: (context, state) {},
            buildWhen: (prev, current) => prev.isLoading != current.isLoading,
            builder: (context, state) {
              return ModalProgressHUD(
                progressIndicator: CupertinoActivityIndicator(),
                inAsyncCall: state.isLoading,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    height: ScreenSize.height,
                    width: ScreenSize.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: BlocBuilder<SignInBloc, SignInState>(
                        builder: (context, state) {
                          return CustomScrollView(
                            slivers: [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            style: Utils.instance
                                                .getTextStyle('caption'),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextInput(
                                          focusNode: _phoneFocus,
                                          controller: _phoneController,
                                          alignment: Alignment.center,
                                          keyboardType: TextInputType.phone,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .requestFocus(_passwordFocus),
                                          hintText: AppLocalizations.of(context)
                                              .translate('phone'),
                                        ),
                                        Utils.instance.showValidateError(
                                            state.fieldsError,
                                            key: 'phone_number'),
                                        TextInput(
                                          alignment: Alignment.center,
                                          obscureText: state.obscureText,
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          hintText: AppLocalizations.of(context)
                                              .translate('password'),
                                          onFieldSubmitted: (_) =>
                                              onFieldSubmitted(),
                                          suffixIcon: GestureDetector(
                                            child: Icon(
                                                state.obscureText
                                                    ? CupertinoIcons.eye_fill
                                                    : CupertinoIcons
                                                        .eye_slash_fill,
                                                color: HexColor.darkElement),
                                            onTap: () {
                                              BlocProvider.of<SignInBloc>(
                                                      context)
                                                  .add(
                                                SignInShowPasswordEvent(),
                                              );
                                            },
                                          ),
                                          inputAction: TextInputAction.done,
                                        ),
                                        Utils.instance.showValidateError(
                                            state.fieldsError,
                                            key: 'password',
                                            bottomPadding: false),
                                        ForgotPassword(),
                                      ],
                                    ),
                                    // SocialAuth(textKey: 'sign_in_with'), //todo: after release
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.only(
                                          bottom:
                                              ScreenSize.elementIndentHeight),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            width: ScreenSize.width - 64,
                                            child: CupertinoButton(
                                                onPressed: () {
                                                  _signInBloc.add(
                                                      SignInLoginClickEvent(
                                                          _phoneController.text,
                                                          _passwordController
                                                              .text));
                                                },
                                                color: HexColor.lightElement,
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate('sign_in'),
                                                    textAlign: TextAlign.center,
                                                    style: Utils.instance
                                                        .getTextStyle('caption')
                                                        .copyWith(
                                                            color: HexColor
                                                                .darkElement))),
                                          ),
                                          CupertinoButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.of(context).pushNamed(
                                                  '/sign_up',
                                                );
                                              },
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('no_account'),
                                                  textAlign: TextAlign.center,
                                                  style: Utils.instance
                                                      .getTextStyle(
                                                          'bodyText2'))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _signInBloc?.close();
    super.dispose();
  }
}
