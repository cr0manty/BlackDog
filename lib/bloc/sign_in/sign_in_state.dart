part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  final Map fieldsError;
  final bool obscureText;
  final bool isLoading;
  final String route;
  final String dialogText;

  const SignInState({
    this.isLoading = false,
    this.obscureText,
    this.fieldsError,
    this.dialogText,
    this.route,
  });

  bool get isDialog => dialogText != null;

  @override
  List<Object> get props => [];
}
