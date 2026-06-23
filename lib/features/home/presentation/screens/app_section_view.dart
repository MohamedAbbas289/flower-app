import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/shopping/presentation/screens/cart_view.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_bloc.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_event.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_view_model.dart';
import 'package:flower_app/features/home/presentation/view_models/home_view_model/home_view_model.dart';
import 'package:flower_app/features/profile/presentation/screens/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/home/domain/entities/bottom_nav_item_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/bottom_nav_icon.dart';
import 'home_view.dart';
import 'package:flower_app/features/home/presentation/screens/categories_screen.dart';

class AppSectionView extends StatefulWidget {
  const AppSectionView({super.key});

  @override
  State<AppSectionView> createState() => _AppSectionViewState();
}

class _AppSectionViewState extends State<AppSectionView> {
  int _currentTabIndex = 0;
  String? _initialCategoryId;

  @override
  void initState() {
    super.initState();
    getIt<CartBloc>().add(const LoadCartEvent());
  }

  void _navigateToCategories({String? categoryId}) {
    setState(() {
      _currentTabIndex = 1;
      _initialCategoryId = categoryId;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
      if (index != 1) _initialCategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    final bottomNavItems = [
      BottomNavItemEntity(
        assetName: Assets.assetsIconsHome,
        label: AppStrings.home,
      ),
      BottomNavItemEntity(
        assetName: Assets.assetsIconsCategories,
        label: AppStrings.categories,
      ),
      BottomNavItemEntity(
        assetName: Assets.assetsIconsShoppingCart,
        label: AppStrings.cart,
      ),
      BottomNavItemEntity(
        assetName: Assets.assetsIconsPerson,
        label: AppStrings.profileView,
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentTabIndex == 0) {
          SystemNavigator.pop();
          return;
        }
        setState(() {
          _currentTabIndex = 0;
          _initialCategoryId = null;
        });
      },
      child: BlocProvider.value(
        value: getIt<CartBloc>(),
        child: Scaffold(
          body: IndexedStack(
            index: _currentTabIndex,
            children: [
              MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => getIt<HomeViewModel>()),
                  BlocProvider(
                    create: (_) => getIt<DeliveryAddressViewModel>(),
                  ),
                ],
                child: HomeScreen(
                  onCategoryViewAll: () => _navigateToCategories(),
                  onCategoryTap: (id) => _navigateToCategories(categoryId: id),
                ),
              ),
              CategoriesScreen(
                key: ValueKey(_initialCategoryId),
                initialCategoryId: _initialCategoryId,
              ),
              CartView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentTabIndex,
            onTap: _onTabTapped,
            items: bottomNavItems.map((item) {
              final index = bottomNavItems.indexOf(item);
              return BottomNavigationBarItem(
                icon: BottomNavIcon(
                  isSelected: _currentTabIndex == index,
                  assetName: item.assetName,
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}