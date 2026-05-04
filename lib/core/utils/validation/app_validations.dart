import 'package:flower_app/core/utils/validation/app_regex.dart';
import 'package:flower_app/core/values/app_strings.dart';

abstract class AppValidations {
  static String? validateFirstName(String firstName) {
    if (!AppRegex.isNotEmpty(firstName)) {
      return AppStrings.firstNameRequired;
    }

    if (!AppRegex.isValidName(firstName)) {
      return AppStrings.nameInvalid;
    }

    if (firstName.trim().length < 2) {
      return AppStrings.nameTooShort;
    }

    if (firstName.trim().length > 20) {
      return AppStrings.nameTooLong;
    }

    return null;
  }

  static String? validateLastName(String lastName) {
    if (!AppRegex.isNotEmpty(lastName)) {
      return AppStrings.lastNameRequired;
    }

    if (!AppRegex.isValidName(lastName)) {
      return AppStrings.nameInvalid;
    }

    if (lastName.trim().length < 2) {
      return AppStrings.nameTooShort;
    }

    if (lastName.trim().length > 20) {
      return AppStrings.nameTooLong;
    }

    return null;
  }

  static String? validateEmail(String email) {
    if (!AppRegex.isNotEmpty(email)) {
      return AppStrings.emailRequired;
    }

    if (!AppRegex.isValidEmail(email)) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  static String? validatePhone(String phone) {
    if (!AppRegex.isNotEmpty(phone)) {
      return AppStrings.phoneRequired;
    }

    if (!AppRegex.isValidPhoneNumber(phone)) {
      return AppStrings.phoneInvalid;
    }

    return null;
  }

  static String? validatePassword(String password) {
    if (!AppRegex.isNotEmpty(password)) {
      return AppStrings.passwordRequired;
    }

    if (!AppRegex.isValidPassword(password)) {
      return AppStrings.passwordWeak;
    }

    return null;
  }

  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (!AppRegex.isNotEmpty(confirmPassword)) {
      return AppStrings.confirmPasswordRequired;
    }

    if (!AppRegex.isPasswordMatch(password, confirmPassword)) {
      return AppStrings.passwordDoNotMatch;
    }

    return null;
  }

  static String? validateOtp(String otp) {
    if (!AppRegex.isNotEmpty(otp)) {
      return AppStrings.otpEmpty;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      return AppStrings.otpInvalid;
    }

    if (otp.length != 4) {
      return AppStrings.otpLength;
    }

    return null;
  }
}
