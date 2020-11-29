part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInLoadingEvent extends SignInEvent {}

class SignInShowPasswordEvent extends SignInEvent {}

class SignInCompleteEvent extends SignInEvent {
  final Map<String, dynamic> errors;
  final bool success;
  final String errorMsg;
  final bool needTranslate;

  SignInCompleteEvent(
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

class SignInNavigationEvent extends SignInEvent {
  final String route;

  SignInNavigationEvent(this.route);

  @override
  List<Object> get props => [route];
}

class SignInLoginClickEvent extends SignInEvent {
  final String phone;
  final String password;

  SignInLoginClickEvent(this.phone, this.password);

  @override
  List<Object> get props => [phone, password];
}
