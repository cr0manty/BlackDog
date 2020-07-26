abstract class ScreenSize {
  static double height;
  static double width;

  static double get sectionIndent => height * 0.04;

  static double get scanQRCodeIndent => height * 0.1;

  static double get scanQRCodeSize => height * 0.13;

  static double get scanQRCodeIconSize => scanQRCodeSize * 0.7;

  static double get elementIndentHeight => height * 0.03;

  static double get elementIndentWidth => width * 0.02;
}
