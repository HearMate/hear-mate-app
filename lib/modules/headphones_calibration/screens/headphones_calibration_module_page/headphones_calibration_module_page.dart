import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/featuers/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'package:hear_mate_app/modules/headphones_calibration/blocs/headphones_calibration_module/headphones_calibration_module_bloc.dart';
import 'package:hear_mate_app/modules/headphones_calibration/screens/headphones_calibration_end_page/headphones_calibration_end_page.dart';
import 'package:hear_mate_app/modules/headphones_calibration/screens/headphones_calibration_information_between_tests_page/headphones_calibration_information_between_tests_page.dart';
import 'package:hear_mate_app/modules/headphones_calibration/screens/headphones_calibration_welcome_page/headphones_calibration_welcome_page.dart';
import 'package:hear_mate_app/repositories/database_repository.dart';
import 'package:hear_mate_app/repositories/headphones_searcher_repository.dart';

class HeadphonesCalibrationModulePage extends StatelessWidget {
  const HeadphonesCalibrationModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = RepositoryProvider.of<DatabaseRepository>(context);
    final headphonesSearcher =
        RepositoryProvider.of<HeadphonesSearcherRepository>(context);

    return BlocProvider<HeadphonesCalibrationModuleBloc>(
      create:
          (context) => HeadphonesCalibrationModuleBloc(
            l10n: l10n,
            databaseRepository: db,
            headphonesSearcherRepository: headphonesSearcher,
          ),
      child: const HeadphonesCalibrationModuleView(),
    );
  }
}

class HeadphonesCalibrationModuleView extends StatelessWidget {
  const HeadphonesCalibrationModuleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      HeadphonesCalibrationModuleBloc,
      HeadphonesCalibrationModuleState
    >(
      buildWhen:
          (previous, current) => previous.currentStep != current.currentStep,
      builder: (context, state) {
        if (state.currentStep == HeadphonesCalibrationStep.exit) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(
              context,
            ).popUntil((route) => route.settings.name == '/');
          });
          return const SizedBox.shrink();
        }
        return Navigator(
          pages: [
            const MaterialPage(
              key: ValueKey('WelcomePage'),
              child: HeadphonesCalibrationWelcomePage(),
            ),
            if (state.currentStep == HeadphonesCalibrationStep.firstTest)
              MaterialPage(
                key: const ValueKey('FirstTestPage'),
                child: BlocProvider.value(
                  value:
                      context
                          .read<HeadphonesCalibrationModuleBloc>()
                          .hearingTestBloc,
                  child: const HearingTestPage(),
                ),
              )
            else if (state.currentStep ==
                HeadphonesCalibrationStep.informationBetweenTests)
              const MaterialPage(
                key: ValueKey('InformationBetweenTestsPage'),
                child: HeadphonesCalibrationInformationBetweenTestsPage(),
              )
            else if (state.currentStep == HeadphonesCalibrationStep.secondTest)
              MaterialPage(
                key: const ValueKey('SecondTestPage'),
                child: BlocProvider.value(
                  value:
                      context
                          .read<HeadphonesCalibrationModuleBloc>()
                          .hearingTestBloc,
                  child: const HearingTestPage(),
                ),
              )
            else if (state.currentStep == HeadphonesCalibrationStep.end)
              const MaterialPage(
                key: ValueKey('EndPage'),
                child: HeadphonesCalibrationEndPage(),
              ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;

            if (state.currentStep == HeadphonesCalibrationStep.welcome) {
              Navigator.of(context).pop();
              return true;
            } else {
              context.read<HeadphonesCalibrationModuleBloc>().add(
                HeadphonesCalibrationModuleNavigateToWelcome(),
              );
              return true;
            }
          },
        );
      },
    );
  }
}
