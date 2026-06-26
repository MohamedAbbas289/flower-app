import 'package:flower_app/features/home/domain/entities/best_seller_product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('availableQuantity', () {
    test('returns quantity when positive', () {
      const entity = BestSellerProductEntity(quantity: 5);

      expect(entity.availableQuantity, 5);
    });

    test('returns quantity when negative', () {
      const entity = BestSellerProductEntity(quantity: -1);

      expect(entity.availableQuantity, -1);
    });

    test('returns null when quantity is null', () {
      const entity = BestSellerProductEntity(quantity: null);

      expect(entity.availableQuantity, null);
    });
  });
}
