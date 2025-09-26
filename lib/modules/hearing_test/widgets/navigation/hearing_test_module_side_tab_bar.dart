import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'tabs.dart';
import 'hearing_test_module_tab_bar_interface.dart';

class HearingTestModuleSideTabBar extends NavigationTabBar {
  const HearingTestModuleSideTabBar({
    super.key,
    required super.currentTab,
    required super.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Widget buildDrawerItem({
      required IconData icon,
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: ListTile(
          leading: Icon(icon),
          title: Text(label),
          selected: selected,
          selectedTileColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: .1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onTap: onTap,
        ),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 280,
          child: Column(
            children: [
              buildDrawerItem(
                icon: Icons.headphones,
                label: l10n.hearing_test_welcome_page_test,
                selected: currentTab == ModuleTab.welcome,
                onTap: () => onTabSelected(indexToTab(0)),
              ),
              buildDrawerItem(
                icon: Icons.file_copy,
                label: l10n.hearing_test_welcome_page_saved,
                selected: currentTab == ModuleTab.history,
                onTap: () => onTabSelected(indexToTab(1)),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
