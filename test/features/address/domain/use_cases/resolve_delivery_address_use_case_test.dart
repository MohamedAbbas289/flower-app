import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/delivery_location/domain/entities/delivery_address_display.dart';
import 'package:flower_app/features/delivery_location/domain/use_cases/resolve_delivery_address_use_case.dart';
import 'package:flower_app/features/saved_address/domain/use_cases/saved_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'resolve_delivery_address_use_case_test.mocks.dart';

@GenerateMocks([
  LocationService,
  GeocodingService,
  GetAddressesUseCase,
  LastAddressFirestoreService,
])
void main() {
  late MockLocationService locationService;
  late MockGeocodingService geocodingService;
  late MockGetAddressesUseCase getAddressesUseCase;
  late MockLastAddressFirestoreService lastAddressFirestoreService;

  const tAddress1 = AddressEntity(
    id: '1',
    street: 'Street 1',
    city: 'City 1',
    lat: '30.0',
    long: '31.0',
  );
  const tAddress2 = AddressEntity(
    id: '2',
    street: 'Street 2',
    city: 'City 2',
    lat: '30.1',
    long: '31.1',
  );

  final tPosition = Position(
    latitude: 30.05,
    longitude: 31.05,
    timestamp: DateTime(2026, 1, 1),
    accuracy: 1,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>(data: const []),
    );
  });

  setUp(() {
    locationService = MockLocationService();
    geocodingService = MockGeocodingService();
    getAddressesUseCase = MockGetAddressesUseCase();
    lastAddressFirestoreService = MockLastAddressFirestoreService();
  });

  ResolveDeliveryAddressUseCase buildUseCase() => ResolveDeliveryAddressUseCase(
    locationService,
    geocodingService,
    getAddressesUseCase,
    lastAddressFirestoreService,
  );

  void stubAddresses(List<AddressEntity> addresses) {
    when(
      getAddressesUseCase(),
    ).thenAnswer((_) async => SuccessBaseResponse(data: addresses));
  }

  group('permission denied', () {
    test('returns NoAddressDisplay when there are no saved addresses', () async {
      when(locationService.resolvePermission()).thenAnswer((_) async => false);
      stubAddresses(const []);

      final result = await buildUseCase()();

      expect(result, const NoAddressDisplay());
      verifyNever(locationService.getCurrentPosition());
    });

    test('returns the firestore last address when available', () async {
      when(locationService.resolvePermission()).thenAnswer((_) async => false);
      stubAddresses(const [tAddress1, tAddress2]);
      when(
        lastAddressFirestoreService.getLastAddress(),
      ).thenAnswer((_) async => tAddress1);

      final result = await buildUseCase()();

      expect(result, const SavedAddressDisplay(tAddress1, isNearest: false));
    });

    test(
      'falls back to the last saved address when firestore has nothing cached',
      () async {
        when(
          locationService.resolvePermission(),
        ).thenAnswer((_) async => false);
        stubAddresses(const [tAddress1, tAddress2]);
        when(
          lastAddressFirestoreService.getLastAddress(),
        ).thenAnswer((_) async => null);

        final result = await buildUseCase()();

        expect(result, const SavedAddressDisplay(tAddress2, isNearest: false));
      },
    );

    test(
      'treats an error response from GetAddressesUseCase as no saved addresses',
      () async {
        when(
          locationService.resolvePermission(),
        ).thenAnswer((_) async => false);
        when(getAddressesUseCase()).thenAnswer(
          (_) async => ErrorBaseResponse<List<AddressEntity>>(
            exception: Exception('boom'),
          ),
        );

        final result = await buildUseCase()();

        expect(result, const NoAddressDisplay());
      },
    );
  });

  group('permission granted, no saved addresses', () {
    test('returns CurrentLocationDisplay with a reverse-geocoded label', () async {
      when(locationService.resolvePermission()).thenAnswer((_) async => true);
      stubAddresses(const []);
      when(
        locationService.getCurrentPosition(),
      ).thenAnswer((_) async => tPosition);
      when(
        geocodingService.reverseGeocode(
          tPosition.latitude,
          tPosition.longitude,
        ),
      ).thenAnswer(
        (_) async => const ReverseGeocodeResult(formatted: 'Some Area, City'),
      );

      final result = await buildUseCase()();

      expect(result, const CurrentLocationDisplay('Some Area, City'));
    });

    test('falls back to a lat/lng label when reverse geocoding fails', () async {
      when(locationService.resolvePermission()).thenAnswer((_) async => true);
      stubAddresses(const []);
      when(
        locationService.getCurrentPosition(),
      ).thenAnswer((_) async => tPosition);
      when(
        geocodingService.reverseGeocode(
          tPosition.latitude,
          tPosition.longitude,
        ),
      ).thenAnswer((_) async => null);

      final result = await buildUseCase()();

      expect(
        result,
        CurrentLocationDisplay(
          '${tPosition.latitude.toStringAsFixed(5)}, '
          '${tPosition.longitude.toStringAsFixed(5)}',
        ),
      );
    });

    test('returns NoAddressDisplay when the current position is unavailable', () async {
      when(locationService.resolvePermission()).thenAnswer((_) async => true);
      stubAddresses(const []);
      when(
        locationService.getCurrentPosition(),
      ).thenAnswer((_) async => null);

      final result = await buildUseCase()();

      expect(result, const NoAddressDisplay());
    });
  });

  group('permission granted, saved addresses exist', () {
    test('returns the nearest saved address when position is available', () async {
      when(locationService.resolvePermission()).thenAnswer((_) async => true);
      stubAddresses(const [tAddress1, tAddress2]);
      when(
        locationService.getCurrentPosition(),
      ).thenAnswer((_) async => tPosition);
      when(
        locationService.distanceInMeters(
          startLatitude: tPosition.latitude,
          startLongitude: tPosition.longitude,
          endLatitude: 30.0,
          endLongitude: 31.0,
        ),
      ).thenReturn(5000);
      when(
        locationService.distanceInMeters(
          startLatitude: tPosition.latitude,
          startLongitude: tPosition.longitude,
          endLatitude: 30.1,
          endLongitude: 31.1,
        ),
      ).thenReturn(100);

      final result = await buildUseCase()();

      expect(result, const SavedAddressDisplay(tAddress2, isNearest: true));
    });

    test(
      'falls back to the last saved address when no address has valid coordinates',
      () async {
        const tAddressNoCoords = AddressEntity(
          id: '3',
          street: 'Street 3',
          city: 'City 3',
        );
        when(
          locationService.resolvePermission(),
        ).thenAnswer((_) async => true);
        stubAddresses(const [tAddressNoCoords]);
        when(
          locationService.getCurrentPosition(),
        ).thenAnswer((_) async => tPosition);
        when(
          lastAddressFirestoreService.getLastAddress(),
        ).thenAnswer((_) async => null);

        final result = await buildUseCase()();

        expect(
          result,
          const SavedAddressDisplay(tAddressNoCoords, isNearest: false),
        );
      },
    );

    test(
      'falls back to the firestore last address when position is unavailable',
      () async {
        when(
          locationService.resolvePermission(),
        ).thenAnswer((_) async => true);
        stubAddresses(const [tAddress1, tAddress2]);
        when(
          locationService.getCurrentPosition(),
        ).thenAnswer((_) async => null);
        when(
          lastAddressFirestoreService.getLastAddress(),
        ).thenAnswer((_) async => tAddress1);

        final result = await buildUseCase()();

        expect(result, const SavedAddressDisplay(tAddress1, isNearest: false));
      },
    );
  });
}
