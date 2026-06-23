import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/checkout/presentation/view_model/cubit/checkout_view_model.dart';
import 'package:flower_app/features/checkout/presentation/view_model/states/checkout_events.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressSelectionSection extends StatelessWidget {
  final BaseState<List<AddressEntity>> addressesState;
  final AddressEntity? selectedAddress;

  const AddressSelectionSection({
    super.key,
    required this.addressesState,
    required this.selectedAddress,
  });

  Future<void> _onEdit(BuildContext context, AddressEntity address) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutesName.editAddress,
      arguments: address,
    );
    if (result == true && context.mounted) {
      context.read<CheckoutViewModel>().doEvent(
        const LoadCheckoutDataEvent(),
      );
    }
  }

  Future<void> _onAddNew(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutesName.addAddress,
    );
    if (result == true && context.mounted) {
      context.read<CheckoutViewModel>().doEvent(
        const LoadCheckoutDataEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresses = addressesState.data ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.deliveryAddress,
          style: TextStyles.bodyRegular16.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (addressesState.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            ),
          )
        else
          RadioGroup<String?>(
            groupValue: selectedAddress?.id,
            onChanged: (id) {
              final address = addresses.where((a) => a.id == id).firstOrNull;
              if (address != null) {
                context.read<CheckoutViewModel>().doEvent(
                  SelectAddressEvent(address),
                );
              }
            },
            child: Column(
              children: [
                for (final address in addresses)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _AddressTile(
                      address: address,
                      isSelected: address.id == selectedAddress?.id,
                      onSelect: () => context.read<CheckoutViewModel>().doEvent(
                        SelectAddressEvent(address),
                      ),
                      onEdit: () => _onEdit(context, address),
                    ),
                  ),
              ],
            ),
          ),
        TextButton.icon(
          onPressed: () => _onAddNew(context),
          icon: SvgPicture.asset(
            Assets.assetsIconsAdd,
            colorFilter: const ColorFilter.mode(
              AppColors.pink,
              BlendMode.srcIn,
            ),
          ),
          label: Text(
            AppStrings.addNew,
            style: TextStyles.bodyRegular14.copyWith(
              color: AppColors.pink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;

  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.onSelect,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.pink : AppColors.lightPink,
          ),
        ),
        child: Row(
          children: [
            Radio<String?>(value: address.id, activeColor: AppColors.pink),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.city ?? '',
                    style: TextStyles.bodyRegular14.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    address.street ?? '',
                    style: TextStyles.bodyRegular13.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: SvgPicture.asset(Assets.assetsIconsEidtPen),
            ),
          ],
        ),
      ),
    );
  }
}
