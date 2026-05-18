import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';

class RowSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final IconData iconBack;


  const RowSection({
    super.key,
    required this.title,
     this.icon,
    this.onTap,
    this.iconBack = Icons.arrow_forward_ios
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 20,),
        const SizedBox(width: 12),
        Text(title,
          style: TextStyles.bodyRegular13,
        ),
        const Spacer(),
        InkWell(onTap: onTap, child: Icon(iconBack,)),
      ],
    );
  }
}
