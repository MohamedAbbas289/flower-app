import 'package:flower_app/core/models/user_model.dart';
import 'package:test/test.dart';

void main() {
  group('UserMapper', () {
    test('should map User to UserEntity correctly', () {
      final userModel = User(
        id: '1',
        firstName: 'AbdElRahman',
        lastName: 'Shalaan',
        email: 'abdelrahman@gmail.com',
        phone: '01000000000',
        gender: 'male',
      );

      final result = userModel.toEntity();

      expect(result.id, '1');
      expect(result.firstName, 'AbdElRahman');
      expect(result.lastName, 'Shalaan');
      expect(result.email, 'abdelrahman@gmail.com');
      expect(result.phone, '01000000000');
      expect(result.gender, 'male');
    });

    test('should handle null values correctly', () {
      final userModel = User(
        id: null,
        firstName: null,
        lastName: null,
        email: null,
        phone: null,
        gender: null,
      );

      final result = userModel.toEntity();

      expect(result.id, null);
      expect(result.firstName, null);
      expect(result.lastName, null);
      expect(result.email, null);
      expect(result.phone, null);
      expect(result.gender, null);
    });

    test('should preserve list fields correctly', () {
      final wishlist = ['item1', 'item2'];
      final addresses = ['addr1', 'addr2'];
      final user = User(wishlist: wishlist, addresses: addresses);

      final result = user.toEntity();
      expect(result.wishlist, isNotNull);
      expect(result.wishlist, wishlist);
      expect(result.wishlist?.length, wishlist.length);
      expect(result.wishlist?.first, wishlist.first);
      expect(result.wishlist?.last, wishlist.last);

      expect(result.addresses, isNotNull);
      expect(result.addresses, addresses);
      expect(result.addresses?.length, addresses.length);
      expect(result.addresses?.first, addresses.first);
      expect(result.addresses?.last, addresses.last);
    });
  });
}
