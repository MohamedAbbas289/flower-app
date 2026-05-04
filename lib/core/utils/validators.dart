import '../strings/validators_string.dart';

class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidatorsString.emailRequired;
    }

    final emailRegex = RegExp(ValidatorsString.emailPattern);

    if (!emailRegex.hasMatch(value)) {
      return ValidatorsString.emailInvalid;
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidatorsString.passwordRequired;
    }

    final passwordRegex = RegExp(ValidatorsString.passwordPattern);

    if (!passwordRegex.hasMatch(value)) {
      return ValidatorsString.passwordWeak;
    }

    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return ValidatorsString.confirmPasswordRequired;
    }

    if (value != password) {
      return ValidatorsString.passwordDontMatch;
    }

    return null;
  }

  static String? userNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidatorsString.usernameRequired;
    }

    if (value.length < 3) {
      return ValidatorsString.usernameShort;
    }

    return null;
  }

  static String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ValidatorsString.otpEmpty;
    }

    if (value.length < 4) {
      return ValidatorsString.otpLength;
    }

    if (!RegExp(ValidatorsString.otpPattern).hasMatch(value)) {
      return ValidatorsString.otpInvalid;
    }

    return null;
  }
}