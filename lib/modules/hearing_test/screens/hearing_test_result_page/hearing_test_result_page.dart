import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/widgets/audiogram_chart/audiogram_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/alert_dialogs.dart';

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
          body: SafeArea(
            child: Column(
              children: [
                // Hero Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.08),
                        theme.colorScheme.primary.withValues(alpha: 0.02),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        loc.hearing_test_result_page_your_results,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Test ukończony pomyślnie",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.8,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // Instructions Section
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.03,
                            ),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),

                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Twój audiogram",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Instruction Text
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Text(
                            loc.hearing_test_result_page_instruction,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Audiogram Chart Section
                        Container(
                          margin: EdgeInsets.only(bottom: 32.0, top: 12.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.show_chart,
                                      color: theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Wykres słuchu",
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 32,
                                  ),
                                  child: AudiogramChart(
                                    leftEarData: state.results.leftEarResults,
                                    rightEarData: state.results.rightEarResults,
                                    leftEarMaskedData:
                                        state.results.leftEarResultsMasked
                                                .every((elem) => elem == null)
                                            ? null
                                            : state
                                                .results
                                                .leftEarResultsMasked,
                                    rightEarMaskedData:
                                        state.results.rightEarResultsMasked
                                                .every((elem) => elem == null)
                                            ? null
                                            : state
                                                .results
                                                .rightEarResultsMasked,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Note Section
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Colors.amber.shade700,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loc.hearing_test_result_page_note,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber.shade800,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      loc.hearing_test_result_page_note_description,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.amber.shade700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Save Button Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(color: theme.dividerColor, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: BlocBuilder<HearingTestBloc, HearingTestState>(
                          builder: (context, state) {
                            return FilledButton(
                              onPressed: () {
                                if (state.resultSaved) {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (dialogContext) => BlocProvider.value(
                                          value:
                                              context.read<HearingTestBloc>(),
                                          child: CustomAlertDialog(
                                            type: AlertType.alreadySaved,
                                          ),
                                        ),
                                  );
                                } else if (state.results.hasMissingValues()) {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (dialogContext) => BlocProvider.value(
                                          value:
                                              context.read<HearingTestBloc>(),
                                          child: CustomAlertDialog(
                                            type: AlertType.missingValues,
                                          ),
                                        ),
                                  );
                                } else {
                                  context.read<HearingTestBloc>().add(
                                    HearingTestSaveResult(),
                                  );
                                  showDialog(
                                    context: context,
                                    builder:
                                        (dialogContext) => BlocProvider.value(
                                          value:
                                              context.read<HearingTestBloc>(),
                                          child: CustomAlertDialog(
                                            type: AlertType.saved,
                                          ),
                                        ),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    state.resultSaved
                                        ? Colors.green.shade600
                                        : theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    state.resultSaved
                                        ? Icons.check
                                        : Icons.save,
                                    size: 24,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    state.resultSaved
                                        ? "Wyniki zapisane"
                                        : loc
                                            .hearing_test_result_page_save_results,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Zapisz wyniki aby móc je później przeglądać",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
