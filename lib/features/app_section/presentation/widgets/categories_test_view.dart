import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoriesTestView extends StatelessWidget {
  const CategoriesTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: AppColors.green,
      child: Center(
        child: Text(
          "Categories View",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}