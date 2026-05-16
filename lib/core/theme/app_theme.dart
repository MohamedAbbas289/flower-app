import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      primary: AppColors.pink,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      circularTrackColor: AppColors.lightPink,
      linearTrackColor: AppColors.pink,
      color: AppColors.lightPink,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyles.appBarTextStyle,
      titleSpacing: 0,
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      iconTheme: IconThemeData(color: AppColors.black, size: 24),
      leadingWidth: 40,
    ),
    textTheme: TextTheme(bodyMedium: TextStyles.bodyRegular14),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconConstraints: const BoxConstraints(minHeight: 24, maxHeight: 24),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return TextStyles.labelTextFieldStyle.copyWith(color: AppColors.red);
        }
        if (states.contains(WidgetState.focused)) {
          return TextStyles.labelTextFieldStyle.copyWith(
            color: AppColors.black,
          );
        }
        return TextStyles.labelTextFieldStyle;
      }),
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyles.labelTextFieldStyle,
      errorStyle: TextStyles.errorTextFieldStyle,
      hintStyle: TextStyles.hintTextFieldStyle,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.gray, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.gray, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.pink),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: AppColors.pink),
          ),
        ),
        textStyle: WidgetStateProperty.all(TextStyles.buttonTextStyle),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.white),
        foregroundColor: WidgetStateProperty.all(AppColors.gray),
        overlayColor: WidgetStateProperty.all(AppColors.lightPink),
        side: WidgetStateProperty.all(BorderSide(color: AppColors.gray)),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        ),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 48)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: AppColors.gray),
          ),
        ),
        textStyle: WidgetStateProperty.all(TextStyles.buttonTextStyle),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightPink,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: AppColors.gray),
      unselectedIconTheme: IconThemeData(color: AppColors.gray),
      selectedLabelStyle: TextStyle(color: AppColors.pink),
      unselectedLabelStyle: TextStyle(color: AppColors.gray),
    ),
  );
}
