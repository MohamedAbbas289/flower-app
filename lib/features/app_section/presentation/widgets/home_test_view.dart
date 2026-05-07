import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeTestView extends StatelessWidget {
  const HomeTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.red,
      child: Center(
        child: Text(
          "Home View",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}