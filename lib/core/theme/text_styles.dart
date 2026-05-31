import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static final TextStyle appNameTextStyle = GoogleFonts.imFellEnglish(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: AppColors.pink,
  );
  static final TextStyle appBarTextStyle = GoogleFonts.inter(
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

  static final TextStyle bodyRegularUnderLine13 = GoogleFonts.inter(
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

  static final TextStyle errorText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.red,
  );

  static final TextStyle buttonTextStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  static final TextStyle bodyRegular12 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle bodyRegular13 = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle bodyRegular14 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle bodyRegular16 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle bodyRegular18 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );
  static final TextStyle bodyRegular11 = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.pink,
  );
}
