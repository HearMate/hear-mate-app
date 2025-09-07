part of 'headphones_calibration_module_bloc.dart';

abstract class HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleStart
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleNavigateToExit
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

class HeadphonesCalibrationModuleRemoveReferenceHeadphone
    extends HeadphonesCalibrationModuleEvent {
  final HeadphonesModel headphone;
  HeadphonesCalibrationModuleRemoveReferenceHeadphone(this.headphone);
}

class HeadphonesCalibrationModuleSelectTargetHeadphone
    extends HeadphonesCalibrationModuleEvent {
  final HeadphonesModel headphone;
  HeadphonesCalibrationModuleSelectTargetHeadphone(this.headphone);
}

class HeadphonesCalibrationModuleRemoveTargetHeadphone
    extends HeadphonesCalibrationModuleEvent {
  final HeadphonesModel headphone;
  HeadphonesCalibrationModuleRemoveTargetHeadphone(this.headphone);
}

class HeadphonesCalibrationModuleAddHeadphoneFromSearch
    extends HeadphonesCalibrationModuleEvent {
  final HeadphonesModel headphone;

  HeadphonesCalibrationModuleAddHeadphoneFromSearch(this.headphone);
}

class HeadphonesCalibrationModuleLoadHeadphones
    extends HeadphonesCalibrationModuleEvent {}

class HeadphonesCalibrationModuleTestCompleted
    extends HeadphonesCalibrationModuleEvent {
  final HearingTestResult results;

  HeadphonesCalibrationModuleTestCompleted({required this.results});
}
