abstract class ModelItem {
  String name;

  ModelItem(this.name);

  String get capitalizeTitle {
    if (name == null || name.isEmpty) {
      return name ?? '';
    }

    return name[0].toUpperCase() + name.substring(1);
  }

  static String capitalize(String text) {
    if (text == null || text.isEmpty) {
      return text ?? '';
    }

    return text[0].toUpperCase() + text.substring(1);
  }
}
