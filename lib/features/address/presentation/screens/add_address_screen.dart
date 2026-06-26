import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/address_geocoding_sync_mixin.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/reusable_widgets/location_dropdown_field.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_view_model.dart';
import 'package:flower_app/features/address/presentation/widgets/add_address_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen>
    with AddressGeocodingSyncMixin<AddAddressScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();

  @override
  List<LocationEntity> governorates = [];
  @override
  List<LocationEntity> cities = [];
  @override
  String? selectedGovernorateId;
  @override
  String? selectedCityId;
  @override
  LatLng selectedPosition = const LatLng(30.08525452318584, 31.282610287469513);

  bool _isLoaded = false;
  bool _hasRunAutofill = false;

  @override
  void initState() {
    super.initState();
    initGeocodingSync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      _loadLocations();
    }
  }

  Future<void> _loadLocations() async {
    final languageCode = Localizations.localeOf(context).languageCode;

    final loadedGovernorates = await AddressLocationJsonParser.loadGovernorates(
      languageCode,
    );

    final loadedCities = await AddressLocationJsonParser.loadCities(
      languageCode,
    );

    if (!mounted) return;

    setState(() {
      governorates = loadedGovernorates;
      cities = loadedCities;

      final initialCities = filteredCities;
      selectedCityId = initialCities.isEmpty ? null : initialCities.first.id;
    });

    if (!_hasRunAutofill) {
      _hasRunAutofill = true;
      runReverseGeocodeAutofill();
    }
  }

  @override
  void onGeocodingSyncUpdate({
    LatLng? position,
    String? governorateId,
    String? cityId,
    String? streetText,
    bool areaNotAvailable = false,
  }) {
    final nextGovernorateId = governorateId ?? selectedGovernorateId;
    final available = cities
        .where((city) => city.governorateId == nextGovernorateId)
        .toList();
    final nextCityId = cityId ?? selectedCityId;
    final resolvedCityId = available.any((city) => city.id == nextCityId)
        ? nextCityId
        : (available.isEmpty ? null : available.first.id);

    setState(() {
      if (position != null) selectedPosition = position;
      selectedGovernorateId = nextGovernorateId;
      selectedCityId = resolvedCityId;
      if (streetText != null) addressController.text = streetText;
    });

    if (areaNotAvailable) {
      AppSnackBar.showError(context, AppStrings.areaNotAvailable);
    }
  }

  List<LocationEntity> get filteredCities {
    return cities.where((city) {
      return city.governorateId == selectedGovernorateId;
    }).toList();
  }

  String? get selectedCityName {
    for (final city in cities) {
      if (city.id == selectedCityId) return city.name;
    }
    return null;
  }

  @override
  void dispose() {
    disposeGeocodingSync();
    addressController.dispose();
    phoneNumberController.dispose();
    recipientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddAddressViewModel>(),
      child: Builder(
        builder: (innerContext) => AddAddressFormView(
          formKey: formKey,
          addressController: addressController,
          phoneController: phoneNumberController,
          recipientNameController: recipientNameController,
          governorates: governorates,
          filteredCities: filteredCities,
          selectedGovernorateId: selectedGovernorateId,
          selectedCityId: selectedCityId,
          selectedPosition: selectedPosition,
          onLocationSelected: (position) {
            selectedPosition = position;
            onMapPositionChanged(position);
          },
          onGovernorateChanged: (governorateId) {
            addressController.clear();
            setState(() {
              selectedGovernorateId = governorateId;
              final citiesForGovernorate = filteredCities;
              if (!citiesForGovernorate.any(
                (city) => city.id == selectedCityId,
              )) {
                selectedCityId = citiesForGovernorate.isEmpty
                    ? null
                    : citiesForGovernorate.first.id;
              }
            });
            onLocationDropdownChanged();
          },
          onCityChanged: (cityId) {
            addressController.clear();
            setState(() {
              selectedCityId = cityId;
            });
            onLocationDropdownChanged();
          },
          onSubmit: () {
            if (formKey.currentState!.validate()) {
              innerContext.read<AddAddressViewModel>().doEvent(
                AddAddressDataEvent(
                  AddAddressRequestModel(
                    street: addressController.text.trim(),
                    phone: phoneNumberController.text.trim(),
                    city: selectedCityName,
                    lat: selectedPosition.latitude.toString(),
                    long: selectedPosition.longitude.toString(),
                    username: recipientNameController.text.trim(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
