import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_view_model.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_states.dart';
import 'package:flower_app/features/address/presentation/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedAddressScreen extends StatelessWidget {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SavedAddressViewModel>()..doEvent(const LoadAddressesEvent()),
      child: const _SavedAddressView(),
    );
  }
}

class _SavedAddressView extends StatelessWidget {
  const _SavedAddressView();

  void _onListener(BuildContext context, SavedAddressStates state) {
    if (state.deleteAddressState.msg != null) {
      AppSnackBar.showError(context, state.deleteAddressState.msg!);
    }
    if (state.deleteAddressState.data != null) {
      AppSnackBar.showSuccess(context, AppStrings.addressDeletedSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.savedAddress)),
      body: BlocConsumer<SavedAddressViewModel, SavedAddressStates>(
        listenWhen: (prev, curr) => prev.deleteAddressState != curr.deleteAddressState,
        listener: _onListener,
        builder: (context, state) {
          final getState = state.getAddressesState;
          if (getState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (getState.msg != null) {
            return Center(child: Text(getState.msg!, style: TextStyles.bodyRegular14));
          }
          final addresses = getState.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(child: _AddressListBody(addresses: addresses)),
                const SizedBox(height: 16),
                const _AddAddressButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddressListBody extends StatelessWidget {
  const _AddressListBody({required this.addresses});

  final List<AddressEntity> addresses;

  void _confirmDelete(BuildContext context, AddressEntity address) {
    final id = address.id;
    if (id == null) {
      AppSnackBar.showError(context, AppStrings.somethingWentWrong);
      return;
    }
    AppDialog.show(
      context: context,
      title: AppStrings.deleteAddress,
      description: AppStrings.deleteAddressConfirmation,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      onConfirm: () => context.read<SavedAddressViewModel>().doEvent(DeleteAddressEvent(id)),
    );
  }

  Future<void> _onEdit(BuildContext context, AddressEntity address) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutesName.editAddress,
      arguments: address,
    );
    if (result == true && context.mounted) {
      context.read<SavedAddressViewModel>().doEvent(const LoadAddressesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return Center(
        child: Text(AppStrings.noAddresses, style: TextStyles.bodyRegular14),
      );
    }
    return ListView.separated(
      itemCount: addresses.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return AddressCard(
          address: address,
          onDelete: () => _confirmDelete(context, address),
          onEdit: () => _onEdit(context, address),
        );
      },
    );
  }
}

class _AddAddressButton extends StatelessWidget {
  const _AddAddressButton();

  Future<void> _onAdd(BuildContext context) async {
    final result = await Navigator.pushNamed(context, AppRoutesName.addAddress);
    if (result == true && context.mounted) {
      context.read<SavedAddressViewModel>().doEvent(const LoadAddressesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onAdd(context),
        child: Text(AppStrings.addNewAddress),
      ),
    );
  }
}
