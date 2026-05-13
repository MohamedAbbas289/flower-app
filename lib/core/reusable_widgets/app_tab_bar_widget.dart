import 'package:flower_app/core/entities/tab_item_data.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
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

  final ScrollController _scrollController = ScrollController();

  late final List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;

    _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant AppTabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });

      _scrollToTab(widget.initialIndex);
    }
  }

  void _scrollToTab(int index) {
    final BuildContext? context = _tabKeys[index].currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final tab = widget.tabs[index];
          final isSelected = index == _selectedIndex;

          return GestureDetector(
            key: _tabKeys[index],
            onTap: () {
              if (_selectedIndex == index) return;

              setState(() {
                _selectedIndex = index;
              });

              _scrollToTab(index);

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.bodyRegular14.copyWith(
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
