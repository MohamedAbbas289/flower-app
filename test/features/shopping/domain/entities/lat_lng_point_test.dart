import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LatLngPoint', () {
    test('stores lat and lng correctly', () {
      const point = LatLngPoint(lat: 30.5, lng: 31.2);

      expect(point.lat, 30.5);
      expect(point.lng, 31.2);
    });

    test('const instances with the same values are identical', () {
      const a = LatLngPoint(lat: 1.0, lng: 2.0);
      const b = LatLngPoint(lat: 1.0, lng: 2.0);

      expect(identical(a, b), isTrue);
    });
  });
}
