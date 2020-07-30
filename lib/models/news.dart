class News {
  String title;
  String body;
  String date;
  String previewImage;
  List<String> images;

  News({this.body, this.date, this.images, this.title, this.previewImage});

  String get capitalizeTitle {
    if (title == null || title.isEmpty) {
      return title ?? '';
    }

    return title[0].toUpperCase() + title.substring(1);
  }
}
