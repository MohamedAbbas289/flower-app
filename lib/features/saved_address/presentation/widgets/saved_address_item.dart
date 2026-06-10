import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SavedAddressItem extends StatelessWidget {
  const SavedAddressItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(Icons.location_on_outlined, ),
              Text('Cairo',
                style: TextStyles.bodyRegular16.copyWith(
                  fontWeight: FontWeight.w500
                )),
              Spacer(),
              InkWell(
                onTap: (){},
                child: Icon(Icons.delete_forever_outlined,
                color: AppColors.red,
                ),
              ),
              InkWell(
                onTap: (){},
                child: Icon(Icons.edit_outlined,
                color: AppColors.gray,),
              )

            ]
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('2XVP+XC ',
                style: TextStyles.bodyRegular13.copyWith(
                  color: AppColors.gray
                ),
              ),
              Text('Sheikh Zayed ',
                style: TextStyles.bodyRegular13.copyWith(
                  color: AppColors.gray
                ),
              ),

            ],
          ),
        ],
      ),


    );
  }
}
