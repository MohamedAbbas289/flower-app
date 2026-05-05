import 'package:flower_app/core/utils/validation/app_regex.dart';
import 'package:injectable/injectable.dart';

class LoginValidationResult {
  final String? emailError;
  final String? passwordError;

  const LoginValidationResult({this.emailError, this.passwordError});

  bool get isValid => emailError == null && passwordError == null;
}

/// Validates login form inputs for the email and password fields.
///
/// Errors are only meant to be surfaced on login-button tap, not on text
/// change — the ViewModel is responsible for triggering this at the right time.
///
/// Error messages follow the spec:
/// - Email   → "This Email is not valid"
/// - Password → "Invalid password"
@injectable
class ValidateLoginInputsUseCase {
  const ValidateLoginInputsUseCase();

  LoginValidationResult call({
    required String email,
    required String password,
  }) {
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);

    return LoginValidationResult(
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  String? _validateEmail(String email) {
    if (!AppRegex.isNotEmpty(email) || !AppRegex.isValidEmail(email)) {
      return 'This Email is not valid';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (!AppRegex.isNotEmpty(password)) {
      return 'Invalid password';
    }
    return null;
  }
}
