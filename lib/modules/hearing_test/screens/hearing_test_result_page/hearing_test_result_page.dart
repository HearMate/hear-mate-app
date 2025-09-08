import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'alert_dialogs.dart';
import 'widgets/results_header.dart';
import 'widgets/audiogram_section.dart';
import 'widgets/note_section.dart';
import 'widgets/save_button_section.dart';
import 'widgets/description.dart';

class HearingTestResultPage extends StatelessWidget {
  const HearingTestResultPage({super.key});

  Future<bool> _backDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<HearingTestBloc>(),
            child: const CustomAlertDialog(type: AlertType.back),
          ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<HearingTestModuleBloc, HearingTestModuleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: HMAppBar(
            title: loc.hearing_test_result_page_title,
            route: ModalRoute.of(context)?.settings.name ?? "",
            customBackRoute: '/hearing_test/welcome',
            onBackPressed:
                state.resultsSaved ? null : () => _backDialog(context),
          ),
          body: SafeArea(
            child: Column(
              children: [
                ResultsHeader(theme: theme),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AudiogramSection(
                          theme: theme,
                          leftEarData: state.results.leftEarResults,
                          rightEarData: state.results.rightEarResults,
                          leftEarMaskedData:
                              state.results.leftEarResultsMasked.every(
                                    (elem) => elem == null,
                                  )
                                  ? null
                                  : state.results.leftEarResultsMasked,
                          rightEarMaskedData:
                              state.results.rightEarResultsMasked.every(
                                    (elem) => elem == null,
                                  )
                                  ? null
                                  : state.results.rightEarResultsMasked,
                        ),
                        NoteSection(theme: theme),
                        const SizedBox(height: 32),
                        AudiogramDescription(theme: theme),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                SaveButtonSection(theme: theme),
              ],
            ),
          ),
        );
      },
    );
  }
}
