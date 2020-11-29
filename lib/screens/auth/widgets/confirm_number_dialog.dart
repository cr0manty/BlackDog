import 'package:black_dog/instances/shared_pref.dart';
import 'package:black_dog/instances/utils.dart';
import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../sign_up_confirm.dart';

class ConfirmPhoneDialog extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();
  final String token;
  final String verificationId;

  ConfirmPhoneDialog(this.verificationId, this.token);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(AppLocalizations.of(context).translate('enter_code'),
          style: Utils.instance.getTextStyle('headline1')),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: CupertinoTextField(
          style: Utils.instance.getTextStyle('subtitle2'),
          controller: _codeController,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context).translate('done'),
              style: Utils.instance
                  .getTextStyle('subtitle2')
                  .copyWith(color: CupertinoColors.activeBlue)),
          onPressed: () async {
            AuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: _codeController.text.trim());
            final result = await FirebaseAuth.instance
                .signInWithCredential(credential)
                .catchError((error) {
              Navigator.of(context).pop();
              Utils.instance.infoDialog(
                context,
                error.toString(),
              );
            });
            if (result != null && result.user != null) {
              SharedPrefs.saveUserFirebaseUid(result.user.uid);
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                      builder: (context) => SignUpConfirmPage(token: token)),
                  (route) => false);
            }
            return null;
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(AppLocalizations.of(context).translate('cancel'),
              style: Utils.instance
                  .getTextStyle('subtitle2')
                  .copyWith(color: HexColor.errorRed)),
          onPressed: Navigator.of(context).pop,
        )
      ],
    );
  }
}
