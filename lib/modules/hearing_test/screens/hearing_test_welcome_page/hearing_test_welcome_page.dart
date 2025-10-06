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
        child: BlocProvider(
          create: (context) => HeadphonesSearchBarSupabaseCubit(),
          child: BlocBuilder<
            HeadphonesSearchBarSupabaseCubit,
            HeadphonesSearchBarSupabaseState
          >(
            builder: (context, state) {
              final resultsVisible = state.results.isNotEmpty;
              final showNoResults =
                  state.results.isEmpty &&
                  state.query.isNotEmpty &&
                  !state.isSearching;

              return Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 24),
                      HeadphonesSearchBarSupabaseWidget(),
                      const SizedBox(height: 16),
                      _HeadphonesTable(
                        title:
                            l10n.headphones_calibration_reference_headphones_title,
                        isReference: true,
                        icon: Icons.star_border,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      _buildNoHeadphonesInDatabaseButton(context, l10n),
                      const SizedBox(height: 24),
                      _buildQuickInfoCards(theme, l10n),
                      const SizedBox(height: 16),
                      _buildInstructions(theme, l10n),
                      const SizedBox(height: 16),
                      TipSection(theme: theme),
                      const SizedBox(height: 32),
                    ],
                  ),
                  _buildResults(
                    context,
                    l10n,
                    resultsVisible,
                    showNoResults,
                    state,
                    (searchedResult) {
                      context.read<HearingTestModuleBloc>().add(
                        HearingTestModuleSelectHeadphoneFromSearch(
                          HeadphonesModel.empty(name: searchedResult),
                        ),
                      );
                    },
                    l10n.headphones_calibration_add_button,
                    88.0,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    AppLocalizations l10n,
    bool resultsVisible,
    bool showNoResults,
    HeadphonesSearchBarSupabaseState state,
    ValueChanged<String> onSelectedButtonPress,
    String selectedButtonLabel,
    double positionTop,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final borderColor = theme.dividerColor;
    final surfaceColor = colors.surface;
    final cubit = context.read<HeadphonesSearchBarSupabaseCubit>();

    if (resultsVisible) {
      return Positioned(
        top: positionTop,
        left: 0,
        right: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 250),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Focus(
                focusNode: cubit.focusNodeList,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    FocusScope.of(context).requestFocus(cubit.focusNodeList);
                    return false;
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: Builder(
                        builder: (context) {
                          final scrollController = ScrollController();

                          return Scrollbar(
                            controller: scrollController,
                            thumbVisibility: true,
                            thickness: 4,
                            radius: const Radius.circular(2),
                            child: ListView.separated(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: state.results.length,
                              separatorBuilder:
                                  (_, __) =>
                                      Divider(height: 1, color: borderColor),
                              itemBuilder: (context, index) {
                                final item = state.results[index];
                                return ListTile(
                                  leading: Icon(
                                    Icons.headphones,
                                    color: colors.primary,
                                  ),
                                  title: Text(
                                    item,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  trailing: OutlinedButton(
                                    onPressed: () {
                                      _selectHeadphonesAction(
                                        context,
                                        onSelectedButtonPress,
                                        cubit,
                                        item,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      selectedButtonLabel,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  onTap: () {
                                    _selectHeadphonesAction(
                                      context,
                                      onSelectedButtonPress,
                                      cubit,
                                      item,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (showNoResults) {
      return Positioned(
        top: positionTop,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.hearing_test_welcome_no_results_found_reference,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.hearing_test_welcome_try_different_keywords,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void _selectHeadphonesAction(
    BuildContext context,
    ValueChanged<String> onSelectedButtonPress,
    HeadphonesSearchBarSupabaseCubit cubit,
    String item,
  ) {
    onSelectedButtonPress(item);
    cubit.clearQuery();
    FocusScope.of(context).unfocus();
  }

  Widget _buildNoHeadphonesInDatabaseButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Center(
      child: OutlinedButton(
        onPressed:
            () => {
              _headphonesNotCalibratedDialog(context, l10n),
              //? We may or not add the removeHeadphonesFromState functionality
              //? but in my opinion this should not be done implicitly.
            },
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
        SectionHeader(
          icon: Icons.info_outline,
          title: l10n.hearing_test_welcome_quick_info_title,
          theme: theme,
        ),
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
      constraints: BoxConstraints(maxWidth: 400),
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

                return FilledButton(
                  onPressed: () {
                    if (hasSelectedHeadphones) {
                      context.read<HearingTestModuleBloc>().add(
                        HearingTestModuleNavigateToTest(),
                      );
                    } else {
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
  final hearingTestModuleBloc = context.read<HearingTestModuleBloc>();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.hearing_test_welcome_page_no_headphones_selected_title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.hearing_test_welcome_page_no_headphones_selected_message,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.hearing_test_welcome_page_no_headphones_selected_go_back,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        hearingTestModuleBloc.add(
                          HearingTestModuleNavigateToTest(),
                        );
                      },
                      child: Text(
                        l10n.hearing_test_welcome_page_no_headphones_selected_continue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    barrierDismissible: true, // Allow dismissing by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.hearing_test_welcome_page_uncalibrated_headphones_title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Content
              Text(
                l10n.hearing_test_welcome_page_no_headphones_in_database_popup,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    },
  );
}
