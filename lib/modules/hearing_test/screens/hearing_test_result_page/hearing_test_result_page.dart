import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
import 'widgets/alert_dialogs.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/header_banner/header_banner.dart';
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
            value: context.read<HearingTestModuleBloc>(),
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
                HeaderBanner(
                  title: loc.hearing_test_result_page_your_results,
                  subtitle: loc.results_header_test_ended_successfully,
                  icon: Icons.show_chart,
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AudiogramSection(
                          theme: Theme.of(context),
                          leftEarData:
                              state.results?.hearingLossLeft ??
                              [], // List<HearingLoss?>
                          rightEarData:
                              state.results?.hearingLossRight ??
                              [], // List<HearingLoss?>
                        ),

                        AudiogramDescription(
                          theme: theme,
                          audiogramDescription:
                              state.results?.audiogramDescription ?? "",
                        ),
                        const SizedBox(height: 32),
                        NoteSection(theme: theme),
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
