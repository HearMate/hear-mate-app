import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/widgets/empty_state.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/widgets/result_state_item.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/header_banner/header_banner.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/navigation/hearing_test_module_side_tab_bar.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/navigation/hearing_test_module_bottom_tab_bar.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/navigation/tabs.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
import 'package:hear_mate_app/shared/utils/media_query_helper.dart';

class HearingTestHistoryResultsPage extends StatelessWidget {
  const HearingTestHistoryResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final moduleBloc = context.read<HearingTestModuleBloc>();
    final isWideScreen = MediaQueryHelper.isWideScreen(context);

    return BlocProvider(
      create: (_) => HearingTestHistoryResultsCubit(),
      child: Scaffold(
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
                  currentTab: ModuleTab.history,
                  onTabSelected: (tab) {
                    switch (tab) {
                      case ModuleTab.welcome:
                        moduleBloc.add(HearingTestModuleNavigateToWelcome());
                        break;
                      case ModuleTab.history:
                        // Do nothing if already on history
                        break;
                    }
                  },
                ),

        body: SafeArea(
          child: Row(
            children: [
              if (isWideScreen)
                HearingTestModuleSideTabBar(
                  currentTab: ModuleTab.history,
                  onTabSelected: (tab) {
                    switch (tab) {
                      case ModuleTab.welcome:
                        moduleBloc.add(HearingTestModuleNavigateToWelcome());
                        break;
                      case ModuleTab.history:
                        // Do nothing if already on history
                        break;
                    }
                  },
                ),

              const VerticalDivider(width: 1, thickness: .3),
              Expanded(
                child: BlocBuilder<
                  HearingTestHistoryResultsCubit,
                  HearingTestHistoryResultsState
                >(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.error != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.error_message(state.error ?? ''),
                                style: theme.textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state.results.isEmpty) {
                      return EmptyState(theme: theme);
                    }

                    return Column(
                      children: [
                        HeaderBanner(
                          title: l10n.results_header_saved_results,
                          subtitle: l10n.results_header_results_count(
                            state.results.length,
                          ),
                          icon: Icons.history,
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: state.results.length,
                            separatorBuilder:
                                (context, index) => Divider(
                                  height: 1,
                                  color: theme.dividerColor,
                                ),
                            itemBuilder: (context, index) {
                              final result = state.results[index];
                              final isSelected = state.selectedIndex == index;

                              return ResultListItem(
                                result: result,
                                isSelected: isSelected,
                                index: index,
                                theme: theme,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
