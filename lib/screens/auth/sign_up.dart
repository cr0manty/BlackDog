import 'package:black_dog/bloc/sign_up/sign_up_bloc.dart';
import 'package:black_dog/screens/auth/widgets/confirm_number_dialog.dart';
import 'package:black_dog/screens/auth/widgets/sign_up_fields.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _password1Focus = FocusNode();
  final FocusNode _password2Focus = FocusNode();

  @override
  Widget build(BuildContext context) {
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
          BlocConsumer<SignUpBloc, SignUpState>(
            listenWhen: (prev, current) => current.isDialog,
            listener: (context, state) {
              if (state.showDialog == DialogType.phone) {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => BlocProvider<SignUpBloc>.value(
                    value: BlocProvider.of<SignUpBloc>(context),
                    child: ConfirmPhoneDialog(
                      state.verificationId,
                      state.token,
                    ),
                  ),
                );
              } else if (state.showDialog == DialogType.info) {
                String msg;

                if (state.neetTranslate) {
                  AppLocalizations.of(context).translate(state.dialogText);
                } else {
                  msg = state.dialogText;
                }
                Utils.instance.infoDialog(
                  context,
                  msg,
                );
              } else if (state.showDialog == DialogType.navigation) {
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (context) => state.route,
                    ),
                    (route) => false);
              }
            },
            buildWhen: (prev, current) => prev.isLoading != current.isLoading,
            builder: (context, state) {
              return ModalProgressHUD(
                progressIndicator: CupertinoActivityIndicator(),
                inAsyncCall: state.isLoading,
                child: GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  child: Container(
                    height: ScreenSize.height,
                    width: ScreenSize.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                style: Utils.instance.getTextStyle('caption'),
                              ),
                            ),
                            SignUpFields(
                              _password1Controller,
                              _phoneController,
                              _password2Controller,
                              _phoneFocus,
                              _password1Focus,
                              _password2Focus,
                            ),
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
                                      onPressed: () {
                                        BlocProvider.of<SignUpBloc>(context)
                                            .add(
                                          SignUpSignUpEvent(
                                            password: _password1Controller.text,
                                            passwordConfirm:
                                                _password2Controller.text,
                                            phone: _phoneController.text,
                                          ),
                                        );
                                      },
                                      color: HexColor.lightElement,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('register'),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: Utils.instance
                                            .getTextStyle('headline1')
                                            .copyWith(
                                                color: HexColor.darkElement),
                                      ),
                                    ),
                                  ),
                                  CupertinoButton(
                                    onPressed: Navigator.of(context).pop,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('already_have_account'),
                                      textAlign: TextAlign.center,
                                      style: Utils.instance
                                          .getTextStyle('bodyText2'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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
}
