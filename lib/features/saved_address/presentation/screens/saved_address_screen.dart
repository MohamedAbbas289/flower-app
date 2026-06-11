import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/saved_address/presentation/view_model/cubit/saved_address_view_model.dart';
import 'package:flower_app/features/saved_address/presentation/view_model/states/saved_address_events.dart';
import 'package:flower_app/features/saved_address/presentation/view_model/states/saved_address_states.dart';
import 'package:flower_app/features/saved_address/presentation/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedAddressScreen extends StatelessWidget {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SavedAddressViewModel>()..doEvent(const LoadAddressesEvent()),
      child: const _SavedAddressView(),
    );
  }
}

class _SavedAddressView extends StatelessWidget {
  const _SavedAddressView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.savedAddress)),
      body: BlocConsumer<SavedAddressViewModel, SavedAddressStates>(
        listenWhen: (previous, current) =>
            previous.deleteAddressState != current.deleteAddressState,
        listener: (context, state) {
          if (state.deleteAddressState.msg != null) {
            AppSnackBar.showError(context, state.deleteAddressState.msg!);
          }
          if (state.deleteAddressState.data != null) {
            AppSnackBar.showSuccess(context, AppStrings.addressDeletedSuccess);
          }
        },
        builder: (context, state) {
          final getState = state.getAddressesState;

          if (getState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (getState.msg != null) {
            return Center(
              child: Text(getState.msg!, style: TextStyles.bodyRegular14),
            );
          }

          final addresses = getState.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (addresses.isEmpty)
                  Center(
                    child: Text(
                      AppStrings.noAddresses,
                      style: TextStyles.bodyRegular14,
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return AddressCard(
                        address: address,
                        onDelete: () => _confirmDelete(context, address),
                        onEdit: () => Navigator.pushNamed(
                          context,
                          AppRoutesName.editAddress,
                          arguments: address,
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutesName.addAddress),
                    child: Text(AppStrings.addNewAddress),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AddressEntity address) {
    AppDialog.show(
      context: context,
      title: AppStrings.deleteAddress,
      description: AppStrings.deleteAddressConfirmation,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      onConfirm: () => context.read<SavedAddressViewModel>().doEvent(
        DeleteAddressEvent(address.id!),
      ),
    );
  }
}
