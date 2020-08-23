import 'package:black_dog/utils/localization.dart';

import 'abstract_model.dart';

class MenuItem extends ModelItem {
  int id;
  String description;
  String shortDescription;
  double price;
  String image;
  bool isActive;

  MenuItem(
      {String name,
      this.price,
      this.description,
      this.image,
      this.isActive,
      this.shortDescription,
      this.id})
      : super(name);

  factory MenuItem.fromJson(Map<String, dynamic> data) => MenuItem(
      name: data['name'],
      price: data['price'],
      isActive: data['is_active'],
      description: data['description'],
      shortDescription: data['short_description'],
      id: data['id'],
      image: data['image']);

  String priceWithCurrency(context) {
    return '${price.toInt()} ' + AppLocalizations.of(context).translate('currency');
  }
}
