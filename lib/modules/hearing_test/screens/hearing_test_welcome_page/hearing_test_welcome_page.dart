import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/tab_navigation_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/cubits/hearing_test_history_results/hearing_test_history_results_cubit.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
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
    return RepositoryProvider<HearingTestSoundsPlayerRepository>(
      create: (_) => HearingTestSoundsPlayerRepository(),
      child: BlocProvider<HearingTestBloc>(
        create: (context) => HearingTestBloc(
          hearingTestSoundsPlayerRepository:
              context.read<HearingTestSoundsPlayerRepository>(),
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

          return Scaffold(
            appBar: HMAppBar(
              route: ModalRoute.of(context)?.settings.name ?? "",
              title: l10n.hearing_test_welcome_page_title,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) =>
                  context.read<TabNavigationCubit>().changeTab(index),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.headphones),
                  label: l10n.hearing_test_welcome_page_test,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.file_copy),
                  label: l10n.hearing_test_welcome_page_saved,
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
