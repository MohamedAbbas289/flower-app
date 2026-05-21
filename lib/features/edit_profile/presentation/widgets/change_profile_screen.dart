import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/endpoints.dart';
import '../../../../core/values/images_paths.dart';
import '../../domain/entities/edit_user_entity.dart';

class ChangeProfileScreen extends StatelessWidget {
  const ChangeProfileScreen({super.key, this.user});
  final EditUserEntity? user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: Stack(
        children: [
          Container(
            width: 81,
            height: 81,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            clipBehavior: Clip.antiAlias,
            child: user?.photo != null &&
                user!.photo!.isNotEmpty
                ? Image.network(
              '${Endpoints.imageBaseUrl}${user!.photo}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  Assets.defaultProfileImage,
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.asset(
              Assets.defaultProfileImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.lightPink,
              ),
              child: Icon(Icons.camera_alt_outlined,),
            ),
          )
        ], ),
    );
  }
}
