import 'package:flower_app/core/reusable_widgets/address_form_fields.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/presentation/widgets/save_address_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressFormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
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
  final bool isSubmitting;
  final String submitLabel;
  final VoidCallback onSubmit;

  const AddressFormSection({
    super.key,
    required this.formKey,
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
    required this.isSubmitting,
    required this.submitLabel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
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
              onLocationSelected: onLocationSelected,
              onGovernorateChanged: onGovernorateChanged,
              onCityChanged: onCityChanged,
            ),
            SaveAddressButton(
              isLoading: isSubmitting,
              label: submitLabel,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
