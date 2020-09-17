import 'dart:convert';

import 'package:black_dog/utils/localization.dart';

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
  String shortDescription;
  String weekdayWorkingHours;
  String weekendWorkingHours;
  String longitude;
  String latitude;

  RestaurantConfig(
      {this.id,
      this.image,
      this.branchPhone,
      this.branchName,
      this.address,
      this.latitude,
      this.longitude,
      this.weekdayWorkingHours,
      this.weekendWorkingHours,
      this.shortDescription});

  factory RestaurantConfig.fromJson(Map<String, dynamic> data) =>
      RestaurantConfig(
          id: data['id'],
          image: data['image'],
          branchPhone: data['branch_phone'],
          branchName: data['branch_name'],
          weekdayWorkingHours: data['weekday_working_hours'],
          weekendWorkingHours: data['weekend_working_hours'],
          address: data['address'],
          longitude: data['lon'],
          latitude: data['lat'],
          shortDescription: data['short_description']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'branch_phone': branchPhone,
        'branch_name': branchName,
        'weekday_working_hours': weekdayWorkingHours,
        'weekend_working_hours': weekendWorkingHours,
        'address': address,
        'lat': latitude,
        'lon': longitude,
        'short_description': shortDescription,
      };

  double get lat => latitude != null ? double.parse(latitude) : null;
  double get lon => longitude != null ? double.parse(longitude) : null;

  String weekdayWorkingTime(context) {
    return AppLocalizations.of(context).translate('work_time') +
        '\n$weekdayWorkingHours';
  }

  String weekendWorkingTime(context) {
    return AppLocalizations.of(context).translate('weekday_working') +
        '\n$weekendWorkingHours';
  }

  String workingTime(context) {
    return AppLocalizations.of(context).translate('work_time') +
        ' $weekdayWorkingHours\n' +
        AppLocalizations.of(context).translate('weekday_working') +
        ' $weekendWorkingHours';
  }
}
