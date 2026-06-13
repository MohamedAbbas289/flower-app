import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.myOrders)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.assetsIconsOrder,
              height: 80,
              colorFilter: const ColorFilter.mode(
                AppColors.gray,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16),
            Text(AppStrings.noOrdersYet, style: TextStyles.bodyRegular16),
          ],
        ),
      ),
    );
  }
}
