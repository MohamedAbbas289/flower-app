import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_refresh_indicator.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/features/get_profile_screen/presentation/view_model/cubit/get_profile_view_model.dart';
import 'package:flower_app/features/get_profile_screen/presentation/view_model/states/get_profile_events.dart';
import 'package:flower_app/features/get_profile_screen/presentation/view_model/states/get_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/values/images_paths.dart';
import '../widgets/profile_details.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<GetProfileViewModel>()..doEvent(const LoadProfileDataEvent()),
      child: const _ProfileViewContent(),
    );
  }
}

class _ProfileViewContent extends StatefulWidget {
  const _ProfileViewContent();

  @override
  State<_ProfileViewContent> createState() => _ProfileViewContentState();
}

class _ProfileViewContentState extends State<_ProfileViewContent> {
  Future<void> _onRefresh() async {
    final vm = context.read<GetProfileViewModel>();
    vm.doEvent(const RefreshProfileEvent());
    await vm.stream.firstWhere((s) => !s.getProfileState.isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                height: 50,
                width: 100,
                child: SvgPicture.asset(
                  Assets.assetsImagesFlowerIcon,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_sharp, size: 30),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyles.appBarTextStyle.copyWith(
                            color: AppColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        body: AppRefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocConsumer<GetProfileViewModel, GetProfileState>(
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
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                        profileState.msg!,
                        textAlign: TextAlign.center,
                        style: TextStyles.bodyRegular18,
                      ),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ProfileDetails(user: profileState.data),
              );
            },
          ),
        ),
      ),
    );
  }
}
