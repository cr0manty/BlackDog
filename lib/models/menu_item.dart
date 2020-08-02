import 'abstract_model.dart';

class MenuItem extends ModelItem {
  int id;
  String description;
  String shortDescription;
  String price;
  List<String> images;
  bool isActive;

  MenuItem(
      {String name,
      this.price,
      this.description,
      this.images,
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
      images: _setImages(data['images']));

  static List<String> _setImages(List images) {
    List<String> imageList = [];
    images.forEach((element) {
      imageList.add(element['image']);
    });
    return imageList;
  }

  String get image => images.length > 0 ? images[0] : null;

  String get priceWithCurrency => '$price грн.';
}
