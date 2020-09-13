import 'package:flutter/material.dart';

class HexColor extends Color {
  static Color lightElement = HexColor('#E9E9E9');
  static Color semiElement = HexColor('#BBBBBB');
  static Color inputHintColor = HexColor('#636366');
  static Color darkElement = Color.fromRGBO(37, 36, 39, 1);
  static Color cardBackground = Colors.black.withOpacity(0.5);
  static Color backgroundColor = Color.fromRGBO(40, 39, 41, 1);
  static Color errorLog = HexColor('#AF3F3F');
  static Color successLog = HexColor('#3C852E');

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
