import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/address/domain/entities/delivery_address_display.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_view_model.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class DeliveryLocationWidget extends StatelessWidget {
  const DeliveryLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryAddressViewModel, DeliveryAddressState>(
      builder: (context, state) {
        final display = state.deliveryAddressState.data;
        final isNoAddress = display is NoAddressDisplay;

        return InkWell(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              isNoAddress
                  ? AppRoutesName.addAddress
                  : AppRoutesName.savedAddress,
            );
            if (context.mounted) {
              context.read<DeliveryAddressViewModel>().doEvent(
                const LoadDeliveryAddressEvent(),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.assetsIconsLocationOn,
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text(AppStrings.deliverTo, style: TextStyles.bodyRegular12),
                const SizedBox(width: 4),
                Expanded(child: _buildContent(state.deliveryAddressState)),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.pink,
                  size: 32,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BaseState<DeliveryAddressDisplay> state) {
    final textStyle = TextStyles.bodyRegular12.copyWith(
      fontWeight: FontWeight.w600,
    );

    final display = state.data;
    if (state.isLoading || display == null) {
      return Container(
        height: 10,
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.placeHolder,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    switch (display) {
      case NoAddressDisplay():
        return Text(
          AppStrings.addAddress,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle.copyWith(color: AppColors.pink),
        );
      case CurrentLocationDisplay(label: final label):
        return Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        );
      case SavedAddressDisplay(address: final address):
        final parts = [
          address.street,
          address.city,
        ].whereType<String>().where((part) => part.trim().isNotEmpty);
        final text = parts.join(', ');

        return Text(
          text.isEmpty ? AppStrings.defaultAddress : text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        );
    }
  }
}
