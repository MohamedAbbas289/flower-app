import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/endpoints.dart';

class OccasionItem extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onTap;
  const OccasionItem({
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
          SizedBox(
            height: 151,
            width: 131,
            child: Image.network(
              '${Endpoints.imageBaseUrl}$image',
              fit: BoxFit.contain,
            )

          ),
          Text(
            name,
            style: TextStyles.bodyRegular14,
          ),
        ],
      ),
    );
  }
}
