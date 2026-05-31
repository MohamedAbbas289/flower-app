import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

enum RowSectionTrailing { arrow, text, toggle, none }

class RowSection extends StatelessWidget {
  final String title;
  final String? iconPath;
  final VoidCallback? onTap;
  final RowSectionTrailing trailing;
  final String? trailingText;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  const RowSection({
    super.key,
    required this.title,
    this.iconPath,
    this.onTap,
    this.trailing = RowSectionTrailing.none,
    this.trailingText,
    this.toggleValue,
    this.onToggleChanged,
  });

  const RowSection.arrow({
    super.key,
    required this.title,
    this.iconPath,
    this.onTap,
  }) : trailing = RowSectionTrailing.arrow,
       trailingText = null,
       toggleValue = null,
       onToggleChanged = null;

  const RowSection.text({
    super.key,
    required this.title,
    this.iconPath,
    this.onTap,
    required String text,
  }) : trailing = RowSectionTrailing.text,
       trailingText = text,
       toggleValue = null,
       onToggleChanged = null;

  const RowSection.toggle({
    super.key,
    required this.title,
    this.iconPath,
    this.onTap,
    required bool value,
    ValueChanged<bool>? onToggle,
  }) : trailing = RowSectionTrailing.toggle,
       trailingText = null,
       toggleValue = value,
       onToggleChanged = onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              if (trailing == RowSectionTrailing.toggle) ...[
                Transform.scale(
                  scale: 0.6,
                  child: Switch(
                    value: toggleValue ?? false,
                    onChanged: onToggleChanged,
                    activeThumbColor: AppColors.lightPink,
                    activeTrackColor: AppColors.pink,
                  ),
                ),
              ],
              if (iconPath != null) ...[
                SvgPicture.asset(
                  iconPath!,
                  height: 20,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(title, style: TextStyles.bodyRegular13),
              const Spacer(),
              _buildTrailing(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    switch (trailing) {
      case RowSectionTrailing.arrow:
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Transform.flip(
            flipX: Directionality.of(context) == TextDirection.rtl,
            child: SvgPicture.asset(Assets.assetsIconsGoButton),
          ),
        );
      case RowSectionTrailing.text:
        return Text(
          trailingText ?? '',
          style: TextStyles.bodyRegular11.copyWith(color: AppColors.pink),
        );
      case RowSectionTrailing.toggle:
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Transform.flip(
            flipX: Directionality.of(context) == TextDirection.rtl,
            child: SvgPicture.asset(Assets.assetsIconsGoButton),
          ),
        );
      case RowSectionTrailing.none:
        return const SizedBox.shrink();
    }
  }
}
