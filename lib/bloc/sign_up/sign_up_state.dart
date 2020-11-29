part of 'sign_up_bloc.dart';

enum DialogType { info, phone, none }

class SignUpState extends Equatable {
  final Map fieldsError;
  final bool obscureText;
  final bool obscureTextConfirm;
  final bool isLoading;
  final DialogType showDialog;
  final String token;
  final String verificationId;
  final String dialogText;

  const SignUpState({
    this.obscureText = true,
    this.fieldsError,
    this.isLoading = false,
    this.obscureTextConfirm = true,
    this.showDialog = DialogType.none,
    this.token,
    this.verificationId,
    this.dialogText,
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
  }) {
    return SignUpState(
      fieldsError: errors ?? fieldsError ?? {},
      obscureText: obscure ?? obscureText,
      obscureTextConfirm: obscureConfirm ?? obscureTextConfirm,
      isLoading: loading ?? isLoading,
      token: authToken ?? token,
      verificationId: verification ?? verificationId,
      dialogText: textDialog ?? dialogText,
      showDialog: dialog,
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
