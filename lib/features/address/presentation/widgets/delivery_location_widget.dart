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
          onTap: () => _navigateToAddress(context, isNoAddress: isNoAddress),
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
                Expanded(
                  child: _buildContent(context, state.deliveryAddressState),
                ),
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

  Future<void> _navigateToAddress(
    BuildContext context, {
    required bool isNoAddress,
  }) async {
    await Navigator.pushNamed(
      context,
      isNoAddress ? AppRoutesName.addAddress : AppRoutesName.savedAddress,
    );
    if (context.mounted) {
      context.read<DeliveryAddressViewModel>().doEvent(
        const LoadDeliveryAddressEvent(),
      );
    }
  }

  Widget _buildContent(
    BuildContext context,
    BaseState<DeliveryAddressDisplayState> state,
  ) {
    final textStyle = TextStyles.bodyRegular12.copyWith(
      fontWeight: FontWeight.w600,
    );

    final display = state.data;
    if (state.isLoading || display == null) {
      return const _LoadingPlaceholder();
    }

    switch (display) {
      case NoAddressDisplay():
        return _NoAddressButton(
          style: textStyle.copyWith(color: AppColors.pink),
          onPressed: () => _navigateToAddress(context, isNoAddress: true),
        );
      case CurrentLocationDisplay(label: final label):
        return _DisplayText(text: label, style: textStyle);
      case SavedAddressDisplay(address: final address):
        final parts = [
          address.street,
          address.city,
        ].whereType<String>().where((part) => part.trim().isNotEmpty);
        final text = parts.join(', ');

        return _DisplayText(
          text: text.isEmpty ? AppStrings.defaultAddress : text,
          style: textStyle,
        );
    }
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.placeHolder,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _NoAddressButton extends StatelessWidget {
  final TextStyle style;
  final VoidCallback onPressed;

  const _NoAddressButton({required this.style, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        AppStrings.addAddress,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

class _DisplayText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _DisplayText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
  }
}
