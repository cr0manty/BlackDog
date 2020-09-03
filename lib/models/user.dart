import 'dart:convert';
import 'abstract_model.dart';

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
  bool isStaff;
  int voucherPurchase;
  int currentPurchase;

  User({this.firstName,
    this.email,
    this.phone,
    this.isStaff,
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
          isStaff: data['is_staff']);

  Map<String, dynamic> toJson() =>
      {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phone,
        'instagram_username': instagramUsername,
        'voucher_purchase_count': voucherPurchase,
        'current_purchase_count': currentPurchase,
        'is_staff': isStaff,
      };

  String get fullName {
    return lastName != null ? '${ModelItem.capitalize(firstName)} ${ModelItem
        .capitalize(lastName)}' : ModelItem.capitalize(firstName);
  }
}
