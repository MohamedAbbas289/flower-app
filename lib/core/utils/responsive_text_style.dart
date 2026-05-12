import 'package:flutter/material.dart';
import 'package:flower_app/core/utils/app_responsive.dart';

extension ResponsiveTextStyle on TextStyle {
  TextStyle responsive(
    Size size, {
    required double mobile,
    double? tablet,
  }) {
    return copyWith(
      fontSize: AppResponsive.responsiveFont(
        size,
        mobile: mobile,
        tablet: tablet,
      ),
    );
  }
}