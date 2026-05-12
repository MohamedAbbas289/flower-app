import 'dart:ui';

class AppResponsive {
  const AppResponsive._();

  static bool isSmallMobile(Size size) => size.width < 400;

  static int gridCrossAxisCount(Size size) {
    return switch (size.width) {
      < 600 => 2,
      < 900 => 3,
      _ => 5,
    };
  }

  static int gridSkeletonCount(Size size) {
    return switch (size.width) {
      < 600 => 6,
      < 900 => 12,
      _ => 10,
    };
  }

  static double gridChildAspectRatio(Size size) {
    return switch (size.width) {
      < 600 => 0.76,
      _ => 0.82,
    };
  }

  static int cardCacheWidth(Size size, double devicePixelRatio) {
    final cardWidth = size.width / gridCrossAxisCount(size);
    return (cardWidth * devicePixelRatio).toInt();
  }

  static double responsiveFont(
    Size size, {
    required double mobile,
    double? smallMobile,
    double? tablet,
    double? landscape,
  }) {

    if (isSmallMobile(size)) {
      return smallMobile ?? mobile;
    }

    if (size.width >= 600) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}
