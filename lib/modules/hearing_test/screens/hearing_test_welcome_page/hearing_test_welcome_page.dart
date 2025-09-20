import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/tab_navigation_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_classification_repository.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'tabs/widgets/quick_info_card.dart';
import 'tabs/widgets/section_header.dart';
import 'tabs/widgets/step_item.dart';
import 'tabs/widgets/tip_section.dart';
import 'tabs/widgets/empty_state.dart';
import 'tabs/widgets/results_header.dart';
import 'tabs/widgets/result_list_item.dart';

part 'tabs/test_tab.dart';
part 'tabs/saved_tab.dart';

class HearingTestWelcomePage extends StatelessWidget {
  const HearingTestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HearingTestSoundsPlayerRepository>(
          create: (_) => HearingTestSoundsPlayerRepository(),
        ),
        RepositoryProvider<HearingTestAudiogramClassificationRepository>(
          create: (_) => HearingTestAudiogramClassificationRepository(),
        ),
      ],
      child: BlocProvider<HearingTestBloc>(
        create:
            (context) => HearingTestBloc(
              l10n: l10n,
              hearingTestSoundsPlayerRepository:
                  context.read<HearingTestSoundsPlayerRepository>(),
              audiogramClassificationRepository:
                  context.read<HearingTestAudiogramClassificationRepository>(),
            ),
        child: const HearingTestWelcomePageView(),
      ),
    );
  }
}

class HearingTestWelcomePageView extends StatelessWidget {
  const HearingTestWelcomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => TabNavigationCubit(),

      child: BlocBuilder<TabNavigationCubit, int>(
        builder: (context, currentIndex) {
          final List<Widget> pages = [const _TestTab(), const _SavedTab()];
          final isWideScreen = MediaQuery.of(context).size.width > 700;

          Widget buildDrawerItem({
            required IconData icon,
            required String label,
            required bool selected,
            required VoidCallback onTap,
          }) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
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

          return Scaffold(
            appBar: HMAppBar(
              route: ModalRoute.of(context)?.settings.name ?? "",
              title: l10n.hearing_test_welcome_page_title,
            ),
            body:
                isWideScreen
                    ? Row(
                      children: [
                        SizedBox(
                          width: 280,
                          child: Column(
                            children: [
                              buildDrawerItem(
                                icon: Icons.headphones,
                                label: l10n.hearing_test_welcome_page_test,
                                selected: currentIndex == 0,
                                onTap:
                                    () => context
                                        .read<TabNavigationCubit>()
                                        .changeTab(0),
                              ),
                              buildDrawerItem(
                                icon: Icons.file_copy,
                                label: l10n.hearing_test_welcome_page_saved,
                                selected: currentIndex == 1,
                                onTap:
                                    () => context
                                        .read<TabNavigationCubit>()
                                        .changeTab(1),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: currentIndex,
                            children: pages,
                          ),
                        ),
                      ],
                    )
                    : IndexedStack(index: currentIndex, children: pages),
            bottomNavigationBar:
                isWideScreen
                    ? null
                    : BottomNavigationBar(
                      currentIndex: currentIndex,
                      onTap:
                          (index) => context
                              .read<TabNavigationCubit>()
                              .changeTab(index),
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                          icon: Container(
                            decoration: BoxDecoration(
                              color:
                                  currentIndex == 0
                                      ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: .1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: const Icon(Icons.headphones),
                          ),
                          label: l10n.hearing_test_welcome_page_test,
                        ),
                        BottomNavigationBarItem(
                          icon: Container(
                            decoration: BoxDecoration(
                              color:
                                  currentIndex == 1
                                      ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: .1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: const Icon(Icons.file_copy),
                          ),
                          label: l10n.hearing_test_welcome_page_saved,
                        ),
                      ],
                    ),
          );
        },
      ),
    );
  }
}
