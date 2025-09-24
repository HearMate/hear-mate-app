import 'package:flutter/material.dart';

/// Tabs exposed by the bottom tab bar.
enum ModuleTab { welcome, history }

/// A small reusable bottom navigation bar used across the hearing-test module.
/// - It is intentionally UI-only: when a tab is selected it invokes [onTabSelected].
/// - The caller (module page / bloc) is responsible for handling the event.
class HearingTestModuleBottomTabBar extends StatelessWidget {
  final ModuleTab currentTab;
  final ValueChanged<ModuleTab> onTabSelected;

  const HearingTestModuleBottomTabBar({
    Key? key,
    required this.currentTab,
    required this.onTabSelected,
  }) : super(key: key);

  int _tabToIndex(ModuleTab tab) {
    switch (tab) {
      case ModuleTab.welcome:
        return 0;
      case ModuleTab.history:
        return 1;
    }
  }

  ModuleTab _indexToTab(int index) {
    switch (index) {
      case 0:
        return ModuleTab.welcome;
      default:
        return ModuleTab.history;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _tabToIndex(currentTab),
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onTabSelected(_indexToTab(index)),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.headphones), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
      ],
    );
  }
}
