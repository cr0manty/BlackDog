import 'package:black_dog/bloc/sign_in/sign_in_bloc.dart';
import 'package:black_dog/bloc/staff_bloc/staff_bloc.dart';
import 'package:black_dog/instances/account.dart';
import 'package:black_dog/screens/auth/sign_in.dart';
import 'package:black_dog/screens/home_page/home_view.dart';
import 'package:black_dog/screens/staff/staff_home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouteGenerator {
  StaffBloc _staffBloc = StaffBloc();
  SignInBloc _signInBloc = SignInBloc();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        if (Account.instance.state == AccountState.USER) {
          return MaterialPageRoute(
            builder: (_) => HomePage(),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider<StaffBloc>.value(
            value: _staffBloc,
            child: StaffHomePage(),
          ),
        );
      case "/sign_in":
        return MaterialPageRoute(
          builder: (context) => BlocProvider<SignInBloc>.value(
            value: _signInBloc,
            child: SignInPage(),
          ),
        );
      default:
        return null;
    }
  }

  void dispose() {
    _staffBloc.close();
    _signInBloc.close();
  }
}
