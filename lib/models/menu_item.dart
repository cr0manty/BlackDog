import 'package:black_dog/utils/localization.dart';

import 'abstract_model.dart';

class MenuItem extends ModelItem {
  int id;
  String description;
  String shortDescription;
  String price;
  String image;
  bool isActive;
  List<MenuItemVariation> variations;

  MenuItem(
      {String name,
      this.price,
      this.description,
      this.image,
      this.isActive,
      this.shortDescription,
      this.variations,
      this.id})
      : super(name);

  factory MenuItem.fromJson(Map<String, dynamic> data) => MenuItem(
      name: data['name'],
      price: data['price'],
      isActive: data['is_active'],
      description: data['description'],
      shortDescription: data['short_description'],
      id: data['id'],
      image: data['image'],
      variations: _variationsFromJson(data['variations']));

  static _variationsFromJson(List data) {
    List<MenuItemVariation> variations = [];
    data.forEach(
        (element) => variations.add(MenuItemVariation.fromJson(element)));
    return variations;
  }

  String priceWithCurrency(context, {String actualPrice}) {
    return '${actualPrice ?? price} ' + AppLocalizations.of(context).translate('currency');
  }
}

class MenuItemVariation {
  int id;
  String name;
  String price;

  MenuItemVariation({this.name, this.price, this.id});

  factory MenuItemVariation.fromJson(Map<String, dynamic> data) =>
      MenuItemVariation(
          name: data['name'], price: data['price'], id: data['id']);

  String priceWithCurrency(context) {
    return '$price ' + AppLocalizations.of(context).translate('currency');
  }
}
