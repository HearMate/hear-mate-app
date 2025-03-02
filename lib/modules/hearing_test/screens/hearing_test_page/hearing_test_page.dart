import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';

class HearingTestPage extends StatelessWidget {
  const HearingTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(enableBackButton: true),
      body: BlocBuilder<HearingTestBloc, HearingTestState>(
        builder: (context, state) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Press and hold the button when you can hear the sound. Release when you can no longer hear it.',
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
                          color: Colors.black.withOpacity(0.2),
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
                        child: const Text('HOLD'),
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
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/hearing_test/result',
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'End Test Early',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
