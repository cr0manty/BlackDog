import 'dart:convert';

News newsFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return News.fromJson(data);
  }
  return null;
}

class News {
  int id;
  String title;
  String body;
  String shortContent;
  String previewImage;

  News({this.body, this.title, this.previewImage, this.shortContent, this.id});

  String get capitalizeTitle {
    if (title == null || title.isEmpty) {
      return title ?? '';
    }

    return title[0].toUpperCase() + title.substring(1);
  }

  factory News.fromJson(Map<String, dynamic> json) => new News(
      title: json['title'],
      body: json['content'],
      previewImage: json['first_image'],
      shortContent: json['short_content']);

  Map<String, dynamic> toJson() => {
        'first_image': previewImage,
        'short_content': shortContent,
        'title': title,
        'content': body
      };
}
