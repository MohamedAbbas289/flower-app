import 'package:flower_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('availableQuantity', () {
    test('returns quantity truncated to int', () {
      const entity = ProductEntity(quantity: 3.0);

      expect(entity.availableQuantity, 3);
    });

    test('returns null when quantity is null', () {
      const entity = ProductEntity(quantity: null);

      expect(entity.availableQuantity, null);
    });
  });
}
