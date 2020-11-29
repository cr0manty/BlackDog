import 'dart:async';

import 'package:black_dog/instances/api.dart';
import 'package:black_dog/utils/debug_print.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState());
  static const List<String> _fieldsList = [
    'password1',
    'password2',
    'phone_number',
  ];

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpLoadingEvent) {
      yield state.copyWith(loading: !state.isLoading);
    } else if (event is SignUpShowDialogEvent) {
      yield state.copyWith(
        loading: false,
        dialog: DialogType.info,
        textDialog: event.text,
      );
    } else if (event is SignUpShowPhoneAuthDialogEvent) {
      yield state.copyWith(
        loading: false,
        dialog: DialogType.info,
        authToken: event.token,
        verification: event.verificationId,
      );
    } else if (event is SignUpCompleteEvent) {
      if (event.success) {
        yield state.copyWith(
          loading: false,
        );
      } else {
        yield state.copyWith(
          loading: false,
          dialog: DialogType.info,
          textDialog: event.errorMsg,
          errors: event.errors,
        );
      }
    } else if (event is SignUpSignUpEvent) {
      _mainRegistration(
        event.phone,
        event.password,
        event.passwordConfirm,
      );
    } else if (event is SignUpShowPasswordEvent) {
      yield state.copyWith(
        obscure: event.password,
        obscureConfirm: event.confirmPassword,
      );
    }
  }

  Future _registerWithPhone(String token, String phone) async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) {},
      verificationFailed: (FirebaseAuthException authException) {
        debugPrefixPrint(authException.message);
        this.add(SignUpShowDialogEvent(authException.message));
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        this.add(SignUpShowPhoneAuthDialogEvent(token, verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        debugPrefixPrint('Time out: $verificationId');
      },
    );
  }

  Future _mainRegistration(
    String phone,
    String password,
    String passwordConfirm,
  ) async {
    // BlocProvider.of<SignUpBloc>(context).add(SignUpLoadingEvent());
    this.add(SignUpLoadingEvent());
    Map<String, dynamic> errors = {};
    String errorMsg;

    Api.instance.register({
      'password1': password,
      'password2': passwordConfirm,
      'phone_number': phone,
    }).then((response) async {
      bool result = response.remove('result');
      if (result) {
        _registerWithPhone(response['key'], phone);
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
      this.add(SignUpCompleteEvent(errors, result, errorMsg: errorMsg));
      return;
    }).catchError((error) {
      debugPrefixPrint(error, prefix: 'error');
      this.add(SignUpCompleteEvent({}, false, errorMsg: "error"));

      // Utils.instance.infoDialog(
      //   context,
      //   AppLocalizations.of(context).translate('error'),
      //   isError: true,
      // );
    });
  }
}
