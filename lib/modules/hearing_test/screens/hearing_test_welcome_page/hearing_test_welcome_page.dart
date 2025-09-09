import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/features/headphones_search_bar/cubits/headphones_search_bar/headphones_search_bar_cubit.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_model.dart';
import 'package:hear_mate_app/modules/headphones_calibration/utils/headphones_calibration_constants.dart'
    as HeadphonesCalibrationConstants;
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/features/headphones_search_bar/repositories/headphones_searcher_repository.dart';
import 'package:hear_mate_app/features/headphones_search_bar/screens/headphones_search_bar.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';

class HearingTestWelcomePage extends StatelessWidget {
  const HearingTestWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HearingTestModuleBloc, HearingTestModuleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: HMAppBar(
            title: l10n.hearing_test_welcome_page_title,
            route: ModalRoute.of(context)?.settings.name ?? '',
            customBackRoute: '/',
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(l10n),
                const SizedBox(height: 20),
                _buildDescription(l10n),
                const SizedBox(height: 16),
                _buildSearchBar(context, l10n),
                const SizedBox(height: 16),
                _buildStatusAndActions(context, state, l10n),
                const SizedBox(height: 10),
                _buildHistoryButton(context, l10n),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        l10n.hearing_test_welcome_page_welcome,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        l10n.hearing_test_welcome_page_description,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: BlocProvider(
          create: (_) => HeadphonesSearchBarCubit(),
          child: HeadphonesSearchBarWidget(
            selectedButtonLabel:
                l10n.hearing_test_welcome_page_select_button_label,
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
    );
  }

  Widget _buildStatusAndActions(
    BuildContext context,
    HearingTestModuleState state,
    AppLocalizations l10n,
  ) {
    final model = state.headphonesModel;
    final canStart = model != null;

    return Column(
      children: [
        _buildStatusMessage(model, l10n),
        const SizedBox(height: 40),
        FilledButton(
          onPressed:
              canStart
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
          child: Text(l10n.hearing_test_welcome_page_start_hearing_test),
        ),
      ],
    );
  }

  Widget _buildStatusMessage(HeadphonesModel? model, AppLocalizations l10n) {
    if (model == null) {
      return Text(l10n.hearing_test_welcome_page_find_headphones);
    }

    final isCalibrated =
        model.grade >=
        HeadphonesCalibrationConstants.HEADPHONES_GRADE_THRESHOLD;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    isCalibrated
                        ? l10n.hearing_test_welcome_page_calibrated_part1
                        : l10n.hearing_test_welcome_page_not_calibrated_part1,
              ),
              TextSpan(
                text: model.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    isCalibrated
                        ? l10n.hearing_test_welcome_page_calibrated_part2
                        : l10n.hearing_test_welcome_page_not_calibrated_part2,
              ),
            ],
          ),
          softWrap: true,
        ),
      ),
    );
  }

  Widget _buildHistoryButton(BuildContext context, AppLocalizations l10n) {
    return OutlinedButton(
      onPressed: () {
        context.read<HearingTestModuleBloc>().add(
          HearingTestModuleNavigateToHistory(),
        );
      },
      child: Text(l10n.hearing_test_result_history_page),
    );
  }
}
