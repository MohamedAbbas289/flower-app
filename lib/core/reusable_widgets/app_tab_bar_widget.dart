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
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  final List<TabItemData> tabs;
  final void Function(TabItemData tab) onTabChanged;
  final int initialIndex;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

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
    _scrollController.addListener(_onScroll);

    if (widget.initialIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _scrollToTab(widget.initialIndex);
        });
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final reachedEnd = position.pixels >= position.maxScrollExtent - 50;

    if (reachedEnd && !widget.isLoadingMore) {
      widget.onLoadMore?.call();
    }
  }

  //TODO: show it to eng.Loay

  @override
  void didUpdateWidget(covariant AppTabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabs.length != widget.tabs.length) {
      final newKeys = List.generate(
        widget.tabs.length - oldWidget.tabs.length,
        (_) => GlobalKey(),
      );
      _tabKeys.addAll(newKeys);
    }

    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _scrollToTab(widget.initialIndex);
        });
      });
    }

    if (oldWidget.tabs.isEmpty && widget.tabs.isNotEmpty ||
        (oldWidget.tabs != widget.tabs &&
            _selectedIndex != widget.initialIndex)) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _scrollToTab(widget.initialIndex);
        });
      });
    }
  }

  void _scrollToTab(int index) {
    //>>>>>>>>>>>>>
    if (index < 0 || index >= _tabKeys.length) return;
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
        itemCount: widget.tabs.length + (widget.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          if (index == widget.tabs.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.pink,
                  ),
                ),
              ),
            );
          }

          final tab = widget.tabs[index];
          final isSelected = index == _selectedIndex;

          return GestureDetector(
            key: _tabKeys[index],
            onTap: () {
              if (_selectedIndex == index) return;
              setState(() => _selectedIndex = index);
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
      child: IntrinsicWidth(
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
      ),
    );
  }
}
