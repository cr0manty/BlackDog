import 'abstract_model.dart';

class MenuItem extends ModelItem {
  int id;
  String description;
  String shortDescription;
  String price;
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

  String get priceWithCurrency => '$price грн.';
}
