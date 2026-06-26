import 'package:flutter_test/flutter_test.dart';

int _effectiveTotal(int totalPriceAfterDiscount, int totalPrice) {
  return totalPriceAfterDiscount > 0 && totalPriceAfterDiscount < totalPrice
      ? totalPriceAfterDiscount
      : totalPrice;
}

bool _showsDiscountRow(int totalPriceAfterDiscount, int totalPrice) {
  return totalPriceAfterDiscount > 0 && totalPriceAfterDiscount < totalPrice;
}

void main() {
  group('effectiveTotal', () {
    test('uses discounted total when it is positive and lower than total', () {
      expect(_effectiveTotal(90, 120), 90);
      expect(_showsDiscountRow(90, 120), true);
    });

    test('uses total when discounted total is zero', () {
      expect(_effectiveTotal(0, 120), 120);
      expect(_showsDiscountRow(0, 120), false);
    });

    test('uses total when discounted total equals total', () {
      expect(_effectiveTotal(120, 120), 120);
      expect(_showsDiscountRow(120, 120), false);
    });

    test('uses total when discounted total is greater than total', () {
      expect(_effectiveTotal(150, 120), 120);
      expect(_showsDiscountRow(150, 120), false);
    });
  });
}
