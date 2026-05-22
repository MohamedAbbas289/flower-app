import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';

class RowSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final IconData ?iconBack;
  final String? name;

  const RowSection({
    super.key,
    required this.title,
     this.icon,
    this.onTap,
    this.name,
    this.iconBack
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
        if (iconBack != null)
        InkWell(onTap: onTap,
            child: Icon(Icons.arrow_forward_ios,)),
        const SizedBox(width: 12),
        if (name != null)
          InkWell(
            onTap: (){

            },
            child: Text(name!,
              style: TextStyles.bodyRegular11,
            ),
          ),
      ],
    );
  }
}
