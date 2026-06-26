import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_view_model.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_states.dart';
import 'package:flower_app/features/address/presentation/widgets/address_form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressFormView extends StatelessWidget {
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
  final VoidCallback onSubmit;

  const AddAddressFormView({
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
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.address)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AddAddressViewModel, AddAddressStates>(
          listenWhen: (previous, current) =>
              previous.addAddressState.msg != current.addAddressState.msg ||
              previous.addAddressState.data != current.addAddressState.data,
          listener: (context, state) {
            if (state.addAddressState.msg != null) {
              AppSnackBar.showError(context, state.addAddressState.msg!);
            }
            if (state.addAddressState.data != null) {
              AppSnackBar.showSuccess(context, AppStrings.saveAddress);
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            return AddressFormSection(
              formKey: formKey,
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
              isSubmitting: state.addAddressState.isLoading,
              submitLabel: AppStrings.saveAddress,
              onSubmit: onSubmit,
            );
          },
        ),
      ),
    );
  }
}
