import 'dart:convert';

String restaurantToJson(Restaurant data) {
  final str = data.toJson();
  return json.encode(str);
}

Restaurant restaurantFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return Restaurant.fromJson(data);
  }
  return null;
}

class Restaurant {
  String name;
  String email;
  String website;
  String phone;
  String instagramLink;
  String facebook;
  String logo;
  String location;
  String workTime;

  Restaurant(
      {this.name,
      this.email,
      this.facebook,
      this.instagramLink,
      this.logo,
      this.phone,
      this.location,
      this.workTime,
      this.website});

  factory Restaurant.fromJson(Map<String, dynamic> data) => Restaurant(
      name: data['name'],
      email: data['email'],
      facebook: data['facebook'],
      instagramLink: data['instagram_link'],
      logo: data['logo'],
      phone: data['phone'],
      workTime: data['work_time'],
      location: data['location'],
      website: data['website']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'facebook': facebook,
        'instagram_link': instagramLink,
        'logo': logo,
        'work_time': workTime,
        'location': location,
        'website': website,
      };

  String get webUrl => website ?? instagramLink;
}
