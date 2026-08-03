import 'package:flower_app/core/entities/tab_item_data.dart';
import 'package:flower_app/core/reusable_widgets/app_tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestTab implements TabItemData {
  @override
  final String id;
  @override
  final String name;

  const TestTab(this.id, this.name);
}

void main() {
  testWidgets('renders all tab names correctly', (tester) async {
    final tabs = [
      const TestTab('1', 'All'),
      const TestTab('2', 'Roses'),
      const TestTab('3', 'Lilies'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTabBarWidget(
            tabs: tabs,
            onTabChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Roses'), findsOneWidget);
    expect(find.text('Lilies'), findsOneWidget);
  });

  testWidgets('tapping a tab triggers onTabChanged callback', (tester) async {
    TabItemData? selectedTab;
    final tabs = [
      const TestTab('1', 'All'),
      const TestTab('2', 'Roses'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTabBarWidget(
            tabs: tabs,
            onTabChanged: (tab) => selectedTab = tab,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Roses'));
    await tester.pumpAndSettle();

    expect(selectedTab?.name, 'Roses');
  });

  testWidgets('does not crash when tab list shrinks', (tester) async {
    final initialTabs = [
      const TestTab('1', 'Tab 1'),
      const TestTab('2', 'Tab 2'),
      const TestTab('3', 'Tab 3'),
      const TestTab('4', 'Tab 4'),
    ];

    final updatedTabs = [
      const TestTab('1', 'Tab 1'),
      const TestTab('2', 'Tab 2'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTabBarWidget(
            tabs: initialTabs,
            onTabChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Tab 4'), findsOneWidget);

    // Re-render with fewer tabs
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTabBarWidget(
            tabs: updatedTabs,
            onTabChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Tab 2'), findsOneWidget);
    expect(find.text('Tab 4'), findsNothing);
  });
}
