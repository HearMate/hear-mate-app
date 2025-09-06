part of 'headphones_calibration_module_bloc.dart';

abstract class HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleStart
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleNavigateToWelcome
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleNavigateToFirstTest
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleNavigateToInformationBetweenTests
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleNavigateToSecondTest
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleNavigateToEnd
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleSelectReferenceHeadphone
    extends HeadphonesCalibrationModuleEvent {
  final HeadphonesModel headphone;
  HeadphonesCalibrationModuleSelectReferenceHeadphone(this.headphone);
}

class HeadphonesCalibrationModuleSelectTargetHeadphone
    extends HeadphonesCalibrationModuleEvent {
  final HeadphonesModel headphone;
  HeadphonesCalibrationModuleSelectTargetHeadphone(this.headphone);
}

class HeadphonesCalibrationModuleUpdateSearchQuery
    extends HeadphonesCalibrationModuleEvent {
  final String query;
  HeadphonesCalibrationModuleUpdateSearchQuery(this.query);
}

class HeadphonesCalibrationModuleLoadHeadphones
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleTestCompleted
    extends HeadphonesCalibrationModuleEvent {
  final HearingTestResult results;

  HeadphonesCalibrationModuleTestCompleted({required this.results});
}
