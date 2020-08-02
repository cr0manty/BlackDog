import 'abstract_model.dart';

class News extends ModelItem {
  int id;
  String body;
  String shortDescription;
  String previewImage;

  News({String name, this.body, this.previewImage, this.shortDescription, this.id})
      : super(name);

  factory News.fromJson(Map<String, dynamic> data) => new News(
      name: data['title'],
      body: data['content'],
      previewImage: data['first_image'],
      shortDescription: data['short_description']);
}
