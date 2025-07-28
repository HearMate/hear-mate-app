import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';
import 'package:hm_theme/hm_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/alert_dialogs.dart';

// TODO: Talk if we want this kind of approach.
// TODO: Some kind of paging probably...

class HearingTestResultPage extends StatelessWidget {
  HearingTestResultPage({super.key});

  Future<bool> _backDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<HearingTestBloc>(),
            child: const BackAlertDialog(),
          ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<HearingTestBloc, HearingTestState>(
      builder: (context, state) {
        return Scaffold(
          appBar: HMAppBar(
            title: loc.hearing_test_result_page_title,
            route: ModalRoute.of(context)?.settings.name ?? "",
            customBackRoute: '/hearing_test/welcome',
            onBackPressed:
                state.resultSaved ? null : () => _backDialog(context),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(loc),
                  const SizedBox(height: 20),
                  _buildInstructions(loc),
                  const SizedBox(height: 30),
                  _buildAudiogramChart(state),
                  const SizedBox(height: 30),
                  _buildNoteSection(context, loc),
                  const SizedBox(height: 30),
                  _buildSaveButton(context, loc),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(AppLocalizations loc) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Text(
      loc.hearing_test_result_page_your_results,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildInstructions(AppLocalizations loc) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Text(
      loc.hearing_test_result_page_instruction,
      style: const TextStyle(fontSize: 18, color: Colors.grey),
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildAudiogramChart(HearingTestState state) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
    child: AudiogramChart(
      leftEarData: state.results.leftEarResults,
      rightEarData: state.results.rightEarResults,
      leftEarMaskedData:
          state.results.leftEarResultsMasked.every((elem) => elem == null)
              ? null
              : state.results.leftEarResultsMasked,
      rightEarMaskedData:
          state.results.rightEarResultsMasked.every((elem) => elem == null)
              ? null
              : state.results.rightEarResultsMasked,
    ),
  );

  Widget _buildNoteSection(BuildContext context, AppLocalizations loc) {
    return BlocBuilder<HMThemeBloc, HMThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.isDarkMode;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.hearing_test_result_page_note,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                loc.hearing_test_result_page_note_description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, AppLocalizations loc) {
    return BlocBuilder<HearingTestBloc, HearingTestState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            if (state.resultSaved) {
              showDialog(
                context: context,
                builder:
                    (dialogContext) => BlocProvider.value(
                      value: context.read<HearingTestBloc>(),
                      child: AlreadySavedDialog(),
                    ),
              );
            } else if (state.results.hasMissingValues()) {
              showDialog(
                context: context,
                builder:
                    (dialogContext) => BlocProvider.value(
                      value: context.read<HearingTestBloc>(),
                      child: MissingValuesAlertDialog(),
                    ),
              );
            } else {
              context.read<HearingTestBloc>().add(HearingTestSaveResult());
              showDialog(
                context: context,
                builder:
                    (dialogContext) => BlocProvider.value(
                      value: context.read<HearingTestBloc>(),
                      child: SavedDialog(),
                    ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: Colors.blueAccent,
          ),
          child: Text(
            loc.hearing_test_result_page_save_results,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        );
      },
    );
  }
}
