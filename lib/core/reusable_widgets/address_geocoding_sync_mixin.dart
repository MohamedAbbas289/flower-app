import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/location_dropdown_field.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

mixin AddressGeocodingSyncMixin<T extends StatefulWidget> on State<T> {
  static const _debounceDuration = Duration(milliseconds: 800);

  static final RegExp _adminWordsPattern = RegExp(
    r'\b(محافظه|مدينه|مركز|قسم|حي|قريه)\b',
  );

  final GeocodingService _geocodingService = getIt<GeocodingService>();
  final LocationService _locationService = getIt<LocationService>();

  Timer? _debounceTimer;
  bool _isProgrammaticUpdate = false;

  List<LocationEntity>? _matchingGovernorates;
  List<LocationEntity>? _matchingCities;

  TextEditingController get addressController;
  List<LocationEntity> get governorates;
  List<LocationEntity> get cities;
  String? get selectedGovernorateId;
  String? get selectedCityId;
  LatLng get selectedPosition;

  void onGeocodingSyncUpdate({
    LatLng? position,
    String? governorateId,
    String? cityId,
    String? streetText,
    bool areaNotAvailable = false,
  });

  void initGeocodingSync() {
    addressController.addListener(_onAddressTextChanged);
  }

  void disposeGeocodingSync() {
    _debounceTimer?.cancel();
    addressController.removeListener(_onAddressTextChanged);
  }

  void onLocationDropdownChanged() {
    if (_isProgrammaticUpdate) return;
    _scheduleForwardGeocode();
  }

  Future<void> onMapPositionChanged(LatLng position) async {
    if (_isProgrammaticUpdate) return;
    await _reverseGeocodeAndApply(position, notifyAreaUnavailable: true);
  }

  void _onAddressTextChanged() {
    if (_isProgrammaticUpdate) return;
    _scheduleForwardGeocode();
  }

  void _scheduleForwardGeocode() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, _runForwardGeocode);
  }

  Future<void> _runForwardGeocode() async {
    final street = addressController.text.trim();
    final governorateName = _nameForId(governorates, selectedGovernorateId);
    final cityName = _nameForId(cities, selectedCityId);

    final query = [
      street,
      cityName,
      governorateName,
    ].where((part) => part != null && part.trim().isNotEmpty).join(', ');
    if (query.isEmpty) return;

    final result = await _geocodingService.forwardGeocode(query);
    if (!mounted || result == null) return;
    if (result == selectedPosition) return;

    onGeocodingSyncUpdate(position: result);
  }

  Future<void> runReverseGeocodeAutofill() async {
    final hasPermission = await _locationService.resolvePermission();
    if (kDebugMode) debugPrint('[GeocodingSync] hasPermission=$hasPermission');
    if (!hasPermission || !mounted) return;

    Position? position;
    try {
      position = await _locationService.getCurrentPosition();
    } on TimeoutException {
      return;
    }
    if (kDebugMode) {
      debugPrint(
        '[GeocodingSync] position=${position?.latitude}, ${position?.longitude}',
      );
    }
    if (position == null || !mounted) return;

    await _reverseGeocodeAndApply(
      LatLng(position.latitude, position.longitude),
    );
  }

  Future<void> _reverseGeocodeAndApply(
    LatLng position, {
    bool notifyAreaUnavailable = false,
  }) async {
    final result = await _geocodingService.reverseGeocode(
      position.latitude,
      position.longitude,
      languageCode: 'ar',
    );
    if (kDebugMode) {
      debugPrint('[GeocodingSync] reverseGeocode=${result?.formatted}');
    }
    if (!mounted) return;

    await _ensureMatchingDatasetsLoaded();
    if (!mounted) return;

    final matchedCity = _matchCity(result);
    final matchedGovernorateId =
        matchedCity?.governorateId ?? _matchGovernorate(result);
    if (kDebugMode) {
      debugPrint(
        '[GeocodingSync] matchedGovernorateId=$matchedGovernorateId, matchedCityId=${matchedCity?.id}',
      );
    }

    final street = result?.street?.trim();
    final streetText = (street != null && street.isNotEmpty)
        ? street
        : result?.formatted;

    _isProgrammaticUpdate = true;
    onGeocodingSyncUpdate(
      position: position,
      governorateId: matchedGovernorateId,
      cityId: matchedCity?.id,
      streetText: streetText,
      areaNotAvailable:
          notifyAreaUnavailable &&
          matchedCity == null &&
          matchedGovernorateId == null,
    );
    Future.microtask(() => _isProgrammaticUpdate = false);
  }

  Future<void> _ensureMatchingDatasetsLoaded() async {
    if (_matchingGovernorates != null && _matchingCities != null) return;

    final loadedGovernorates = await AddressLocationJsonParser.loadGovernorates(
      'ar',
    );
    final loadedCities = await AddressLocationJsonParser.loadCities('ar');
    if (!mounted) return;

    _matchingGovernorates = loadedGovernorates;
    _matchingCities = loadedCities;
  }

  LocationEntity? _matchCity(ReverseGeocodeResult? result) {
    if (result == null || _matchingCities == null) return null;
    return _matchLocation(_matchingCities!, [
      result.locality,
      result.subLocality,
    ]);
  }

  String? _matchGovernorate(ReverseGeocodeResult? result) {
    if (result == null || _matchingGovernorates == null) return null;
    return _matchLocation(_matchingGovernorates!, [
      result.administrativeArea,
    ])?.id;
  }

  static const Map<String, List<String>> _arabicAliases = {
    'السادس من أكتوبر': ['6 أكتوبر'],
    'العاشر من رمضان': ['10 رمضان'],
  };

  Iterable<String> _namesForItem(LocationEntity item) {
    final aliases = _arabicAliases[item.name] ?? const <String>[];
    return [item.name, ...aliases];
  }

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAllMapped(
          RegExp('[٠-٩]'),
          (match) => String.fromCharCode(
            match.group(0)!.codeUnitAt(0) - 0x0660 + 0x30,
          ),
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _stripAdminWords(String value) {
    return value
        .replaceAll(_adminWordsPattern, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  LocationEntity? _matchLocation(
    List<LocationEntity> items,
    List<String?> candidates,
  ) {
    final normalizedCandidates = candidates
        .where((candidate) => candidate != null && candidate.trim().isNotEmpty)
        .map((candidate) => _normalize(candidate!))
        .where((candidate) => candidate.isNotEmpty)
        .toList();
    if (normalizedCandidates.isEmpty) return null;

    final normalizedNames = items
        .expand(
          (item) => _namesForItem(item).map(
            (rawName) => (item: item, name: _normalize(rawName)),
          ),
        )
        .toList();

    for (final candidate in normalizedCandidates) {
      final candidateCompact = candidate.replaceAll(' ', '');
      final match = normalizedNames.firstWhereOrNull(
        (entry) =>
            entry.name == candidate ||
            entry.name.replaceAll(' ', '') == candidateCompact,
      );
      if (match != null) return match.item;
    }

    final strippedNames = normalizedNames
        .map((entry) => (item: entry.item, name: _stripAdminWords(entry.name)))
        .toList();
    final strippedCandidates = normalizedCandidates
        .map(_stripAdminWords)
        .where((candidate) => candidate.isNotEmpty)
        .toList();
    for (final candidate in strippedCandidates) {
      final candidateCompact = candidate.replaceAll(' ', '');
      final match = strippedNames.firstWhereOrNull(
        (entry) =>
            entry.name == candidate ||
            entry.name.replaceAll(' ', '') == candidateCompact,
      );
      if (match != null) return match.item;
    }

    for (final candidate in normalizedCandidates) {
      final match = normalizedNames.firstWhereOrNull(
        (entry) =>
            entry.name.isNotEmpty &&
            (entry.name.contains(candidate) || candidate.contains(entry.name)),
      );
      if (match != null) return match.item;
    }

    return null;
  }

  String? _nameForId(List<LocationEntity> items, String? id) {
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item.name;
    }
    return null;
  }
}
