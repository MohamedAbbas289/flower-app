import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A tappable, non-interactive search field that navigates to the search screen.
/// Used in both the home AppBar and the categories header.
class SearchNavigationBar extends StatelessWidget {
  const SearchNavigationBar({
    super.key,
    this.borderRadius = 12,
    this.height = 48,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 16.0,
  });

  final double borderRadius;
  final double height;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutesName.search),
      child: AbsorbPointer(
        child: SizedBox(
          height: height,
          child: TextField(
            decoration: InputDecoration(
              hintText: AppStrings.search,
              contentPadding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  Assets.assetsIconsSearch,
                  colorFilter: const ColorFilter.mode(
                    AppColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColors.placeHolder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColors.placeHolder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColors.pink),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
