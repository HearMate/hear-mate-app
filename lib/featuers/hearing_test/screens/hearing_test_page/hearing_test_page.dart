import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/featuers/hearing_test/bloc/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/hearing_test_result_page.dart';

class HearingTestPage extends StatelessWidget {
  const HearingTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<HearingTestBloc, HearingTestState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // Main Clickable Area with Header positioned in the middle
                Expanded(
                  child: GestureDetector(
                    onTapDown:
                        (_) => context.read<HearingTestBloc>().add(
                          HearingTestButtonPressed(),
                        ),
                    onTapUp:
                        (_) => context.read<HearingTestBloc>().add(
                          HearingTestButtonReleased(),
                        ),
                    onTapCancel:
                        () => context.read<HearingTestBloc>().add(
                          HearingTestButtonReleased(),
                        ),
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          // Top spacer
                          const Expanded(flex: 2, child: SizedBox()),
                          // Header in center
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              l10n.hearing_test_test_page_instruction,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.7,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 100),

                          // Button in center
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeInOut,
                            width: state.isButtonPressed ? 120 : 100,
                            height: state.isButtonPressed ? 120 : 100,
                            decoration: BoxDecoration(
                              color:
                                  state.isButtonPressed
                                      ? theme.colorScheme.primary.withValues(
                                        alpha: 0.8,
                                      )
                                      : theme.colorScheme.primary.withValues(
                                        alpha: 0.6,
                                      ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: state.isButtonPressed ? 20 : 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Transform.translate(
                                offset: const Offset(-2, -2),
                                child: Icon(
                                  Icons.touch_app,
                                  color: theme.colorScheme.onPrimary,
                                  size: state.isButtonPressed ? 40 : 36,
                                ),
                              ),
                            ),
                          ),

                          // Bottom spacer
                          const Expanded(flex: 2, child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ),

                // Debug Section (only in debug mode)
                if (kDebugMode)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Debug Shortcuts",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    () => context.read<HearingTestBloc>().add(
                                      HearingTestDebugEarLeftPartial(),
                                    ),
                                child: const Text("L Partial"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    () => context.read<HearingTestBloc>().add(
                                      HearingTestDebugEarRightPartial(),
                                    ),
                                child: const Text("R Partial"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    () => context.read<HearingTestBloc>().add(
                                      HearingTestDebugBothEarsFull(),
                                    ),
                                child: const Text("Both"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Bottom Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      context.read<HearingTestBloc>().add(
                        HearingTestCompleted(),
                      );
                    },
                    icon: Icon(
                      Icons.stop,
                      color: Colors.red.shade600,
                      size: 18,
                    ),
                    label: Text(
                      l10n.hearing_test_page_end_test_early,
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
