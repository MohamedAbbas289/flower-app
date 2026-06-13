import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/auth/logout/presentation/screens/logout_dialog.dart';
import 'package:flower_app/features/profile/presentation/widgets/language_bottom_sheet.dart';
import 'package:flower_app/features/profile/presentation/widgets/row_section.dart';
import 'package:flower_app/features/profile/presentation/widgets/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/endpoints.dart';
import '../../../../core/values/images_paths.dart';
import '../view_model/cubit/profile_view_model.dart';
import '../view_model/states/get_profile_events.dart';
import '../view_model/states/get_profile_state.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key, required this.authResponse});
  final AuthResponseEntity? authResponse;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.pink,
      onRefresh: () async {
        context.read<ProfileViewModel>().doEvent(const LoadProfileDataEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoutDialog(
              onSuccess: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutesName.login,
                (route) => false,
              ),
              onError: (msg) => AppSnackBar.showError(context, msg),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ProfileViewModel, GetProfileState>(
              buildWhen: (previous, current) =>
                  previous.getProfileState != current.getProfileState,
              builder: (context, state) {
                final userData = state.getProfileState.isLoading
                    ? authResponse?.user
                    : state.getProfileState.data?.user ?? authResponse?.user;

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 81,
                          height: 81,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: userData?.photo != null &&
                                  userData!.photo!.isNotEmpty
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
                        if (state.getProfileState.isLoading)
                          const CircularProgressIndicator(
                            color: AppColors.pink,
                          ),
                      ],
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
                              arguments:
                                  state.getProfileState.data ?? authResponse,
                            );
                            if (context.mounted && updatedData != null) {
                              context.read<ProfileViewModel>().doEvent(
                                const RetryLoadProfileDataEvent(),
                              );
                            }
                          },
                          icon: SvgPicture.asset(Assets.assetsImagesPen),
                        ),
                      ],
                    ),
                    Text(
                      userData?.email ?? '',
                      style: TextStyles.bodyRegular18.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                RowSection.arrow(
                  title: AppStrings.myOrders,
                  iconPath: Assets.assetsIconsOrder,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutesName.myOrders);
                  },
                ),
                RowSection.arrow(
                  title: AppStrings.savedAddress,
                  iconPath: Assets.assetsIconsLocation,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutesName.savedAddress);

                  },
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
                  text: context.locale.languageCode == 'ar'
                      ? AppStrings.arabic
                      : AppStrings.english,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const LanguageBottomSheet(),
                    );
                  },
                ),
                RowSection.arrow(
                  title: AppStrings.aboutUs,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WebViewScreen(
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
                        builder: (_) => WebViewScreen(
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
              onTap: () => LogoutDialog.show(context: context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}