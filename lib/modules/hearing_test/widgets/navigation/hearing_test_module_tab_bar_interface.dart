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

  ModuleTab indexToTab(int index) {
    switch (index) {
      case 0:
        return ModuleTab.welcome;
      default:
        return ModuleTab.history;
    }
  }
}
