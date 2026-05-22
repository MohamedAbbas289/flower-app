import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';

class RowSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final IconData? iconBack;
  final String? name;

  const RowSection({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.name,
    this.iconBack,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(title, style: TextStyles.bodyRegular13),
          const Spacer(),
          if (iconBack != null) Icon(iconBack, size: 18),
          const SizedBox(width: 12),
          if (name != null) Text(name!, style: TextStyles.bodyRegular11),
        ],
      ),
    );
  }
}

