import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/profile/presentation/widgets/row_section.dart';
import 'package:flower_app/features/profile/presentation/widgets/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/endpoints.dart';
import '../../../../core/values/images_paths.dart';
import '../view_model/cubit/get_profile_view_model.dart';
import '../view_model/states/get_profile_events.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key, required this.authResponse});
  final AuthResponseEntity? authResponse;

  @override
  Widget build(BuildContext context) {
    final userData = authResponse?.user;

    return RefreshIndicator(
      color: AppColors.pink,
      onRefresh: () async {
        context.read<GetProfileViewModel>().doEvent(
          const LoadProfileDataEvent(),
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 81,
              height: 81,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              clipBehavior: Clip.antiAlias,
              child: userData?.photo != null && userData!.photo!.isNotEmpty
                  ? Image.network(
                      userData.photo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          SvgPicture.asset(
                            Assets.assetsIconsPerson,
                            fit: BoxFit.cover,
                          ),
                    )
                  : SvgPicture.asset(
                      Assets.assetsIconsPerson,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (userData?.firstName ?? '').trim(),
                  style: TextStyles.bodyRegular18,
                ),
                IconButton(
                  onPressed: () async {
                    final updatedData = await Navigator.pushNamed(
                      context,
                      AppRoutesName.editProfile,
                      arguments: authResponse,
                    );
                    if (context.mounted && updatedData != null) {
                      context.read<GetProfileViewModel>().doEvent(
                        RetryLoadProfileDataEvent(),
                      );
                    }
                  },
                  icon: SvgPicture.asset(Assets.assetsImagesPen),
                ),
              ],
            ),
            Text(
              userData?.email ?? '',
              style: TextStyles.bodyRegular18.copyWith(color: AppColors.gray),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                RowSection.arrow(
                  title: AppStrings.myOrders,
                  iconPath: Assets.assetsIconsOrder,
                  onTap: () {},
                ),
                RowSection.arrow(
                  title: AppStrings.savedAddress,
                  iconPath: Assets.assetsIconsLocation,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.gray, thickness: 1, height: 1),
            RowSection.toggle(
              title: AppStrings.notification,
              value: true,
              onTap: () {},
              onToggle: (value) {},
            ),
            const Divider(color: AppColors.gray, thickness: 1, height: 1),
            const SizedBox(height: 16),
            Column(
              children: [
                RowSection.text(
                  title: AppStrings.language,
                  iconPath: Assets.assetsIconsTranslate,
                  text: AppStrings.english,
                  onTap: () {},
                ),
                RowSection.arrow(
                  title: AppStrings.aboutUs,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WebViewScreen(
                          title: AppStrings.aboutUs,
                          url: Endpoints.aboutFlowerApp,
                        ),
                      ),
                    );
                  },
                ),
                RowSection.arrow(
                  title: AppStrings.termsConditions,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WebViewScreen(
                          title: AppStrings.termsAndConditions,
                          url: Endpoints.termsFlowerApp,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(color: AppColors.gray, thickness: 1, height: 32),
            RowSection.arrow(
              title: AppStrings.logout,
              iconPath: Assets.assetsIconsLogout,
              onTap: () {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
