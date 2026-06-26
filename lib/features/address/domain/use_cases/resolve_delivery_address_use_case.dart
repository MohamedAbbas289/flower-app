import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/display_states/delivery_address_display.dart';
import 'package:flower_app/features/address/domain/use_cases/saved_address_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResolveDeliveryAddressUseCase {
  final LocationService _locationService;
  final GeocodingService _geocodingService;
  final GetAddressesUseCase _getAddressesUseCase;
  final LastAddressFirestoreService _lastAddressFirestoreService;

  ResolveDeliveryAddressUseCase(
    this._locationService,
    this._geocodingService,
    this._getAddressesUseCase,
    this._lastAddressFirestoreService,
  );

  Future<DeliveryAddressDisplayState> execute() async {
    final hasPermission = await _locationService.resolvePermission();

    final response = await _getAddressesUseCase.execute();
    final addresses = switch (response) {
      SuccessBaseResponse(data: final data) => data,
      ErrorBaseResponse() => <AddressEntity>[],
    };

    if (!hasPermission) {
      return _resolveWithoutLocation(addresses);
    }

    final position = await _locationService.getCurrentPosition();

    if (addresses.isEmpty) {
      if (position == null) return const NoAddressDisplay();

      final result = await _geocodingService.reverseGeocode(
        position.latitude,
        position.longitude,
      );

      return CurrentLocationDisplay(
        result?.formatted ??
            '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
      );
    }

    if (position == null) {
      return _resolveWithoutLocation(addresses);
    }

    final nearest = _findNearestAddress(addresses, position);
    if (nearest == null) {
      return _resolveWithoutLocation(addresses);
    }

    return SavedAddressDisplay(nearest, isNearest: true);
  }

  AddressEntity? _findNearestAddress(
    List<AddressEntity> addresses,
    Position position,
  ) {
    AddressEntity? nearest;
    double? nearestDistance;

    for (final address in addresses) {
      final lat = double.tryParse(address.lat ?? '');
      final long = double.tryParse(address.long ?? '');
      if (lat == null || long == null) continue;

      final distance = _locationService.distanceInMeters(
        startLatitude: position.latitude,
        startLongitude: position.longitude,
        endLatitude: lat,
        endLongitude: long,
      );

      if (nearestDistance == null || distance < nearestDistance) {
        nearest = address;
        nearestDistance = distance;
      }
    }

    return nearest;
  }

  Future<DeliveryAddressDisplayState> _resolveWithoutLocation(
    List<AddressEntity> addresses,
  ) async {
    if (addresses.isEmpty) return const NoAddressDisplay();

    final lastAddress =
        await _lastAddressFirestoreService.getLastAddress() ?? addresses.last;

    return SavedAddressDisplay(lastAddress, isNearest: false);
  }
}
