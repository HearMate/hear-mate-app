import 'package:flutter/material.dart';
import 'tabs.dart';

abstract class NavigationTabBar extends StatelessWidget {
  final ModuleTab currentTab;
  final ValueChanged<ModuleTab> onTabSelected;

  const NavigationTabBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  int tabToIndex(ModuleTab tab) {
    switch (tab) {
      case ModuleTab.welcome:
        return 0;
      case ModuleTab.history:
        return 1;
    }
  }

  ModuleTab indexToTab(int index) {
    switch (index) {
      case 0:
        return ModuleTab.welcome;
      default:
        return ModuleTab.history;
    }
  }
}
