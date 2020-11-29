import 'dart:async';

import 'package:black_dog/instances/account.dart';
import 'package:black_dog/network/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  List<String> _fieldsList = ['phone_number', 'password'];

  SignInBloc() : super(SignInState());

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInLoginClickEvent) {
      _loginClick(event.phone, event.password);
    }
  }

  Future _loginClick(String phone, String password) async {
    this.add(SignInLoadingEvent());
    Map<String, dynamic> errors = {};
    String errorMsg;

    Api.instance.login(phone, password).then((response) async {
      bool result = response.remove('result');
      if (result && await Account.instance.setUser()) {
        Api.instance.sendFCMToken();
        this.add(
          SignInNavigationEvent(
            Account.instance.user.isStaff ? '/staff' : '/home',
          ),
        );
      } else {
        response.forEach((key, value) {
          if (_fieldsList.contains(key)) {
            errors[key] = value[0];
          } else {
            errorMsg = value[0];
            return;
          }
        });
      }
      this.add(SignInCompleteEvent(errors, result, errorMsg: errorMsg));
    }).catchError((error) {
      this.add(SignInCompleteEvent({}, false,
          errorMsg: "error", needTranslate: true));
    });
  }
}
