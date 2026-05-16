import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/cubit/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/app_section/domain/entity/bottom_nav_item_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/bottom_nav_icon.dart';
import '../widgets/cart_test_view.dart';
import '../widgets/categories_test_view.dart';
import '../../../home_screen/presentation/screens/home_view.dart';
import 'package:flower_app/features/categories/presentation/screens/categories_screen.dart';
import '../widgets/profile_test_view.dart';

class AppSectionView extends StatefulWidget {
  const AppSectionView({super.key});

  @override
  State<AppSectionView> createState() => _AppSectionViewState();
}

class _AppSectionViewState extends State<AppSectionView> {
  int _currentTabIndex = 0;
  final List<Widget> _tabs = [
    BlocProvider(
      create: (context) => getIt<HomeViewModel>(),
      child: HomeScreen(),
    ),
    CategoriesTestView(),
    const CategoriesScreen(),
    CartTestView(),
    ProfileTestView(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  final List<BottomNavItemEntity> bottomNavItems = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentTabIndex],
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
    );
  }
}
