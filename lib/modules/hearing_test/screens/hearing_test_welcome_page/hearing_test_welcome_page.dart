import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/features/headphones_search_db/cubits/headphones_search_bar_db/headphones_search_bar_supabase_cubit.dart';
import 'package:hear_mate_app/features/headphones_search_db/screens/headphones_search_bar_supabase.dart';
import 'package:hear_mate_app/features/headphones_search_ebay/models/headphones_model.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/navigation/hearing_test_module_bottom_tab_bar.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/navigation/hearing_test_module_side_tab_bar.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/navigation/tabs.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
import 'package:hear_mate_app/shared/utils/media_query_helper.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/header_banner/header_banner.dart';
import 'widgets/quick_info_card.dart';
import 'widgets/section_header.dart';
import 'widgets/step_item.dart';
import 'widgets/tip_section.dart';

class HearingTestWelcomePage extends StatelessWidget {
  const HearingTestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final moduleBloc = context.read<HearingTestModuleBloc>();
    final isWideScreen = MediaQueryHelper.isWideScreen(context);

    return Scaffold(
      appBar: HMAppBar(
        title: "",
        route: ModalRoute.of(context)?.settings.name ?? "",
        onBackPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
      ),
      bottomNavigationBar:
          isWideScreen
              ? null
              : HearingTestModuleBottomTabBar(
                currentTab: ModuleTab.welcome,
                onTabSelected: (tab) {
                  switch (tab) {
                    case ModuleTab.welcome:
                      // Do nothing if already on test
                      break;
                    case ModuleTab.history:
                      moduleBloc.add(HearingTestModuleNavigateToHistory());
                      break;
                  }
                },
              ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Row(
            children: [
              if (isWideScreen)
                HearingTestModuleSideTabBar(
                  currentTab: ModuleTab.welcome,
                  onTabSelected: (tab) {
                    switch (tab) {
                      case ModuleTab.welcome:
                        // Do nothing if already on test
                        break;
                      case ModuleTab.history:
                        moduleBloc.add(HearingTestModuleNavigateToHistory());
                        break;
                    }
                  },
                ),
              const VerticalDivider(width: 1, thickness: .3),
              Expanded(
                child: Column(
                  children: [
                    HeaderBanner(
                      title: l10n.test_tab_header_title,
                      subtitle: l10n.test_tab_header_subtitle,
                      icon: Icons.hearing,
                    ),
                    _buildContent(context, theme, l10n),
                    _buildStartButton(context, l10n, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildHeadphonesBar(context, l10n),
            const SizedBox(height: 16),
            _buildNoHeadphonesInDatabaseButton(context, l10n),
            const SizedBox(height: 16),
            _buildQuickInfoCards(theme, l10n),
            const SizedBox(height: 16),
            _buildInstructions(theme, l10n),
            const SizedBox(height: 16),
            TipSection(theme: theme),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadphonesBar(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        BlocProvider(
          create: (context) => HeadphonesSearchBarSupabaseCubit(),
          child: HeadphonesSearchBarSupabaseWidget(
            selectedButtonLabel: l10n.headphones_calibration_add_button,
            onSelectedButtonPress: (searchedResult) {
              context.read<HearingTestModuleBloc>().add(
                HearingTestModuleSelectHeadphoneFromSearch(
                  HeadphonesModel.empty(name: searchedResult),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _HeadphonesTable(
          title: l10n.hearing_test_welcome_page_your_headphones_title,
          isReference: true,
          icon: Icons.headphones,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildQuickInfoCards(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        QuickInfoCard(
          icon: Icons.schedule,
          title: l10n.test_tab_test_time_value,
          subtitle: l10n.test_tab_test_time_info,
          theme: theme,
        ),
        const Divider(height: 1),
        QuickInfoCard(
          icon: Icons.headphones,
          title: l10n.test_tab_headphones,
          subtitle: l10n.test_tab_headphones_info,
          theme: theme,
        ),
        const Divider(height: 1),
        QuickInfoCard(
          icon: Icons.volume_off,
          title: l10n.test_tab_quiet,
          subtitle: l10n.test_tab_quiet_desc,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInstructions(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        SectionHeader(
          icon: Icons.list_alt,
          title: l10n.test_tab_how_it_works,
          theme: theme,
        ),
        StepItem(
          stepNumber: "1",
          text: l10n.test_tab_how_it_works_desc_1,
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(
          stepNumber: "2",
          text: l10n.test_tab_how_it_works_desc_2,
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(
          stepNumber: "3",
          text: l10n.test_tab_how_it_works_desc_3,
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(
          stepNumber: "4",
          text: l10n.test_tab_how_it_works_desc_4,
          theme: theme,
        ),
        const Divider(height: 1),
        StepItem(
          stepNumber: "5",
          text: l10n.test_tab_how_it_works_desc_5,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildStartButton(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: BlocBuilder<HearingTestModuleBloc, HearingTestModuleState>(
              builder: (context, state) {
                final hasSelectedHeadphones = state.selectedHeadphone != null;
                final isCalibrated =
                    state.selectedHeadphone?.isCalibrated ?? false;

                return FilledButton(
                  onPressed: () {
                    if (hasSelectedHeadphones) {
                      if (isCalibrated) {
                        // Calibrated headphones - proceed directly
                        context.read<HearingTestModuleBloc>().add(
                          HearingTestModuleNavigateToTest(),
                        );
                      } else {
                        // Uncalibrated headphones - show warning
                        _showHeadphonesNotCalibratedDialog(context, l10n);
                      }
                    } else {
                      // No headphones selected - show selection warning
                      _showNoHeadphonesSelectedDialog(context, l10n);
                    }
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        l10n.hearing_test_welcome_page_start_hearing_test,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.test_tab_ready,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HeadphonesTable extends StatelessWidget {
  final String title;
  final bool isReference;
  final IconData icon;
  final Color color;

  const _HeadphonesTable({
    required this.title,
    required this.isReference,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HearingTestModuleBloc, HearingTestModuleState>(
      builder: (context, state) {
        final selectedHeadphone = state.selectedHeadphone;
        final isCalibrated = selectedHeadphone?.isCalibrated ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: color.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 28, color: color),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      selectedHeadphone != null
                          ? selectedHeadphone.name
                          : l10n.headphones_calibration_not_selected,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (selectedHeadphone != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isCalibrated
                                    ? Colors.green.withValues(alpha: .1)
                                    : Colors.orange
                                ..withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCalibrated ? Colors.green : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCalibrated ? Icons.check_circle : Icons.warning,
                              size: 16,
                              color:
                                  isCalibrated ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isCalibrated ? "Calibrated" : "Not Calibrated",
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isCalibrated ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showHeadphonesNotCalibratedDialog(
  BuildContext context,
  AppLocalizations l10n,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.hearing_test_welcome_page_uncalibrated_headphones_title,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.hearing_test_welcome_page_no_headphones_in_database_popup,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushReplacementNamed('/headphones_calibration/welcome');
            },
            child: Text(
              l10n.hearing_test_welcome_page_uncalibrated_headphones_popup_calibrate_button,
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Continue with test anyway
              context.read<HearingTestModuleBloc>().add(
                HearingTestModuleNavigateToTest(),
              );
            },
            child: Text(
              l10n.hearing_test_welcome_page_uncalibrated_headphones_popup_continue_button,
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildNoHeadphonesInDatabaseButton(
  BuildContext context,
  AppLocalizations l10n,
) {
  return Center(
    child: OutlinedButton(
      onPressed: () => _showHeadphonesNotCalibratedDialog(context, l10n),
      child: Text(
        style: const TextStyle(fontSize: 14.0),
        l10n.hearing_test_welcome_page_no_headphones_in_database_button,
      ),
    ),
  );
}

void _showNoHeadphonesSelectedDialog(
  BuildContext context,
  AppLocalizations l10n,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.hearing_test_welcome_page_no_headphones_selected_title,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.hearing_test_welcome_page_no_headphones_selected_message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.hearing_test_welcome_page_no_headphones_selected_go_back,
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Continue with test without headphones
              context.read<HearingTestModuleBloc>().add(
                HearingTestModuleNavigateToTest(),
              );
            },
            child: Text(
              l10n.hearing_test_welcome_page_no_headphones_selected_continue,
            ),
          ),
        ],
      );
    },
  );
}
