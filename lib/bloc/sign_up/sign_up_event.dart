part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpLoadingEvent extends SignUpEvent {}

class SignUpCompleteEvent extends SignUpEvent {
  final Map<String, dynamic> errors;
  final bool success;
  final String errorMsg;
  final bool needTranslate;

  SignUpCompleteEvent(
    this.errors,
    this.success, {
    this.errorMsg,
    this.needTranslate = false,
  });

  @override
  List<Object> get props => [
        errors,
        success,
        errorMsg,
        needTranslate,
      ];
}

class SignUpShowDialogEvent extends SignUpEvent {
  final String text;

  SignUpShowDialogEvent(this.text);

  @override
  List<Object> get props => [text];
}

class SignUpShowPhoneAuthDialogEvent extends SignUpEvent {
  final String token;
  final String verificationId;

  SignUpShowPhoneAuthDialogEvent(this.token, this.verificationId);

  @override
  List<Object> get props => [token, verificationId];
}

class SignUpSignUpEvent extends SignUpEvent {
  final String phone;
  final String password;
  final String passwordConfirm;

  SignUpSignUpEvent({
    this.phone,
    this.passwordConfirm,
    this.password,
  });

  @override
  List<Object> get props => [phone, passwordConfirm, password];
}

class SignUpShowPasswordEvent extends SignUpEvent {
  final bool password;
  final bool confirmPassword;

  SignUpShowPasswordEvent({this.password, this.confirmPassword});

  @override
  List<Object> get props => [password, confirmPassword];
}

class SignUpNavigationEvent extends SignUpEvent {
  final Widget route;

  SignUpNavigationEvent(this.route);

  @override
  List<Object> get props => [route];
}
