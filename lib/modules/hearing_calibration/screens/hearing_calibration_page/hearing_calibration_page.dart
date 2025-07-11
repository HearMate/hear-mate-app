import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/hearing_calibration/blocs/headset_calibration_bloc/headset_calibration_page_bloc.dart';
import 'package:hear_mate_app/repositories/sounds_player_repository.dart';

class HeadsetCalibrationPage extends StatelessWidget {
  const HeadsetCalibrationPage({super.key});

  static final List<int> _frequencies = [125, 250, 500, 1000, 2000, 4000, 8000];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => HeadsetCalibrationBloc(
            RepositoryProvider.of<SoundsPlayerRepository>(context),
          ),
      child: Scaffold(
        appBar: AppBar(title: Text('Hearing Calibration')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<HeadsetCalibrationBloc, HeadsetCalibrationState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select Frequency (Hz)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  DropdownButton<int>(
                    value: state.selectedFrequency,
                    items:
                        _frequencies
                            .map(
                              (freq) => DropdownMenuItem<int>(
                                value: freq,
                                child: Text('$freq Hz'),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        context.read<HeadsetCalibrationBloc>().add(
                          FrequencyChanged(value),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Enter Volume (dB)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    child: TextField(
                      controller: TextEditingController(text: state.dbValue)
                        ..selection = TextSelection.collapsed(
                          offset: state.dbValue.length,
                        ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixText: 'dB',
                      ),
                      onChanged: (val) {
                        context.read<HeadsetCalibrationBloc>().add(
                          DbChanged(val),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: state.leftEarOnly,
                        onChanged: (val) {
                          context.read<HeadsetCalibrationBloc>().add(
                            LeftEarOnlyChanged(val ?? false),
                          );
                        },
                      ),
                      const Text('Play to left ear only'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            state.isPlaying
                                ? null
                                : () => context
                                    .read<HeadsetCalibrationBloc>()
                                    .add(PlayPressed()),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(140, 48),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Play Sound'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed:
                            state.isPlaying
                                ? () => context
                                    .read<HeadsetCalibrationBloc>()
                                    .add(StopPressed())
                                : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(140, 48),
                          backgroundColor: Colors.red,
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Stop Sound'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
