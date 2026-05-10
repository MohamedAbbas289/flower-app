import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class BestSellerItem extends StatelessWidget {
  final String name;
  final ImageProvider image;
  final VoidCallback onTap;
  final String price;
  const BestSellerItem({
    required this.name,
    required this.image,
    required this.onTap,
    required this.price,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height:151 ,
          width:131 ,
          child: Image(image: image,
            fit: BoxFit.cover,
          ),
        ),
        Text(name,
          style: TextStyles.bodyRegular12.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        Text('$price EGP',
          style: TextStyles.bodyRegular14,
        ),


      ],
    );
  }
}
