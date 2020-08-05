import 'package:intl/intl.dart';

import 'abstract_model.dart';

class News extends ModelItem {
  int id;
  String body;
  String shortDescription;
  String previewImage;
  List listImages;
  String created;

  News(
      {String name,
      this.body,
      this.previewImage,
      this.shortDescription,
      this.id,
      this.listImages,
      this.created})
      : super(name);

  factory News.fromJson(Map<String, dynamic> data) => News(
      name: data['title'],
      id: data['id'],
      body: data['content'],
      previewImage: data['first_image'],
      listImages: data['post_images'] as List ?? [],
      created: data['created'],
      shortDescription: data['short_description']);

  String get createTime =>
      created != null ? DateFormat.yMd().format(DateTime.parse(created)) : null;

  List get images => listImages ?? [previewImage] ?? [];
}
