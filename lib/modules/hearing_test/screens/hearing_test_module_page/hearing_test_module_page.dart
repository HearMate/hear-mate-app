import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/featuers/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/hearing_test_history_results.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/hearing_test_result_page.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_welcome_page/hearing_test_welcome_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/repositories/database_repository.dart';

class HearingTestModulePage extends StatelessWidget {
  const HearingTestModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = RepositoryProvider.of<DatabaseRepository>(context);

    return BlocProvider<HearingTestModuleBloc>(
      create:
          (context) =>
              HearingTestModuleBloc(l10n: l10n, databaseRepository: db),
      child: const HearingTestModulePageView(),
    );
  }
}

class HearingTestModulePageView extends StatelessWidget {
  const HearingTestModulePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HearingTestModuleBloc, HearingTestModuleState>(
      buildWhen:
          (previous, current) => previous.currentStep != current.currentStep,
      builder: (context, state) {
        return Navigator(
          pages: [
            const MaterialPage(
              key: ValueKey('WelcomePage'),
              child: HearingTestWelcomePage(),
            ),
            if (state.currentStep == HearingTestPageStep.test)
              MaterialPage(
                key: const ValueKey('TestPage'),
                child: BlocProvider.value(
                  value: context.read<HearingTestModuleBloc>().hearingTestBloc,
                  child: const HearingTestPage(),
                ),
              )
            else if (state.currentStep == HearingTestPageStep.result)
              MaterialPage(
                key: const ValueKey('ResultPage'),
                child: HearingTestResultPage(),
              )
            else if (state.currentStep == HearingTestPageStep.history)
              const MaterialPage(
                key: ValueKey('HistoryPage'),
                child: HearingTestHistoryResultsPage(),
              ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;

            if (state.currentStep == HearingTestPageStep.welcome) {
              // If user is on welcome page, pop the module completely to go back to homepage
              Navigator.of(context).pop(); // Pops the entire module route
              return true;
            } else {
              // Otherwise, navigate back within the module
              context.read<HearingTestModuleBloc>().add(
                HearingTestModuleNavigateToWelcome(),
              );
              return true;
            }
          },
        );
      },
    );
  }
}
