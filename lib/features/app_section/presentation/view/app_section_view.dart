import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_icon.dart';
import '../widgets/cart_test_view.dart';
import '../widgets/categories_test_view.dart';
import '../widgets/home_test_view.dart';
import '../widgets/profile_test_view.dart';

class AppSectionView extends StatefulWidget {
  const AppSectionView({super.key, required this.currentTab});
  final int currentTab;

  @override
  State<AppSectionView> createState() => _AppSectionViewState();
}

class _AppSectionViewState extends State<AppSectionView> {
  late int _currentTabIndex;
  final List<Widget> _tabs = [
    HomeTestView(),
    CategoriesTestView(),
    CartTestView(),
    ProfileTestView(),
  ];
  @override
  initState() {
    super.initState();
    _currentTabIndex = widget.currentTab;
  }

  void _onTabTapped(int index) {
    if (index == _currentTabIndex) return;
    final routes = [
      AppRoutesName.home,
      AppRoutesName.category,
      AppRoutesName.cart,
      AppRoutesName.profile,
    ];
    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("App Section")),
      body: IndexedStack(index: _currentTabIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: BottomNavIcon(
              isSelected: _currentTabIndex == 0,
              assetName: Assets.assetsIconsHome,
            ),
            label: AppStrings.homeView,
          ),
          BottomNavigationBarItem(
            icon: BottomNavIcon(
              isSelected: _currentTabIndex == 1,
              assetName: Assets.assetsIconsCategories,
            ),
            label: AppStrings.categoryView,
          ),
          BottomNavigationBarItem(
            icon: BottomNavIcon(
              isSelected: _currentTabIndex == 2,
              assetName: Assets.assetsIconsShoppingCart,
            ),
            label: AppStrings.cartView,
          ),
          BottomNavigationBarItem(
            icon: BottomNavIcon(
              isSelected: _currentTabIndex == 3,
              assetName: Assets.assetsIconsPerson,
            ),
            label: AppStrings.profileView,
          ),
        ],
      ),
    );
  }
}

