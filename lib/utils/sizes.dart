abstract class TextSize {
  static double extraSmall;
  static double small;
  static double large;
  static double extra;
}

abstract class ScreenSize {
  static double height;
  static double width;

  static double get sectionIndent => height * 0.04;

  static double get scanQRCodeIndent => height * 0.05;

  static double get scanQRCodeSize => height * 0.17;

  static double get bonusCardSize => height * 0.12;

  static double get scanQRCodeIconSize => scanQRCodeSize * 0.85;

  static double get elementIndentHeight => height * 0.03;

  static double get mainMarginTop => height * 0.07;

  static double get elementIndentWidth => width * 0.02;

  static double get labelIndent => width * 0.005;

  static double get newsImageHeight => height * 0.35 - 100;

  static double get newsImageWidth => width * 0.4;

  static double get newsSmallBlockWidth => width * 0.3;

  static double get newsSmallBlockHeight => height * 0.15;

  static double get newsListImageSize => width * 0.3;

  static double get menuBlockHeight => 90;

  static double get voucherSize => 110;

  static double get qrCodeHeight => height * 0.3;

  static double get menuItemSize => height * 0.1;

  static double get menuItemPhotoSize => height * 0.4;

  static double get newsItemPhotoSize => height * 0.35;

  static double get newsListTextSize => width - newsListImageSize - 48;

  static double get qrCodeMargin => (width - scanQRCodeSize) / 2;

  static double get currentBonusSize => height * 0.2;

  static double get mainTextWidth => width * 0.65;

  static double get maxTextWidth => width * 0.45;

  static double get logMaxTextWidth => width * 0.5;

  static double get aboutUsCurrentHeight => height * 0.5;

  static double get logoWidth => width * 0.55;

  static double get logoHeight => height * 0.3;

  static double get logHeight => 80;

  static double get aboutUsLogoSize => height * 0.3;

  static double get maxAboutSectionTextWidth => width * 0.70;

  static double get modalMaxTextWidth => width * 0.35;

  static double get homePageNewsHeight => height * 0.35;

  static double get homePageNewsWidth => width * 0.45;
}
