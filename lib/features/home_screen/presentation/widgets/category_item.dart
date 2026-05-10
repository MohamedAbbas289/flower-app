import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData image;
  final VoidCallback onTap;
   const CategoryItem({
     required this.name,
     required this.image,
     required this.onTap,
     super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68,
            height:64 ,
            decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(20)

            ),
            child: Icon(image,
              color: AppColors.pink,
            ),
          ),
          Text(name,
            style: TextStyles.bodyRegular14,)
        ],
      ),
    );
  }
}
