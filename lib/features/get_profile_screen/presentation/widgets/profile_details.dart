import 'package:flower_app/features/get_profile_screen/presentation/widgets/row_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/endpoints.dart';
import '../../../../core/values/images_paths.dart';
import '../../domain/entities/user_entitiy.dart';
import '../view_model/cubit/get_profile_view_model.dart';
import '../view_model/states/get_profile_events.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key, required this.user});

  final GetUserEntity? user;

  static const String _defaultProfileImage =
      'https://flower.elevateegy.com/uploads/default-profile.png';

  String get _fullName {
    final firstName = user?.firstName?.trim() ?? '';
    final lastName = user?.lastName?.trim() ?? '';
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'User' : name;
  }

  String get _profileImage {
    final photo = user?.photo?.trim();
    if (photo == null || photo.isEmpty) return _defaultProfileImage;
    if (photo.startsWith('http')) return photo;
    return '${Endpoints.imageBaseUrl}$photo';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.pink,
      onRefresh: () async {
        context
            .read<GetProfileViewModel>()
            .doEvent(const RetryLoadProfileDataEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          spacing: 20,
          children: [
            ClipOval(
              child: Image.network(
                _profileImage,
                width: 81,
                height: 81,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    _defaultProfileImage,
                    width: 81,
                    height: 81,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_fullName, style: TextStyles.bodyRegular18),
                SvgPicture.asset(Assets.penIcon),
              ],
            ),
            Text(
              user?.email ?? '',
              style: TextStyles.bodyRegular18.copyWith(color: AppColors.gray),
            ),
            RowSection(
              title: 'My orders',
              icon: Icons.list_alt_rounded,
              onTap: () {},
            ),
            RowSection(
              title: 'Saved address',
              icon: Icons.location_on_outlined,
              onTap: () {},
            ),
            Container(width: double.infinity, height: 1, color: AppColors.gray),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Switch(value: true, onChanged: (value) {}),
                  Text('Notification', style: TextStyles.bodyRegular13),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            Container(width: double.infinity, height: 1, color: AppColors.gray),
            RowSection(title: 'About us', onTap: () {}),
            RowSection(title: 'Terms & conditions', onTap: () {}),

            RowSection(
              title: 'Logout',
              icon: Icons.logout,
              iconBack: Icons.logout,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}