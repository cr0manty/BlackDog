import 'package:black_dog/instances/account.dart';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/screens/auth/sign_in.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/sizes.dart';
import 'package:black_dog/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../home_page.dart';
import '../staff_home.dart';

class SignUpConfirmPage extends StatefulWidget {
  final String token;

  SignUpConfirmPage({this.token});

  @override
  _SignUpConfirmPageState createState() => _SignUpConfirmPageState();
}

class _SignUpConfirmPageState extends State<SignUpConfirmPage> {
  DateTime selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  static const List<String> _fieldsList = [
    'first_name',
    'last_name',
    'birth_date'
  ];
  Map fieldsError = {};
  bool isLoading = false;
  bool termsAccept = false;

  Widget _buildAddition() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _nameFocus,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_lastNameFocus),
              controller: _nameController,
              keyboardType: TextInputType.name,
              hintText: AppLocalizations.of(context).translate('first_name'),
            )),
        Utils.instance.showValidateError(fieldsError, key: 'first_name'),
        Container(
            alignment: Alignment.center,
            child: TextInput(
              focusNode: _lastNameFocus,
              onFieldSubmitted: (_) => _showModalBottomSheet(context),
              controller: _lastNameController,
              keyboardType: TextInputType.name,
              hintText: AppLocalizations.of(context).translate('last_name'),
            )),
        Utils.instance.showValidateError(fieldsError, key: 'last_name'),
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
                      style: Utils.instance.getTextStyle('bodyText1').copyWith(
                          color: selectedDate != null
                              ? HexColor.darkElement
                              : HexColor.inputHintColor),
                    ),
                    Icon(
                      SFSymbols.calendar,
                      color: HexColor.black,
                    )
                  ],
                ))),
        Utils.instance.showValidateError(fieldsError, key: 'birth_date'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Utils.instance.showTermPolicy(
                    context,
                    Api.instance.termsAndPrivacy(),
                    'terms',
                    'terms_and_conditions'),
                child: Container(
                    width: ScreenSize.maxAboutSectionTextWidth + 20,
                    child: RichText(
                        text: TextSpan(
                            style: Utils.instance.getTextStyle('subtitle2'),
                            children: termsText())))),
            CupertinoSwitch(
              activeColor: CupertinoColors.activeGreen,
              value: termsAccept,
              onChanged: (accept) => setState(() => termsAccept = accept),
            ),
          ],
        ),
      ],
    );
  }

  List<TextSpan> termsText() {
    List<TextSpan> widgets = [
      TextSpan(text: '${AppLocalizations.of(context).translate('user_accept')} ')
    ];

    List<TextSpan> addition = [
      TextSpan(text: ' ${AppLocalizations.of(context).translate('title')} '),
      TextSpan(
          text: AppLocalizations.of(context).translate('terms'),
          style: Utils.instance.getTextStyle('bodyText2').copyWith(
              color: CupertinoColors.activeGreen,
              decoration: TextDecoration.underline))
    ];

    return widgets + (SharedPrefs.getLanguageCode() == 'en' ? addition : addition.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(children: [
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
              onTap: FocusScope.of(context).unfocus,
              child: Container(
                  height: ScreenSize.height,
                  width: ScreenSize.width,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                      key: _formKey,
                      child:  SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              _buildAddition(),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(top: 40),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                          width: ScreenSize.width - 64,
                                          child: CupertinoButton(
                                              disabledColor: HexColor
                                                  .lightElement
                                                  .withOpacity(0.5),
                                              onPressed: termsAccept
                                                  ? _additionRegister
                                                  : null,
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
                                                        color: HexColor
                                                            .darkElement),
                                              ))),
                                      CupertinoButton(
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pushAndRemoveUntil(
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        SignInPage()),
                                                (route) => false),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'already_have_account'),
                                          textAlign: TextAlign.center,
                                          style: Utils.instance
                                              .getTextStyle('bodyText2'),
                                        ),
                                      ),
                                    ],
                                  ))
                            ])),
                      ))),
            ),
      ]),
    );
  }

  void _showModalBottomSheet(context) {
    FocusScope.of(context).unfocus();
    DateTime today = DateTime.now();

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              color: HexColor.darkElement,
              child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle:
                          Utils.instance.getTextStyle('subtitle1'),
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
      'birth_date': Utils.instance.dateFormat(selectedDate),
      'first_name': _nameController.text,
      'last_name': _lastNameController.text,
      'firebase_uid': SharedPrefs.getUserFirebaseUID()
    };
  }

  Future _additionRegister() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = !isLoading;
      fieldsError = {};
    });
    Map response =
        await Api.instance.updateUser(_sendData(), token: widget.token);
    bool result = response.remove('result');

    if (result) {
      SharedPrefs.saveToken(widget.token);
      if (await Account.instance.setUser()) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (context) => Account.instance.user.isStaff
                    ? StaffHomePage()
                    : HomePage()),
            (route) => false);
      } else {
        SharedPrefs.logout();
        setState(() => isLoading = false);
        EasyLoading.instance..backgroundColor = HexColor.errorRed;
        EasyLoading.showError('');
      }
    } else {
      response.forEach((key, value) {
        if (_fieldsList.contains(key)) {
          fieldsError[key] = value[0];
        } else {
          Utils.instance.infoDialog(context, value[0]);
          return;
        }
      });
    }
    setState(() => isLoading = !isLoading);
  }
}
