import 'abstract_model.dart';

class News extends ModelItem {
  int id;
  String body;
  String shortDescription;
  List listImages;
  String created;

  News(
      {String name,
      this.body,
      this.shortDescription,
      this.id,
      this.listImages,
      this.created})
      : super(name);

  factory News.fromJson(Map<String, dynamic> data) => News(
      name: data['title'],
      id: data['id'],
      body: data['content'],
      listImages: data['post_images'] as List ?? [],
      created: data['created'],
      shortDescription: data['short_description']);


  String get previewImage => listImages?.first;

  List get images => listImages ?? [];
}
