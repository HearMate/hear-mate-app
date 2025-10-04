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

part 'widgets/headphones_table.dart';

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
                    _buildStartTestButton(context, l10n, theme),
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
            const SizedBox(height: 16),
            _buildHeadphoneSearchingSection(context, l10n),
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

  Widget _buildHeadphoneSearchingSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
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
            additionalWidgets: [
              _HeadphonesTable(
                title: l10n.headphones_calibration_reference_headphones_title,
                isReference: true,
                icon: Icons.star_border,
                color: Theme.of(context).colorScheme.primary,
              ),
              _buildNoHeadphonesInDatabaseButton(context, l10n),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNoHeadphonesInDatabaseButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Center(
      child: OutlinedButton(
        onPressed: () => _headphonesNotCalibratedDialog(context, l10n),
        child: Text(
          style: const TextStyle(fontSize: 14.0),
          l10n.hearing_test_welcome_page_no_headphones_in_database_button,
        ),
      ),
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

  Widget _buildStartTestButton(
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
                        _headphonesNotCalibratedDialog(context, l10n);
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

void _headphonesNotCalibratedDialog(
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
