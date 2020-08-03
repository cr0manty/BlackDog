import 'package:flutter/material.dart';

const main_color = Color.fromRGBO(193, 39, 45, 1);

class HexColor extends Color {
  static Color lightElement = HexColor('#E9E9E9');
  static Color semiElement = HexColor('#636366');
  static Color darkElement = Color.fromRGBO(37, 36, 39, 1);

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}