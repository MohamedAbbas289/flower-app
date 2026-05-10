import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';

class OccasionItem extends StatelessWidget {
  final String name;
  final ImageProvider image;
  final VoidCallback onTap;
  const OccasionItem({
    required this.name,
    required this.image,
    required this.onTap,
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
          style: TextStyles.bodyRegular14,
        ),

      ],
    );
  }
}
