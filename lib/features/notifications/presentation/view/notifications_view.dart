import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_events.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flower_app/features/notifications/presentation/widgets/notifications_list_widget.dart';
import 'package:flower_app/features/notifications/presentation/widgets/notifications_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _NotificationsAppBar(),
      body: BlocProvider(
        create: (_) => getIt<NotificationsViewModel>(),
        child: const _NotificationsViewBody(),
      ),
    );
  }
}

class _NotificationsViewBody extends StatefulWidget {
  const _NotificationsViewBody();

  @override
  State<_NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<_NotificationsViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsViewModel>().doEvent(GetNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsViewModel, NotificationsState>(
      listener: NotificationsListener.onStateChange,
      builder: (context, state) {
        if (state.notificationsState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.pink),
          );
        }

        if (state.notificationsState.data != null) {
          return NotificationsListWidget(data: state.notificationsState.data!);
        }

        return Center(
          child: Text(
            state.notificationsState.msg ?? AppStrings.noNotificationsFound,
          ),
        );
      },
    );
  }
}

class _NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _NotificationsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Transform.flip(
          flipX: Directionality.of(context) == TextDirection.rtl,
          child: SvgPicture.asset(Assets.assetsIconsArrowBack),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(AppStrings.notifications),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
