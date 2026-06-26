import 'package:flower_app/features/home/domain/entities/products_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('availableQuantity', () {
    test('is always null', () {
      const entity = ProductEntity(
        id: 'product_1',
        name: 'Rose',
        imageUrl: 'image.png',
        price: 100,
        originalPrice: 120,
        discountPercent: 10,
      );

      expect(entity.availableQuantity, null);
    });
  });
}
