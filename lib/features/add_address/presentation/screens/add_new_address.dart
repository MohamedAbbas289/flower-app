import 'package:flower_app/core/reusable_widgets/address_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../config/di/di.dart';
import '../../../../core/reusable_widgets/app_snack_bar.dart';
import '../../../../core/values/app_strings.dart';
import '../../data/models/add_address_dto.dart';
import '../../domain/entities/location_entity.dart';
import '../view_model/cubit/add_address_cubit.dart';
import '../view_model/states/add_address_events.dart';
import '../view_model/states/add_address_states.dart';
import '../../../../core/reusable_widgets/location_dropdown_field.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({super.key});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();

  List<LocationEntity> governorates = [];
  List<LocationEntity> cities = [];
  String? selectedGovernorateId;
  String? selectedCityId;
  LatLng selectedPosition = const LatLng(30.08525452318584, 31.282610287469513);

  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    _initUserLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _isLoaded = true;
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

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        selectedPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (_) {}
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
    addressController.dispose();
    phoneNumberController.dispose();
    recipientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddAddressCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.address)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddAddressCubit, AddAddressStates>(
            listenWhen: (previous, current) =>
                previous.addAddressState.msg != current.addAddressState.msg ||
                previous.addAddressState.data != current.addAddressState.data,
            listener: (context, state) {
              if (state.addAddressState.msg != null) {
                AppSnackBar.showError(context, state.addAddressState.msg!);
              }
              if (state.addAddressState.data != null) {
                AppSnackBar.showSuccess(context, AppStrings.saveAddress);
              }
            },
            builder: (context, state) {
              final addAddressState = state.addAddressState;

              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    children: [
                      AddressFormFields(
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
                        },
                        onGovernorateChanged: (governorateId) {
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
                        },
                        onCityChanged: (cityId) {
                          setState(() {
                            selectedCityId = cityId;
                          });
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: addAddressState.isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AddAddressCubit>().doEvent(
                                      AddAddressDataEvent(
                                        AddAddressDto(
                                          street: addressController.text.trim(),
                                          phone: phoneNumberController.text
                                              .trim(),
                                          city: selectedCityName,
                                          lat: selectedPosition.latitude
                                              .toString(),
                                          long: selectedPosition.longitude
                                              .toString(),
                                          username: recipientNameController.text
                                              .trim(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: addAddressState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(AppStrings.saveAddress),
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
