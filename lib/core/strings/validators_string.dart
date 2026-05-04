 class ValidatorsString {
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email';

  static const String passwordRequired = 'Enter your password';
  static const String passwordWeak =
      'Password must contain:\n'
      '• At least 8 characters\n'
      '• One uppercase letter\n'
      '• One number';

  static const String confirmPasswordRequired = 'Confirm your password';
  static const String passwordDontMatch = 'Passwords do not match';

  static const String usernameRequired = 'Enter your username';
  static const String usernameShort = 'Username must be at least 3 characters';

  static const String otpEmpty = 'Code cannot be empty';
  static const String otpLength = 'Please enter the full 4-digit code';
  static const String otpInvalid = 'Invalid code format';

  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  static const String passwordPattern = r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$';

  static const String otpPattern = r'^[0-9]+$';
}