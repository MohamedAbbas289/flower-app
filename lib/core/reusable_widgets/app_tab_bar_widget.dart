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
  late List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _clampIndex(widget.initialIndex);
    _syncTabKeys();
    _scrollController.addListener(_onScroll);

    if (_selectedIndex > 0) {
      _scheduleScrollToTab(_selectedIndex);
    }
  }

  int _clampIndex(int index) {
    if (widget.tabs.isEmpty) return 0;
    return index.clamp(0, widget.tabs.length - 1);
  }

  void _syncTabKeys() {
    _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final reachedEnd = position.pixels >= position.maxScrollExtent - 50;

    if (reachedEnd && !widget.isLoadingMore) {
      widget.onLoadMore?.call();
    }
  }

  @override
  void didUpdateWidget(covariant AppTabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool tabsLengthChanged = oldWidget.tabs.length != widget.tabs.length;
    final bool initialIndexChanged = oldWidget.initialIndex != widget.initialIndex;
    final bool tabsListChanged = oldWidget.tabs != widget.tabs;

    if (tabsLengthChanged) {
      _syncTabKeys();
    }

    if (initialIndexChanged ||
        (oldWidget.tabs.isEmpty && widget.tabs.isNotEmpty) ||
        tabsListChanged) {
      final newIndex = _clampIndex(widget.initialIndex);
      if (_selectedIndex != newIndex || initialIndexChanged) {
        setState(() {
          _selectedIndex = newIndex;
        });
        _scheduleScrollToTab(newIndex);
      }
    } else {
      final clamped = _clampIndex(_selectedIndex);
      if (clamped != _selectedIndex) {
        setState(() {
          _selectedIndex = clamped;
        });
      }
    }
  }

  void _scheduleScrollToTab(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToTab(index);
    });
  }

  void _scrollToTab(int index) {
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
