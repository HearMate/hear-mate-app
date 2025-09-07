import 'package:flutter/material.dart';
import 'package:hear_mate_app/cubits/headphones_search_bar/headphones_search_bar_cubit.dart';
import 'package:hear_mate_app/home_page.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_model.dart';
import 'package:hear_mate_app/modules/headphones_calibration/utils/const.dart'
    as HeadphonesCalibrationConstants;
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_classification_repository.dart';
import 'package:hear_mate_app/featuers/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_history_results/hearing_test_history_results.dart';
import 'package:hear_mate_app/featuers/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'package:hear_mate_app/repositories/headphones_searcher_repository.dart';
import 'package:hear_mate_app/widgets/headphones_search_bar.dart';
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
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 360),
                  child: BlocProvider(
                    create:
                        (context) => HeadphonesSearchBarCubit(
                          RepositoryProvider.of<HeadphonesSearcherRepository>(
                            context,
                          ),
                        ),
                    child: HeadphonesSearchBarWidget(
                      selectedButtonLabel: "Select",
                      onSelectedButtonPress: (searchedResult) {
                        context.read<HearingTestModuleBloc>().add(
                          HearingTestModuleSelectHeadphoneFromSearch(
                            HeadphonesModel.empty(name: searchedResult),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              BlocBuilder<HearingTestModuleBloc, HearingTestModuleState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state.headphonesModel == null)
                        Text(
                          "Please find your headphones before attempting a test",
                        )
                      else if (state.headphonesModel!.grade <
                          HeadphonesCalibrationConstants
                              .HEADPHONES_GRADE_THRESHOLD)
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text:
                                    "Unfortunately, we can't guarantee quality of this test - your headphones ",
                              ),
                              TextSpan(
                                text: state.headphonesModel!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: " are not properly calibrated yet!",
                              ),
                            ],
                          ),
                        )
                      else
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "Your headphones "),
                              TextSpan(
                                text: state.headphonesModel!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    " are properly calibrated! You are good to go!",
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 40),
                      FilledButton(
                        onPressed:
                            state.headphonesModel != null
                                ? () {
                                  context.read<HearingTestModuleBloc>().add(
                                    HearingTestModuleNavigateToTest(),
                                  );
                                }
                                : null,
                        style: FilledButton.styleFrom(
                          disabledBackgroundColor: Colors.grey.shade300,
                          disabledForegroundColor: Colors.grey.shade600,
                        ),
                        child: Text(
                          l10n.hearing_test_welcome_page_start_hearing_test,
                        ),
                      ),
                    ],
                  );
                },
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
