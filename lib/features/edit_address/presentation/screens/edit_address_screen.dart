import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/address_form_fields.dart';
import 'package:flower_app/core/reusable_widgets/address_geocoding_sync_mixin.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/add_address/domain/entities/location_entity.dart';
import 'package:flower_app/core/reusable_widgets/location_dropdown_field.dart';
import 'package:flower_app/features/edit_address/presentation/view_model/cubit/edit_address_view_model.dart';
import 'package:flower_app/features/edit_address/presentation/view_model/states/edit_address_event.dart';
import 'package:flower_app/features/edit_address/presentation/view_model/states/edit_address_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressEntity address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen>
    with AddressGeocodingSyncMixin<EditAddressScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  late final TextEditingController addressController;
  late final TextEditingController phoneController;
  late final TextEditingController recipientNameController;

  @override
  List<LocationEntity> governorates = [];
  @override
  List<LocationEntity> cities = [];
  @override
  String? selectedGovernorateId;
  @override
  String? selectedCityId;
  @override
  late LatLng selectedPosition;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.address.street);
    phoneController = TextEditingController(text: widget.address.phone);
    recipientNameController = TextEditingController(
      text: widget.address.username,
    );

    selectedPosition = LatLng(
      double.tryParse(widget.address.lat ?? '') ?? 30.08525452318584,
      double.tryParse(widget.address.long ?? '') ?? 31.282610287469513,
    );
    _initUserLocation();
    initGeocodingSync();
  }

  @override
  void onGeocodingSyncUpdate({
    LatLng? position,
    String? governorateId,
    String? cityId,
    String? streetText,
    bool areaNotAvailable = false,
  }) {
    setState(() {
      if (position != null) selectedPosition = position;
      if (governorateId != null) selectedGovernorateId = governorateId;
      if (cityId != null) selectedCityId = cityId;
      if (streetText != null) addressController.text = streetText;

      final available = filteredCities;
      if (!available.any((city) => city.id == selectedCityId)) {
        selectedCityId = available.isEmpty ? null : available.first.id;
      }
    });

    if (areaNotAvailable) {
      AppSnackBar.showError(context, AppStrings.areaNotAvailable);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (governorates.isEmpty) {
      _loadLocations();
    }
  }

  Future<void> _initUserLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          return;
        }
      }
    } catch (_) {}
  }

  Future<void> _loadLocations() async {
    final languageCode = Localizations.localeOf(context).languageCode;

    final loadedGovernorates = await AddressLocationJsonParser.loadGovernorates(
      languageCode,
    );
    if (!mounted) return;
    final loadedCities = await AddressLocationJsonParser.loadCities(
      languageCode,
    );

    setState(() {
      governorates = loadedGovernorates;
      cities = loadedCities;

      final matchedCity = cities
          .where((c) => c.name == widget.address.city)
          .firstOrNull;

      if (matchedCity != null) {
        selectedCityId = matchedCity.id;
        selectedGovernorateId = matchedCity.governorateId;
      } else {
        selectedGovernorateId = governorates.isEmpty
            ? null
            : governorates.first.id;
        final available = filteredCities;
        selectedCityId = available.isEmpty ? null : available.first.id;
      }
    });
  }

  List<LocationEntity> get filteredCities =>
      cities.where((c) => c.governorateId == selectedGovernorateId).toList();

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
    phoneController.dispose();
    recipientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditAddressViewModel>(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.editAddress)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<EditAddressViewModel, EditAddressStates>(
            listenWhen: (previous, current) =>
                previous.editAddressState != current.editAddressState,
            listener: (context, state) {
              if (state.editAddressState.msg != null) {
                AppSnackBar.showError(context, state.editAddressState.msg!);
              }
              if (state.editAddressState.data != null) {
                AppSnackBar.showSuccess(
                  context,
                  AppStrings.addressUpdatedSuccess,
                );
                Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    children: [
                      AddressFormFields(
                        addressController: addressController,
                        phoneController: phoneController,
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
                        onGovernorateChanged: (value) {
                          addressController.clear();
                          setState(() {
                            selectedGovernorateId = value;
                            final available = filteredCities;
                            selectedCityId = available.isEmpty
                                ? null
                                : available.first.id;
                          });
                          onLocationDropdownChanged();
                        },
                        onCityChanged: (value) {
                          addressController.clear();
                          setState(() => selectedCityId = value);
                          onLocationDropdownChanged();
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.editAddressState.isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context
                                        .read<EditAddressViewModel>()
                                        .doEvent(
                                          SubmitEditAddressEvent(
                                            id: widget.address.id!,
                                            request: AddAddressDto(
                                              street: addressController.text
                                                  .trim(),
                                              phone: phoneController.text
                                                  .trim(),
                                              city: selectedCityName,
                                              lat: selectedPosition.latitude
                                                  .toString(),
                                              long: selectedPosition.longitude
                                                  .toString(),
                                              username: recipientNameController
                                                  .text
                                                  .trim(),
                                            ),
                                          ),
                                        );
                                  }
                                },
                          child: state.editAddressState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(AppStrings.updateAddress),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
