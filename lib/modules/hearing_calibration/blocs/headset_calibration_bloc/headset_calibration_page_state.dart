part of 'headset_calibration_page_bloc.dart';

abstract class HeadsetCalibrationState {
  final int selectedFrequency;
  final String dbValue;
  final bool leftEarOnly;
  final bool isPlaying;

  const HeadsetCalibrationState({
    required this.selectedFrequency,
    required this.dbValue,
    required this.leftEarOnly,
    required this.isPlaying,
  });
}

class HeadsetCalibrationInitial extends HeadsetCalibrationState {
  HeadsetCalibrationInitial()
    : super(
        selectedFrequency: 1000,
        dbValue: '50',
        leftEarOnly: false,
        isPlaying: false,
      );
}

class HeadsetCalibrationUpdated extends HeadsetCalibrationState {
  const HeadsetCalibrationUpdated({
    required int selectedFrequency,
    required String dbValue,
    required bool leftEarOnly,
    required bool isPlaying,
  }) : super(
         selectedFrequency: selectedFrequency,
         dbValue: dbValue,
         leftEarOnly: leftEarOnly,
         isPlaying: isPlaying,
       );
}
