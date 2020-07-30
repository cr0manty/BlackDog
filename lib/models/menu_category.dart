import 'package:black_dog/models/menu_item.dart';

class MenuCategory {
  final String title;
  final String previewImage;
  List<MenuItem> items;

  MenuCategory({this.title, this.items, this.previewImage});

   String get capitalizeTitle {
    if (title == null || title.isEmpty) {
      return title ?? '';
    }

    return title[0].toUpperCase() + title.substring(1);
  }
}