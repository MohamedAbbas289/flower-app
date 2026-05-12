import 'dart:ui';

class AppResponsive {
  const AppResponsive._();

  static bool isMobileLandscape(Size size) =>
      size.width > size.height && size.height < 500;

  static bool isSmallMobile(Size size) => size.width < 400;

  static int gridCrossAxisCount(Size size) {
    if (isMobileLandscape(size)) return 5;

    return switch (size.width) {
      < 600 => 2,
      < 900 => 3,
      _ => 5,
    };
  }

  static int gridSkeletonCount(Size size) {
    if (isMobileLandscape(size)) return 5;

    return switch (size.width) {
      < 600 => 6,
      < 900 => 12,
      _ => 10,
    };
  }

  static double gridChildAspectRatio(Size size) {
    if (isMobileLandscape(size)) return 0.78;

    return switch (size.width) {
      < 600 => 0.76,
      _ => 0.82,
    };
  }

  static double responsiveFont(
    Size size, {
    required double mobile,
    double? smallMobile,
    double? tablet,
    double? landscape,
  }) {
    if (isMobileLandscape(size)) {
      return landscape ?? mobile;
    }

    if (isSmallMobile(size)) {
      return smallMobile ?? mobile;
    }

    if (size.width >= 600) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}
