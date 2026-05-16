abstract class AppStrings {
  // general
  static const String appName = 'Flowery';
  static const String terms = '''
Welcome to Flowery 🌸

1. By creating an account, you agree to use the app for personal shopping only.
2. All flower products are subject to availability.
3. Prices may change without prior notice.
4. Delivery times may vary depending on location.
5. Refunds are applicable only in case of damaged or incorrect orders.
6. Misuse of the platform may result in account suspension.

Thank you for choosing Flowery 💐
''';
  static const String close = 'Close';
  static const String search = 'Search';

  // titles
  static const String loginTitle = 'Login';
  static const String signupTitle = 'Sign up';
  // labels
  static const String genderLabel = 'Gender';
  static const String maleLabel = 'Male';
  static const String femaleLabel = 'Female';
  // text fileds labels
  static const String firstNameLabel = 'First name';
  static const String lastNameLabel = 'Last name';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String confirmPasswordLabel = 'Confirm password';
  static const String phoneLabel = 'Phone number';

  // text fields hints
  static const String firstNameHint = 'Enter first name';
  static const String lastNameHint = 'Enter last name';
  static const String emailHint = 'Enter your email';
  static const String passwordHint = 'Enter password';
  static const String confirmPasswordHint = 'Confirm password';
  static const String phoneHint = 'Enter phone number';
  // texts on body
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String creatingAccount =
      'Creating an account, you agree to our ';
  static const String termsAndConditions = 'Terms&Conditions';

  // validation messages
  static const String requiredField = 'This field is required';
  static const String invalidInput = 'Please enter a valid value';
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String nameInvalid = 'Name can only contain letters and spaces';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String nameTooLong = 'Name must not exceed 20 characters';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid =
      'Please enter a valid email address (example@domain.com)';
  static const String passwordRequired = 'Password is required';
  static const String passwordWeak = 'Password is too weak.';
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordDoNotMatch =
      'Passwords do not match. Please make sure both passwords are identical';
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid =
      'Please enter a valid Egyptian phone number (e.g. 010xxxxxxxx)';
  static const String otpEmpty = 'Verification code is required';
  static const String otpLength = 'Verification code must be exactly 4 digits';
  static const String otpInvalid =
      'Verification code must contain numbers only';

  // auth error messages
  static const String tokenEmpty = 'Authentication token is missing';
  static const String tokenWriteFailed = 'Failed to save authentication token';
  static const String tokenReadFailed = 'Failed to read authentication token';
  static const String tokenDeleteFailed =
      'Failed to delete authentication token';
  static const String userIdEmpty = 'User ID is missing';
  static const String userIdReadFailed = 'Failed to read user ID';
  static const String userIdWriteFailed = 'Failed to save user ID';
  static const String userIdDeleteFailed = 'Failed to delete user ID';
  static const String rememberMeWriteFailed =
      'Failed to save remember me preference';
  static const String rememberMeReadFailed =
      'Failed to read remember me preference';
  static const String rememberMeDeleteFailed =
      'Failed to delete remember me preference';
  static const String clearStorageFailed = 'Failed to clear storage';

  // dio error messages
  static const String connectionTimeout =
      'Connection timed out. Please check your internet connection and try again';
  static const String requestTimeout =
      'Request timed out. Please check your internet connection and try again';
  static const String serverTookTooLongToRespond =
      'Server took too long to respond. Please try again later';
  static const String badCertificate =
      'Bad certificate. Please check your connection and try again';
  static const String noInternetConnection =
      'No internet connection. Please check your connection and try again';
  static const String cancel = 'Request canceled. Please try again later';
  static const String unexpectedErrorOccurred =
      'An unexpected error occurred. Please try again later';
  static const String serverErrorOccurred =
      'A server error occurred. Please try again later';
  static const String somethingWentWrong =
      'Something went wrong. Please try again later';
  static const String dataParsingError =
      'Data parsing error. Please try again later';
  // app error messages
  static const String routeNotFound = 'Route not found';

  // UI strings (feature forget pasword)
  static const String password = "Password";
  static const String forgetPassword = "Forget password";
  static const String pleaseEnterYourEmailAssociatedToYourAccount =
      "Please enter your email associated to\nyour account";
  static const String email = "Email";
  static const String enterYourEmail = "Enter Your Email";
  static const String confirm = "Confirm";
  static const String emailVerification = "Email verification";
  static const String didntReciveCode = "Didn't receive code? ";
  static const String resend = "Resend";
  static const String newPassword = "New password";
  static const String enterYourPassword = "Enter Your Password";
  static const String confirmPassword = "Confirm password";
  static const String hitTextForResetPassword =
      "Password must not be empty and must contain 6 characters with upper case letter and one number at least";
  static const String exampleEmail = "example@email.com";
  static const String invalidCode = "Invalid code";
  static const String resetPassword = "Reset password";
  //snackbar messages
  static const String accountCreatedSuccessfully =
      'Account created successfully! , please login to continue';

  // login screen
  static const String rememberMe = 'Remember me';
  static const String doYouForgetPassword = 'Forget password?';
  static const String loginButton = 'Login';
  static const String continueAsGuest = 'Continue as guest';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUp = 'Sign up';
  // bottom navigation labels
  static const String homeView = 'Home';
  static const String categoryView = 'Categories';
  static const String cartView = 'Cart';
  static const String profileView = 'Profile';

  static const String location = 'Deliver to 2XVP+XC - Sheikh Zayed ';
  static const String viewAll = 'View all';
  static const String bestSellers = 'Best Sellers';
  static const String occasion = 'Occasion';
}
