part of 'headset_calibration_page_bloc.dart';

abstract class HeadsetCalibrationEvent {}

class FrequencyChanged extends HeadsetCalibrationEvent {
  final int frequency;
  FrequencyChanged(this.frequency);
}

class DbChanged extends HeadsetCalibrationEvent {
  final String dbValue;
  DbChanged(this.dbValue);
}

class LeftEarOnlyChanged extends HeadsetCalibrationEvent {
  final bool leftEarOnly;
  LeftEarOnlyChanged(this.leftEarOnly);
}

class PlayPressed extends HeadsetCalibrationEvent {}

class StopPressed extends HeadsetCalibrationEvent {}
