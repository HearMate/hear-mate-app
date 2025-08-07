import 'package:flutter/material.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_welcome_page/widgets/alert_dialogs.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_welcome_page/tab_navigation_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';

part 'screens/start_test_tab.dart';
part 'screens/saved_tests_tab.dart';

class HearingTestWelcomePage extends StatelessWidget {
  const HearingTestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<HearingTestSoundsPlayerRepository>(
      create: (_) => HearingTestSoundsPlayerRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HearingTestBloc>(
            create:
                (context) => HearingTestBloc(
                  hearingTestSoundsPlayerRepository:
                      context.read<HearingTestSoundsPlayerRepository>(),
                ),
          ),
          BlocProvider<HearingTestHistoryResultsCubit>(
            create: (_) => HearingTestHistoryResultsCubit(),
          ),
        ],
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
          final List<Widget> pages = [
            const _StartTestTab(),
            const _SavedTestsTab(),
          ];

          return Scaffold(
            appBar: HMAppBar(
              title: l10n.hearing_test_welcome_page_title,
              route: ModalRoute.of(context)?.settings.name ?? "",
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap:
                  (index) =>
                      context.read<TabNavigationCubit>().changeTab(index),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.headphones),
                  label: l10n.hearing_test_welcome_page_hearing_test_tab,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.folder),
                  label: l10n.hearing_test_welcome_page_saved_tests_tab,
                ),
              ],
            ),
            body: IndexedStack(index: currentIndex, children: pages),
          );
        },
      ),
    );
  }
}
