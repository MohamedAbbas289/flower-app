import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static TextStyle appBarTextStyle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle labelTextFieldStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.gray,
  );

  static const TextStyle hintTextFieldStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.placeHolder,
    letterSpacing: 0.5,
  );

  static const TextStyle textFieldTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    letterSpacing: 0.5,
  );

  static TextStyle bodyRegularUnderLine13 = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.black,
  );

  static const TextStyle errorTextFieldStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  );

  static TextStyle errorText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.red,
  );

  static TextStyle buttonTextStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  static TextStyle bodyRegular13 = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static TextStyle bodyRegular14 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static TextStyle bodyRegular16 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
}
