import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavIcon extends StatelessWidget {
  const BottomNavIcon({
    super.key,
    required this.assetName,
    required this.isSelected,
  });
  final String assetName;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.pink : AppColors.gray,
        BlendMode.srcIn,
      ),
    );
  }
}
