import 'dart:convert';

String restaurantConfigToJson(RestaurantConfig data) {
  final str = data.toJson();
  return json.encode(str);
}

RestaurantConfig restaurantConfigFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return RestaurantConfig.fromJson(data);
  }
  return null;
}

class RestaurantConfig {
  int id;
  String image;
  String branchPhone;
  String branchName;
  String address;
  String googleMapsIframe;
  String shortDescription;
  String weekdayWorkingHours;
  String weekendWorkingHours;

  RestaurantConfig(
      {this.id,
      this.image,
      this.branchPhone,
      this.branchName,
      this.address,
      this.googleMapsIframe,
      this.weekdayWorkingHours,
      this.weekendWorkingHours,
      this.shortDescription});

  factory RestaurantConfig.fromJson(Map<String, dynamic> data) => RestaurantConfig(
      id: data['id'],
      image: data['image'],
      branchPhone: data['branch_phone'],
      branchName: data['branch_name'],
      weekdayWorkingHours: data['weekday_working_hours'],
      weekendWorkingHours: data['weekend_working_hours'],
      address: data['address'],
      googleMapsIframe: data['google_maps_iframe'],
      shortDescription: data['short_description']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'branch_phone': branchPhone,
        'branch_name': branchName,
        'weekday_working_hours': weekdayWorkingHours,
        'weekend_working_hours': weekendWorkingHours,
        'address': address,
        'google_maps_iframe': googleMapsIframe,
        'short_description': shortDescription,
      };
}
