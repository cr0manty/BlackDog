abstract class ScreenSize {
  static double height;
  static double width;

  static double get sectionIndent => height * 0.04;

  static double get scanQRCodeIndent => height * 0.1;

  static double get scanQRCodeSize => height * 0.13;

  static double get scanQRCodeIconSize => scanQRCodeSize * 0.7;

  static double get elementIndentHeight => height * 0.03;

  static double get elementIndentWidth => width * 0.02;

  static double get labelIndent => width * 0.005;

  static double get newsBlockHeight => height * 0.26;

  static double get newsBlockWidth => width * 0.38;

  static double get newsSmallBlockWidth => width * 0.3;

  static double get newsSmallBlockHeight => height * 0.15;

  static double get newsListBlockSize => width * 0.3;

  static double get menuBlockHeight => width * 0.22;

  static double get qrCodeHeight => height * 0.3;

  static double get menuItemSize => height * 0.1;
}
