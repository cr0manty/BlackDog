abstract class ScreenSize {
  static double height;
  static double width;

  static double get sectionIndent => height * 0.04;

  static double get scanQRCodeIndent => height * 0.05;

  static double get scanQRCodeSize => height * 0.17;

  static double get bonusCardSize => height * 0.12;

  static double get scanQRCodeIconSize => scanQRCodeSize * 0.85;

  static double get elementIndentHeight => height * 0.03;

  static double get elementIndentWidth => width * 0.02;

  static double get labelIndent => width * 0.005;

  static double get newsImageHeight => height * 0.18;

  static double get newsImageWidth => width * 0.34;

  static double get newsSmallBlockWidth => width * 0.3;

  static double get newsSmallBlockHeight => height * 0.15;

  static double get newsListImageSize => width * 0.3;

  static double get menuBlockHeight => 90;

  static double get voucherSize => 110;

  static double get qrCodeHeight => height * 0.3;

  static double get menuItemSize => height * 0.1;

  static double get menuItemPhotoSize => height * 0.45;

  static double get newsItemPhotoSize => height * 0.35;

  static double get newsListTextSize => width - newsListImageSize - 48;

  static double get qrCodeMargin => (width - scanQRCodeSize) / 2;

  static double get currentBonusSize => height * 0.2;
}
