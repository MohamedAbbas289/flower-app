import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/app_section/domain/entity/bottom_nav_item_entity.dart';
import 'package:flower_app/features/categories/presentation/screens/categories_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_nav_icon.dart';
import '../widgets/cart_test_view.dart';
import '../widgets/home_test_view.dart';
import '../widgets/profile_test_view.dart';

class AppSectionView extends StatefulWidget {
  const AppSectionView({super.key});

  @override
  State<AppSectionView> createState() => _AppSectionViewState();
}

class _AppSectionViewState extends State<AppSectionView> {
  int _currentTabIndex = 0;

  // Using a static list means each screen is kept alive when switching tabs
  final List<Widget> _tabs = [
    HomeTestView(),
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
      label: AppStrings.homeView,
    ),
    BottomNavItemEntity(
      assetName: Assets.assetsIconsCategories,
      label: AppStrings.categoryView,
    ),
    BottomNavItemEntity(
      assetName: Assets.assetsIconsShoppingCart,
      label: AppStrings.cartView,
    ),
    BottomNavItemEntity(
      assetName: Assets.assetsIconsPerson,
      label: AppStrings.profileView,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("App Section")),
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
