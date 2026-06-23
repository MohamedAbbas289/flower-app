import 'package:flower_app/core/utils/validation/app_regex.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/core/reusable_widgets/address_map_picker.dart';
import 'package:flower_app/core/reusable_widgets/location_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressFormFields extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController recipientNameController;
  final List<LocationEntity> governorates;
  final List<LocationEntity> filteredCities;
  final String? selectedGovernorateId;
  final String? selectedCityId;
  final LatLng selectedPosition;
  final ValueChanged<LatLng> onLocationSelected;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;

  const AddressFormFields({
    super.key,
    required this.addressController,
    required this.phoneController,
    required this.recipientNameController,
    required this.governorates,
    required this.filteredCities,
    required this.selectedGovernorateId,
    required this.selectedCityId,
    required this.selectedPosition,
    required this.onLocationSelected,
    required this.onGovernorateChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      spacing: 16,
      children: [
        SizedBox(
          height: size.height * .25,
          child: AddressMapPicker(
            initialPosition: selectedPosition,
            onLocationSelected: onLocationSelected,
          ),
        ),
        TextFormField(
          controller: addressController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.enterTheAddress;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: AppStrings.address,
            hintText: AppStrings.enterTheAddress,
          ),
        ),
        TextFormField(
          controller: phoneController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.enterThePhoneNumber;
            }
            if (!AppRegex.isValidPhoneNumber(value)) {
              return AppStrings.phoneInvalid;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: AppStrings.phoneLabel,
            hintText: AppStrings.enterThePhoneNumber,
          ),
          keyboardType: TextInputType.phone,
        ),
        TextFormField(
          controller: recipientNameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.enterTheRecipientName;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: AppStrings.recipientName,
            hintText: AppStrings.enterTheRecipientName,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: LocationDropdownField(
                label: AppStrings.city,
                value: selectedGovernorateId,
                items: governorates,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.cityRequired;
                  }
                  return null;
                },
                onChanged: onGovernorateChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LocationDropdownField(
                label: AppStrings.area,
                value: selectedCityId,
                items: filteredCities,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.areaRequired;
                  }
                  return null;
                },
                onChanged: onCityChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}