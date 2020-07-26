import 'dart:convert';

String userToJson(User data) {
  final str = data.toJson();
  return json.encode(str);
}

User userFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return User.fromJson(data);
  }
}

class User {
  String firstName;
  String email;
  String phone;
  bool isStaff;

  User({this.firstName, this.email, this.phone, this.isStaff});

  @override
  int get hashCode => email.hashCode;

  bool operator ==(o) => email == o.email;

  @override
  toString() {
    return firstName;
  }

  factory User.fromJson(Map<String, dynamic> json) => new User(
      firstName: json['first_name'],
      email: json['email'],
      phone: json['phone'],
      isStaff: json['superuser']);

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'phone': phone,
        'email': email,
        'superuser': isStaff
      };
}
