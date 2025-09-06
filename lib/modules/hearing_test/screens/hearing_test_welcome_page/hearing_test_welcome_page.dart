import 'package:flutter/material.dart';
import 'package:hear_mate_app/home_page.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_classification_repository.dart';
import 'package:hear_mate_app/featuers/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/hearing_test_history_results.dart';
import 'package:hear_mate_app/featuers/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HearingTestWelcomePage extends StatelessWidget {
  const HearingTestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<HearingTestModuleBloc, HearingTestModuleState>(
      listenWhen:
          (previous, current) =>
              !previous.disclaimerShown && !current.disclaimerShown,
      listener: (context, state) {
        if (!state.disclaimerShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HearingTestModuleBloc>().add(
              HearingTestModuleShowDisclaimer(),
            );
          });
        }
      },
      child: Scaffold(
        appBar: HMAppBar(
          title: l10n.hearing_test_welcome_page_title,
          route: ModalRoute.of(context)?.settings.name ?? "",
          customBackRoute: "/",
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  l10n.hearing_test_welcome_page_welcome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  l10n.hearing_test_welcome_page_description,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  context.read<HearingTestModuleBloc>().add(
                    HearingTestModuleNavigateToTest(),
                  );
                },
                child: Text(l10n.hearing_test_welcome_page_start_hearing_test),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  context.read<HearingTestModuleBloc>().add(
                    HearingTestModuleNavigateToHistory(),
                  );
                },
                child: Text(l10n.hearing_test_result_history_page),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
