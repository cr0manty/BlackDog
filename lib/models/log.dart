import 'dart:convert';

import 'package:black_dog/utils/hex_color.dart';
import 'package:black_dog/utils/localization.dart';
import 'package:flutter/material.dart';

Log logFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return Log.fromJson(data);
  }
  return null;
}

String logToJson(Log data) {
  final str = data.toJson();
  return json.encode(str);
}

class UserLog {
  String phone;
  String firstName;
  String lastName;

  UserLog({this.firstName, this.lastName, this.phone});

  factory UserLog.fromJson(Map<String, dynamic> data) => UserLog(
      firstName: data['first_name'],
      lastName: data['last_name'],
      phone: data['phone_number']);

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phone,
      };
}

class Log {
  int id;
  String created;
  String type;
  bool status;
  String errorMessage;
  UserLog user;
  int voucher;

  Log(
      {this.user,
      this.id,
      this.created,
      this.type,
      this.errorMessage,
      this.status,
      this.voucher});

  factory Log.fromJson(Map<String, dynamic> data) => Log(
      created: data['created'],
      id: data['id'],
      status: data['status'],
      errorMessage: data['error_message'],
      type: data['type'],
      voucher: data['voucher'],
      user: UserLog.fromJson(data['user'] ?? {}));

  Map<String, dynamic> toJson() => {
        'created': created,
        'id': id,
        'status': status,
        'error_message': errorMessage,
        'type': type,
        'user': user.toJson(),
      };

  String message(BuildContext context) =>
      errorMessage ??
      AppLocalizations.of(context)
          .translate(status ? 'success_log' : 'error_log');

  Color get color => status ? HexColor('#3C852E') : HexColor.errorRed;

  String scanType(BuildContext context) =>
      AppLocalizations.of(context).translate(errorMessage != null
          ? 'unknown'
          : (voucher != null ? 'scanned_voucher' : 'scanned_user'));
}
