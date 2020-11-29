part of 'sign_up_bloc.dart';

enum DialogType { info, phone, navigation, none }

class SignUpState extends Equatable {
  final Map fieldsError;
  final bool obscureText;
  final bool obscureTextConfirm;
  final bool isLoading;
  final bool neetTranslate;
  final DialogType showDialog;
  final String token;
  final String verificationId;
  final String dialogText;
  final Widget route;

  const SignUpState({
    this.obscureText = true,
    this.fieldsError,
    this.isLoading = false,
    this.obscureTextConfirm = true,
    this.neetTranslate = false,
    this.showDialog = DialogType.none,
    this.token,
    this.verificationId,
    this.dialogText,
    this.route,
  });

  SignUpState copyWith({
    Map errors,
    bool obscure,
    bool obscureConfirm,
    bool loading,
    String authToken,
    String verification,
    String textDialog,
    DialogType dialog = DialogType.none,
    Widget pageRoute,
    bool translate = false,
  }) {
    return SignUpState(
      fieldsError: errors ?? fieldsError ?? {},
      obscureText: obscure ?? obscureText,
      obscureTextConfirm: obscureConfirm ?? obscureTextConfirm,
      isLoading: loading ?? isLoading,
      token: authToken ?? token,
      verificationId: verification ?? verificationId,
      dialogText: textDialog ?? dialogText,
      route: pageRoute ?? route,
      showDialog: dialog,
      neetTranslate: translate,
    );
  }

  bool get isDialog {
    if (showDialog == DialogType.none) return false;
    if (showDialog == DialogType.phone &&
        token != null &&
        verificationId != null) {
      return true;
    } else if (showDialog == DialogType.info &&
        dialogText != null &&
        dialogText.isNotEmpty) {
      return true;
    } else if (showDialog == DialogType.navigation && route != null) {
      return true;
    }
    return false;
  }

  @override
  List<Object> get props => [
        showDialog,
        dialogText,
        obscureText,
        obscureTextConfirm,
        verificationId,
        token,
        fieldsError,
        isLoading,
      ];
}
