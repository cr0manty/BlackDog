import 'abstract_model.dart';

class MenuCategory extends ModelItem {
  final int id;
  final String image;

  MenuCategory({String name, this.image, this.id}) : super(name);


  factory MenuCategory.fromJson(Map<String, dynamic> data) => MenuCategory(
      name: data['name'],
      id: data['id'],
      image: data['image']
  );
}
