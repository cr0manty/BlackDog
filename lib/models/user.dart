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
  int voucherPurchase;
  int currentPurchase;

  User({this.firstName,
    this.email,
    this.phone,
    this.isStaff,
    this.vouchers,
    this.lastName,
    this.instagramUsername,
    this.currentPurchase,
    this.voucherPurchase});

  @override
  int get hashCode => email.hashCode;

  bool operator ==(o) => email == o.email;

  @override
  toString() {
    return firstName;
  }

  factory User.fromJson(Map<String, dynamic> data) =>
      User(
          firstName: data['first_name'],
          lastName: data['last_name'],
          email: data['email'],
          phone: data['phone_number'],
          instagramUsername: data['instagram_username'],
          voucherPurchase: data['voucher_purchase_count'],
          currentPurchase: data['current_purchase_count'],
          isStaff: data['is_staff'],
          vouchers: vouchersFromJsonList(data['vouchers'] ?? []));

  Map<String, dynamic> toJson() =>
      {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phone,
        'instagram_username': instagramUsername,
        'voucher_purchase_count': voucherPurchase,
        'current_purchase_count': currentPurchase,
        'is_staff': isStaff,
        'vouchers': vouchersToJson()
      };

  List vouchersToJson() {
    List jsonVouchers = [];
    vouchers.map((voucher) => jsonVouchers.add(voucher.toJson()));
    return jsonVouchers;
  }
}
