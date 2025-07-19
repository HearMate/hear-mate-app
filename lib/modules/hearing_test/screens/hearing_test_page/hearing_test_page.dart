import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/hearing_test_result_page.dart';

class HearingTestPage extends StatelessWidget {
  const HearingTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: BlocConsumer<HearingTestBloc, HearingTestState>(
        listener: (context, state) {
          if (state is HearingTestCompleted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<HearingTestBloc>(),
                      child: HearingTestResultPage(),
                    ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 56.0, 12.0, 12.0),
                  child: Text(
                    l10n.hearing_test_test_page_instruction,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Center(
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                      width:
                          state.isButtonPressed
                              ? 162.5
                              : 150, // Adjust size on press
                      height:
                          state.isButtonPressed
                              ? 162.5
                              : 150, // Adjust size on press
                      decoration: BoxDecoration(
                        color:
                            state.isButtonPressed
                                ? Colors.blue.shade800
                                : Colors.blueAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                state.isButtonPressed
                                    ? 26
                                    : 24, // Synchronize text size
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text(l10n.hearing_test_test_page_button_label),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: TextButton(
                    onPressed: () {
                      context.read<HearingTestBloc>().add(
                        HearingTestEndTestEarly(),
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: context.read<HearingTestBloc>(),
                                child: HearingTestResultPage(),
                              ),
                        ),
                      );
                    },
                    child: Text(
                      l10n.hearing_test_test_page_end,
                      style: TextStyle(color: Colors.red, fontSize: 16),
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
