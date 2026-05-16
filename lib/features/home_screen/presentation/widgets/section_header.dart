import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyles.bodyRegular18),

        const Spacer(),

        InkWell(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyles.bodyRegular12.copyWith(
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}
