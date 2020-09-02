import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/utils/scroll_glow.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/widgets/bottom_route.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_core/firebase_core.dart';
import '../home_page.dart';

class SignUpPage extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => setState(() {}));
  }

  Widget _buildFields() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _nameFocus,
              targetFocus: _lastNameFocus,
              controller: _nameController,
              keyboardType: TextInputType.name,
              hintText: AppLocalizations.of(context).translate('first_name'),
            )),
        Utils.instance.showValidateError(fieldsError, key: 'first_name'),
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _lastNameFocus,
              targetFocus: _phoneFocus,
              controller: _lastNameController,
              keyboardType: TextInputType.name,
              hintText: AppLocalizations.of(context).translate('last_name'),
            )),
        Utils.instance.showValidateError(fieldsError, key: 'last_name'),
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _phoneFocus,
              targetFocus: _password1Focus,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              hintText: AppLocalizations.of(context).translate('phone'),
            )),
        Utils.instance.showValidateError(fieldsError, key: 'phone_number'),
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _password1Focus,
              targetFocus: _password2Focus,
              obscureText: _obscureText,
              controller: _password1Controller,
              hintText: AppLocalizations.of(context).translate('password'),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureText ? Icons.remove_red_eye : Icons.visibility_off,
                    color: HexColor.darkElement),
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
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
                onTap: () {
                  setState(() {
                    _obscureTextConfirm = !_obscureTextConfirm;
                  });
                },
              ),
              validator: (String text) {
                if (text != _password1Controller.text) {
                  return AppLocalizations.of(context)
                      .translate('password_mismatch');
                }
                return null;
              },
              inputAction: TextInputAction.done,
            )),
        Utils.instance.showValidateError(fieldsError, key: 'password2'),
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
                onTap: () => FocusScope.of(context).unfocus(),
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
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              _buildFields(),
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
                    ))))
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
    return {
      'first_name': _nameController.text,
      'last_name': _lastNameController.text,
      'password1': _password1Controller.text,
      'password2': _password2Controller.text,
      'phone_number': _phoneController.text,
      'birth_date': Utils.instance.dateFormat(selectedDate),
    };
  }

  Future registerWithPhone() async {
    _codeController.clear();

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) {
          FirebaseAuth.instance.signInWithCredential(credential).then((result) {
            Navigator.of(context).pushAndRemoveUntil(
                BottomRoute(page: HomePage(isInitView: false)),
                (route) => false);
          }).catchError((e) {
            Navigator.of(context).pop();
            Utils.instance.showErrorPopUp(context, text: e);
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
          Navigator.of(context).pop();
          Utils.instance.showErrorPopUp(context, text: authException.message);
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
                        child: Text('Done'),
                        onPressed: () async {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: _codeController.text.trim());
                          UserCredential result = await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          if (result != null && result.user != null) {
                            SharedPrefs.saveUserFirebaseUid(result.user.uid);
                            Api.instance.sendFirebaseUserUID();
                            Navigator.of(context).pushAndRemoveUntil(
                                BottomRoute(page: HomePage(isInitView: false)),
                                (route) => false);
                          }
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop,
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Time out");
        });
  }

  Future registerClick() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => isLoading = !isLoading);
    fieldsError = {};

    await Api.instance.register(_sendData()).then((response) async {
      bool result = response.remove('result');
      if (result && await Account.instance.setUser()) {
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
      Utils.instance.showErrorPopUp(context);
    });
  }
}
