import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/presentation/view_models/orders_view_model/orders_state.dart';
import 'package:flower_app/features/shopping/presentation/view_models/orders_view_model/orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersViewModel>(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatefulWidget {
  const _OrdersView();

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _OrdersAppBar(tabController: _tabController),
      body: BlocConsumer<OrdersViewModel, OrdersState>(
        listener: (context, state) {
          if (state.ordersState.msg != null) {
            AppSnackBar.showError(context, state.ordersState.msg!);
          }
        },
        builder: (context, state) {
          if (state.ordersState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            );
          }

          final viewModel = context.read<OrdersViewModel>();

          return TabBarView(
            controller: _tabController,
            children: [
              _OrdersList(
                orders: viewModel.activeOrders,
                emptyMessage: AppStrings.noActiveOrders,
                isActive: true,
              ),
              _OrdersList(
                orders: viewModel.completedOrders,
                emptyMessage: AppStrings.noCompletedOrders,
                isActive: false,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _OrdersAppBar({required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Padding(
        padding: const EdgeInsetsDirectional.only(start: 4),
        child: Text(AppStrings.myOrders),
      ),
      bottom: TabBar(
        controller: tabController,
        indicatorColor: AppColors.pink,
        indicatorWeight: 2,
        labelColor: AppColors.pink,
        unselectedLabelColor: AppColors.gray,
        labelStyle: TextStyles.bodyRegular14.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyles.bodyRegular14,
        tabs: [
          Tab(text: AppStrings.activeOrders),
          Tab(text: AppStrings.completedOrders),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.emptyMessage,
    required this.isActive,
  });

  final List<OrderEntity> orders;
  final String emptyMessage;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(child: Text(emptyMessage, style: TextStyles.bodyRegular16));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return isActive
            ? _ActiveOrderCard(order: order)
            : _CompletedOrderCard(order: order);
      },
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final firstItem = order.orderItems?.isNotEmpty == true
        ? order.orderItems!.first
        : null;

    return _OrderCard(
      imageUrl: firstItem?.product?.imgCover ?? '',
      title: firstItem?.product?.title ?? '',
      price: order.totalPrice?.toInt() ?? 0,
      subtitle: 'Order number ${order.orderNumber ?? ''}',
      buttonLabel: AppStrings.trackOrder,
      onButtonPressed: () {},
    );
  }
}

class _CompletedOrderCard extends StatelessWidget {
  const _CompletedOrderCard({required this.order});

  final OrderEntity order;

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = order.orderItems?.isNotEmpty == true
        ? order.orderItems!.first
        : null;

    return _OrderCard(
      imageUrl: firstItem?.product?.imgCover ?? '',
      title: firstItem?.product?.title ?? '',
      price: order.totalPrice?.toInt() ?? 0,
      subtitle: AppStrings.deliveredOnLabel(_formatDate(order.updatedAt)),
      buttonLabel: AppStrings.reorder,
      onButtonPressed: () {},
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.buttonLabel,
    required this.onButtonPressed,
  });

  final String imageUrl;
  final String title;
  final int price;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 110, child: _OrderImage(imageUrl: imageUrl)),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.bodyRegular14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.priceText(price),
                      style: TextStyles.bodyRegular14.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyles.bodyRegular12.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          textStyle: TextStyles.bodyRegular12.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(buttonLabel),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderImage extends StatelessWidget {
  const _OrderImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(
        color: AppColors.placeHolder.withAlpha(77),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.pink,
          ),
        ),
      ),
      errorWidget: (_, _, _) => Container(
        color: AppColors.placeHolder.withAlpha(51),
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.gray,
        ),
      ),
    );
  }
}
