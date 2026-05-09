import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CartTestView extends StatelessWidget {
  const CartTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gray,
      child: Center(
        child: Text(
          "Cart View",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
