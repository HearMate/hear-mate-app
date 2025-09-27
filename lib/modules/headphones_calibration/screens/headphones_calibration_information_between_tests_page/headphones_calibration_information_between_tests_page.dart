import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/headphones_calibration/blocs/headphones_calibration_module/headphones_calibration_module_bloc.dart';
import 'package:hear_mate_app/shared/widgets/hm_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeadphonesCalibrationInformationBetweenTestsPage extends StatelessWidget {
  const HeadphonesCalibrationInformationBetweenTestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: HMAppBar(
        title: l10n.headphones_calibration_information_between_tests_page_title,
        route: ModalRoute.of(context)?.settings.name ?? "",
        hideBackArrow: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Progress indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.headphones_calibration_step_progress("2", "2"),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Main icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.headphones,
                        size: 60,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      l10n.headphones_calibration_great_title,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                l10n.headphones_calibration_between_tests_description_prefix,
                          ),
                          TextSpan(
                            text:
                                context
                                    .read<HeadphonesCalibrationModuleBloc>()
                                    .state
                                    .selectedTargetHeadphone
                                    ?.name ??
                                "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                l10n.headphones_calibration_between_tests_description_suffix,
                          ),
                        ],
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // Action button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    context.read<HeadphonesCalibrationModuleBloc>().add(
                      HeadphonesCalibrationModuleNavigateToSecondTest(),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    l10n.headphones_calibration_continue_button,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
