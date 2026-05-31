import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/profile/presentation/view_model/cubit/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view_model/states/get_profile_events.dart';
import 'package:flower_app/features/profile/presentation/view_model/states/get_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/values/images_paths.dart';
import '../widgets/profile_details.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileViewModel>()..doEvent(const LoadProfileDataEvent()),
      child: const _ProfileViewContent(),
    );
  }
}

class _ProfileViewContent extends StatelessWidget {
  const _ProfileViewContent();

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                child: Image.asset(Assets.assetsImagesAppIcon, height: 15),
              ),
              const SizedBox(width: 4),
              Text(AppStrings.appName, style: TextStyles.appNameTextStyle),
              Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(Assets.assetsIconsNotification),
                  Positioned(
                    right: -2,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyles.bodyRegular11.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4),
            ],
          ),
        ),
      ),
      body: BlocConsumer<ProfileViewModel, GetProfileState>(
        listenWhen: (previous, current) =>
            previous.getProfileState.msg != current.getProfileState.msg &&
            current.getProfileState.msg != null,
        listener: (context, state) {
          AppSnackBar.showError(context, state.getProfileState.msg!);
        },
        builder: (context, state) {
          final profileState = state.getProfileState;

          if (profileState.isLoading && profileState.data == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            );
          }

          if (profileState.msg != null && profileState.data == null) {
            return Center(
              child: Text(
                profileState.msg!,
                textAlign: TextAlign.center,
                style: TextStyles.bodyRegular18,
              ),
            );
          }

          return ProfileDetails(authResponse: profileState.data);
        },
      ),
    );
  }
}
