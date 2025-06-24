import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/repositories/sounds_player_repository.dart';
import 'package:meta/meta.dart';

part 'headset_calibration_page_event.dart';
part 'headset_calibration_page_state.dart';

class HeadsetCalibrationBloc
    extends Bloc<HeadsetCalibrationEvent, HeadsetCalibrationState> {
  final SoundsPlayerRepository soundsRepository;

  HeadsetCalibrationBloc(this.soundsRepository)
    : super(HeadsetCalibrationInitial()) {
    on<FrequencyChanged>((event, emit) {
      emit(
        HeadsetCalibrationUpdated(
          selectedFrequency: event.frequency,
          dbValue: state.dbValue,
          leftEarOnly: state.leftEarOnly,
          isPlaying: state.isPlaying,
        ),
      );
    });
    on<DbChanged>((event, emit) {
      emit(
        HeadsetCalibrationUpdated(
          selectedFrequency: state.selectedFrequency,
          dbValue: event.dbValue,
          leftEarOnly: state.leftEarOnly,
          isPlaying: state.isPlaying,
        ),
      );
    });
    on<LeftEarOnlyChanged>((event, emit) {
      emit(
        HeadsetCalibrationUpdated(
          selectedFrequency: state.selectedFrequency,
          dbValue: state.dbValue,
          leftEarOnly: event.leftEarOnly,
          isPlaying: state.isPlaying,
        ),
      );
    });
    on<PlayPressed>((event, emit) async {
      final double decibels = double.tryParse(state.dbValue) ?? 50.0;
      await soundsRepository.playSound(
        state.selectedFrequency,
        decibels: decibels,
        leftEarOnly: state.leftEarOnly,
      );
      emit(
        HeadsetCalibrationUpdated(
          selectedFrequency: state.selectedFrequency,
          dbValue: state.dbValue,
          leftEarOnly: state.leftEarOnly,
          isPlaying: true,
        ),
      );
    });
    on<StopPressed>((event, emit) async {
      await soundsRepository.stopSound();
      emit(
        HeadsetCalibrationUpdated(
          selectedFrequency: state.selectedFrequency,
          dbValue: state.dbValue,
          leftEarOnly: state.leftEarOnly,
          isPlaying: false,
        ),
      );
    });
  }
}
