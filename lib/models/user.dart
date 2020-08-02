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
  List<Voucher> vouchers;
  bool isStaff;

  User(
      {this.firstName,
      this.email,
      this.phone,
      this.isStaff,
      this.vouchers,
      this.lastName,
      this.instagramUsername});

  @override
  int get hashCode => email.hashCode;

  bool operator ==(o) => email == o.email;

  @override
  toString() {
    return firstName;
  }

  factory User.fromJson(Map<String, dynamic> data) => new User(
      firstName: data['first_name'],
      lastName: data['last_name'],
      email: data['email'],
      phone: data['phone'],
      instagramUsername: data['instagram_username'],
      isStaff: data['is_staff'],
      vouchers: vouchersToJsonList(data['vouchers'] ?? []));

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'instagram_username': instagramUsername,
        'email': email,
        'is_staff': isStaff,
        'vouchers': vouchers ?? []
      };
}
