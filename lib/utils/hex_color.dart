import 'package:flutter/cupertino.dart';

class HexColor extends Color {
  static Color lightElement = HexColor('#E9E9E9');
  static Color semiElement = HexColor('#BBBBBB');
  static Color inputHintColor = HexColor('#636366');
  static Color darkElement = Color.fromRGBO(37, 36, 39, 1);
  static Color cardBackground = HexColor('#000000').withOpacity(0.5);
  static Color errorRed = HexColor('#AF3F3F').withOpacity(0.8);
  static Color successGreen = HexColor('#FF4CAF50');
  static Color transparent = HexColor('#00000000');
  static Color black = HexColor('#000000');

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
