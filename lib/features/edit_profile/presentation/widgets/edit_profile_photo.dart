import 'dart:io';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfilePhoto extends StatelessWidget {
  final String? networkPhoto;
  final File? pickedImage;
  final VoidCallback onTap;

  const EditProfilePhoto({
    super.key,
    this.networkPhoto,
    this.pickedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 81,
            height: 81,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            clipBehavior: Clip.antiAlias,
            child: _buildImage(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.pink,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (pickedImage != null) {
      return Image.file(pickedImage!, fit: BoxFit.cover);
    }
    if (networkPhoto != null && networkPhoto!.isNotEmpty) {
      return Image.network(
        networkPhoto!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            SvgPicture.asset(Assets.assetsIconsPerson, fit: BoxFit.cover),
      );
    }
    return SvgPicture.asset(Assets.assetsIconsPerson, fit: BoxFit.cover);
  }
}
