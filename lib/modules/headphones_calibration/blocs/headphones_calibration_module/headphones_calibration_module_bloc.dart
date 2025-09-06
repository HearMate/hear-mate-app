import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/featuers/hearing_test/bloc/hearing_test_bloc.dart';
import 'package:hear_mate_app/featuers/hearing_test/models/hearing_test_result.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_model.dart';
import 'package:equatable/equatable.dart';

part 'headphones_calibration_module_event.dart';
part 'headphones_calibration_module_state.dart';

class HeadphonesCalibrationModuleBloc
    extends
        Bloc<
          HeadphonesCalibrationModuleEvent,
          HeadphonesCalibrationModuleState
        > {
  final AppLocalizations l10n;
  final HearingTestBloc hearingTestBloc;

  final _dummyReferenceHeadphones = [
    const HeadphonesModel(name: 'HD 600', manufacturer: 'Sennheiser'),
    const HeadphonesModel(name: 'K701', manufacturer: 'AKG'),
    const HeadphonesModel(name: 'DT 990 Pro', manufacturer: 'Beyerdynamic'),
    const HeadphonesModel(name: 'ATH-M50x', manufacturer: 'Audio-Technica'),
  ];

  final _dummyTargetHeadphones = [
    const HeadphonesModel(name: 'WH-1000XM4', manufacturer: 'Sony'),
    const HeadphonesModel(name: 'AirPods Max', manufacturer: 'Apple'),
    const HeadphonesModel(name: 'QuietComfort 35 II', manufacturer: 'Bose'),
    const HeadphonesModel(
      name: 'Momentum 3 Wireless',
      manufacturer: 'Sennheiser',
    ),
    const HeadphonesModel(name: 'H9i', manufacturer: 'Bang & Olufsen'),
    const HeadphonesModel(name: 'PX7', manufacturer: 'Bowers & Wilkins'),
    const HeadphonesModel(name: 'Elite 85h', manufacturer: 'Jabra'),
  ];

  HeadphonesCalibrationModuleBloc({required this.l10n})
    : hearingTestBloc = HearingTestBloc(l10n: l10n),
      super(HeadphonesCalibrationModuleState()) {
    on<HeadphonesCalibrationModuleStart>(_onStart);
    on<HeadphonesCalibrationModuleNavigateToWelcome>(_onNavigateToWelcome);
    on<HeadphonesCalibrationModuleNavigateToFirstTest>(_onNavigateToFirstTest);
    on<HeadphonesCalibrationModuleNavigateToInformationBetweenTests>(
      _onNavigateToInformationBetweenTests,
    );
    on<HeadphonesCalibrationModuleNavigateToSecondTest>(
      _onNavigateToSecondTest,
    );
    on<HeadphonesCalibrationModuleNavigateToEnd>(_onNavigateToEnd);
    on<HeadphonesCalibrationModuleSelectReferenceHeadphone>(
      _onSelectReferenceHeadphone,
    );
    on<HeadphonesCalibrationModuleSelectTargetHeadphone>(
      _onSelectTargetHeadphone,
    );
    on<HeadphonesCalibrationModuleUpdateSearchQuery>(_onUpdateSearchQuery);
    on<HeadphonesCalibrationModuleTestCompleted>(_onHearingTestCompleted);

    hearingTestBloc.stream.listen((hearingTestState) {
      if (hearingTestState.isTestCompleted) {
        add(
          HeadphonesCalibrationModuleTestCompleted(
            results: hearingTestState.results,
          ),
        );
      }
    });

    add(HeadphonesCalibrationModuleStart());
  }

  void _onStart(
    HeadphonesCalibrationModuleStart event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(HeadphonesCalibrationModuleState());

    emit(
      state.copyWith(
        availableReferenceHeadphones: _dummyReferenceHeadphones,
        availableTargetHeadphones: _dummyTargetHeadphones,
      ),
    );
  }

  void _onNavigateToWelcome(
    HeadphonesCalibrationModuleNavigateToWelcome event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    hearingTestBloc.add(HearingTestInitialize());
    emit(HeadphonesCalibrationModuleState());

    emit(
      state.copyWith(
        availableReferenceHeadphones: _dummyReferenceHeadphones,
        availableTargetHeadphones: _dummyTargetHeadphones,
      ),
    );

    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.welcome));
  }

  void _onNavigateToFirstTest(
    HeadphonesCalibrationModuleNavigateToFirstTest event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.firstTest));
    hearingTestBloc.add(HearingTestStartTest());
  }

  void _onNavigateToInformationBetweenTests(
    HeadphonesCalibrationModuleNavigateToInformationBetweenTests event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(
      state.copyWith(
        currentStep: HeadphonesCalibrationStep.informationBetweenTests,
      ),
    );
  }

  void _onNavigateToSecondTest(
    HeadphonesCalibrationModuleNavigateToSecondTest event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    hearingTestBloc.add(HearingTestInitialize());
    hearingTestBloc.add(HearingTestStartTest());
    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.secondTest));
  }

  void _onNavigateToEnd(
    HeadphonesCalibrationModuleNavigateToEnd event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(currentStep: HeadphonesCalibrationStep.end));
  }

  void _onSelectReferenceHeadphone(
    HeadphonesCalibrationModuleSelectReferenceHeadphone event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(selectedReferenceHeadphone: event.headphone));
  }

  void _onSelectTargetHeadphone(
    HeadphonesCalibrationModuleSelectTargetHeadphone event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(selectedTargetHeadphone: event.headphone));
  }

  void _onUpdateSearchQuery(
    HeadphonesCalibrationModuleUpdateSearchQuery event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onHearingTestCompleted(
    HeadphonesCalibrationModuleTestCompleted event,
    Emitter<HeadphonesCalibrationModuleState> emit,
  ) {
    if (state.currentStep == HeadphonesCalibrationStep.firstTest) {
      emit(
        state.copyWith(
          firstTestResults: event.results,
          currentStep: HeadphonesCalibrationStep.informationBetweenTests,
        ),
      );
    } else if (state.currentStep == HeadphonesCalibrationStep.secondTest) {
      emit(
        state.copyWith(
          secondTestResults: event.results,
          currentStep: HeadphonesCalibrationStep.end,
        ),
      );
    }
  }
}
