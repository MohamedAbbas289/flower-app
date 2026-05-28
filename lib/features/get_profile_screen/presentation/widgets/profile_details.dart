import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/get_profile_screen/presentation/widgets/row_section.dart';
import 'package:flower_app/features/get_profile_screen/presentation/widgets/web_view_screen.dart';
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
      InkWell(
        onTap: (){
          Navigator.pushNamed(context, '/editProfile');
        },
        child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user?.firstName??'',
                      style: TextStyles.bodyRegular18),
                  SvgPicture.asset(Assets.penIcon),
                ],
              ),
      ),
            Text(
              user?.email ?? '',
              style: TextStyles.bodyRegular18.copyWith(color: AppColors.gray),
            ),
            RowSection(
              title: AppStrings.myOrders,
              icon: Icons.list_alt_rounded,
              iconBack: Icons.arrow_forward_ios,


              onTap: () {},
            ),
            RowSection(
              title: AppStrings.savedAddress,
              icon: Icons.location_on_outlined,
              iconBack: Icons.arrow_forward_ios,
              onTap: () {
                Navigator.pushNamed(context, '/addresses');
              },
            ),
            Container(width: double.infinity, height: 1, color: AppColors.gray),
            Row(
                children: [
                  Switch(
                      value: true, onChanged: (value) {}),
                  Text(AppStrings.notification,
                      style: TextStyles.bodyRegular13),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            Container(width: double.infinity, height: 1, color: AppColors.gray),
            RowSection(
              icon: Icons.language,
                title:AppStrings.language,
                name: AppStrings.english,

                onTap: () {}),

            RowSection(
                title: AppStrings.aboutUs,
                iconBack: Icons.arrow_forward_ios,
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

                }),
            RowSection(
                title: AppStrings.termsConditions,
                iconBack: Icons.arrow_forward_ios,
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
                }),
            Container(width: double.infinity, height: 1, color: AppColors.gray),
            RowSection(
              title: AppStrings.logout,
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