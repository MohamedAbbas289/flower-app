import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/models/user_model.dart';
import 'package:test/test.dart';

void main() {
  group('AuthResponseMapper', () {
    test('should map AuthResponse to AuthResponseEntity correctly', () {
      final userModel = User(
        id: '1',
        firstName: 'AbdElRahman',
        lastName: 'Shalaan',
        email: 'abdelrahman@gmail.com',
        phone: '01000000000',
        gender: 'male',
      );
      final authResponse = AuthResponse(
        message: 'Success',
        user: userModel,
        token: 'token_123',
      );

      final result = authResponse.toEntity();

      expect(result.message, 'Success');
      expect(result.token, 'token_123');
      expect(result.user, isNotNull);
      expect(result.user?.id, '1');
      expect(result.user?.firstName, 'AbdElRahman');
      expect(result.user?.lastName, 'Shalaan');
      expect(result.user?.email, 'abdelrahman@gmail.com');
      expect(result.user?.phone, '01000000000');
      expect(result.user?.gender, 'male');
      expect(result.user.runtimeType.toString().contains('UserEntity'), true);
    });

    test('should handle null values correctly', () {
      final authResponse = AuthResponse(message: null, user: null, token: null);

      final result = authResponse.toEntity();

      expect(result.message, isNull);
      expect(result.token, isNull);
      expect(result.user, isNull);
    });
  });
}
