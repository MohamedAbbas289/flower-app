import 'package:flower_app/core/entities/tab_item_data.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/responsive_text_style.dart';
import 'package:flutter/material.dart';

class AppTabBarWidget extends StatefulWidget {
  const AppTabBarWidget({
    super.key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
  });

  final List<TabItem> tabs;
  final void Function(TabItem tab) onTabChanged;
  final int initialIndex;

  @override
  State<AppTabBarWidget> createState() => _AppTabBarWidgetState();
}

class _AppTabBarWidgetState extends State<AppTabBarWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final tab = widget.tabs[index];
          final isSelected = index == _selectedIndex;

          return GestureDetector(
            onTap: () {
              if (_selectedIndex == index) return;
              setState(() => _selectedIndex = index);
              widget.onTabChanged(tab);
            },
            child: _TabItem(label: tab.name, isSelected: isSelected),
          );
        },
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.bodyRegular14
                .responsive(size, mobile: 14, tablet: 15)
                .copyWith(
                  color: isSelected ? AppColors.pink : AppColors.gray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            color: isSelected ? AppColors.pink : AppColors.placeHolder,
          ),
        ],
      ),
    );
  }
}
