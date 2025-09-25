import 'package:flutter/material.dart';
import 'tabs.dart';
import 'hearing_test_module_tab_bar_interface.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HearingTestModuleBottomTabBar extends NavigationTabBar {
  const HearingTestModuleBottomTabBar({
    super.key,
    required super.currentTab,
    required super.onTabSelected,
  });

  int _tabToIndex(ModuleTab tab) {
    switch (tab) {
      case ModuleTab.welcome:
        return 0;
      case ModuleTab.history:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = _tabToIndex(currentTab);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onTabSelected(indexToTab(index)),
      items: [
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              color:
                  currentIndex == 0
                      ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: const Icon(Icons.headphones),
          ),
          label: l10n.hearing_test_welcome_page_test,
        ),
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              color:
                  currentIndex == 1
                      ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: const Icon(Icons.file_copy),
          ),
          label: l10n.hearing_test_welcome_page_saved,
        ),
      ],
    );
  }
}
