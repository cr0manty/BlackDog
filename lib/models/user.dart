import 'dart:convert';

import 'package:black_dog/models/voucher.dart';

String userToJson(User data) {
  final str = data.toJson();
  return json.encode(str);
}

User userFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return User.fromJson(data);
  }
  return null;
}

class User {
  String firstName;
  String lastName;
  String email;
  String phone;
  String instagramUsername;
  String qrCode;
  List<Voucher> vouchers;
  bool isStaff;

  User(
      {this.firstName,
      this.email,
      this.phone,
      this.isStaff,
      this.vouchers,
      this.lastName,
      this.instagramUsername,
      this.qrCode});

  @override
  int get hashCode => email.hashCode;

  bool operator ==(o) => email == o.email;

  @override
  toString() {
    return firstName;
  }

  factory User.fromJson(Map<String, dynamic> json) => new User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      instagramUsername: json['instagram_username'],
      qrCode: json['qr_code'],
      isStaff: json['is_staff'],
      vouchers: vouchersFromJsonList(json['vouchers'] ?? []));

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'qr_code': qrCode,
        'instagram_username': instagramUsername,
        'email': email,
        'is_staff': isStaff,
        'vouchers': vouchers ?? []
      };
}
