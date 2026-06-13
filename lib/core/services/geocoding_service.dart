import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

class ReverseGeocodeResult {
  final String? street;
  final String? subLocality;
  final String? locality;
  final String? administrativeArea;
  final String formatted;

  const ReverseGeocodeResult({
    this.street,
    this.subLocality,
    this.locality,
    this.administrativeArea,
    required this.formatted,
  });
}

@lazySingleton
class GeocodingService {
  static const _timeout = Duration(seconds: 8);

  Future<ReverseGeocodeResult?> reverseGeocode(
    double lat,
    double lng, {
    String? languageCode,
  }) async {
    try {
      if (languageCode != null) {
        await setLocaleIdentifier(_localeIdentifierFor(languageCode));
      }

      final placemarks = await placemarkFromCoordinates(
        lat,
        lng,
      ).timeout(_timeout);
      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first;
      final parts = [
        placemark.subLocality,
        placemark.locality,
        placemark.administrativeArea,
      ].where((part) => part != null && part.trim().isNotEmpty).toList();

      return ReverseGeocodeResult(
        street: placemark.street,
        subLocality: placemark.subLocality,
        locality: placemark.locality,
        administrativeArea: placemark.administrativeArea,
        formatted: parts.isEmpty
            ? '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}'
            : parts.join(', '),
      );
    } catch (_) {
      return null;
    }
  }

  String _localeIdentifierFor(String languageCode) {
    return languageCode == 'ar' ? 'ar_EG' : 'en_US';
  }

  Future<LatLng?> forwardGeocode(String address) async {
    if (address.trim().isEmpty) return null;

    try {
      final locations = await locationFromAddress(
        address,
      ).timeout(_timeout);
      if (locations.isEmpty) return null;

      final location = locations.first;
      return LatLng(location.latitude, location.longitude);
    } catch (_) {
      return null;
    }
  }
}
