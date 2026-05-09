import 'package:flower_app/features/login/domain/use_cases/validate_login_inputs_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValidateLoginInputsUseCase useCase;

  setUp(() {
    useCase = const ValidateLoginInputsUseCase();
  });

  group('ValidateLoginInputsUseCase', () {
    test('returns no errors for valid credentials', () {
      final result = useCase(email: 'user@example.com', password: 'secret');

      expect(result.isValid, isTrue);
      expect(result.emailError, isNull);
      expect(result.passwordError, isNull);
    });

    test('returns email error for empty email', () {
      final result = useCase(email: '', password: 'secret');

      expect(result.isValid, isFalse);
      expect(result.emailError, isNotNull);
    });

    test('returns email error for malformed email', () {
      final result = useCase(email: 'not-an-email', password: 'secret');

      expect(result.isValid, isFalse);
      expect(result.emailError, isNotNull);
    });

    test('returns password error for empty password', () {
      final result = useCase(email: 'user@example.com', password: '');

      expect(result.isValid, isFalse);
      expect(result.passwordError, isNotNull);
    });

    test('returns both errors when both fields are empty', () {
      final result = useCase(email: '', password: '');

      expect(result.isValid, isFalse);
      expect(result.emailError, isNotNull);
      expect(result.passwordError, isNotNull);
    });
  });
}
