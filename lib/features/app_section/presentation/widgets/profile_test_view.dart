import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileTestView extends StatelessWidget {
  const ProfileTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pink,
      child: Center(
        child: Text(
          "Profile View",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
