import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/features/hearing_test/bloc/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/tab_navigation_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/hearing_test_module_bottom_tab_bar.dart/hearing_test_module_bottom_tab_bar.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
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

    return Scaffold(
      appBar: HMAppBar(
        title: "",
        route: ModalRoute.of(context)?.settings.name ?? "",
        onBackPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
      ),
      bottomNavigationBar: HearingTestModuleBottomTabBar(
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
        child: Column(
          children: [
            _buildHeader(theme, l10n),
            _buildContent(theme, l10n),
            _buildStartButton(context, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.08),
            theme.colorScheme.primary.withValues(alpha: 0.02),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: theme.primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hearing,
              size: 48,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.test_tab_header_title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.test_tab_header_subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AppLocalizations l10n) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
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
            child: FilledButton(
              onPressed: () {
                context.read<HearingTestModuleBloc>().add(
                  HearingTestModuleNavigateToTest(),
                );
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
