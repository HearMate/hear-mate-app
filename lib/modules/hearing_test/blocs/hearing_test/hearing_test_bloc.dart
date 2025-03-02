import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:meta/meta.dart';

part 'hearing_test_event.dart';
part 'hearing_test_state.dart';

class HearingTestBloc extends Bloc<HearingTestEvent, HearingTestState> {
  final HearingTestSoundsPlayerRepository _soundsPlayerRepository;

  final List<double> testFrequencies = [1000, 500, 250, 125, 2000, 4000, 8000];
  int currentFrequencyIndex = 0;
  List<Map<String, dynamic>> testResults = [];

  HearingTestBloc({
    required HearingTestSoundsPlayerRepository
    hearingTestSoundsPlayerRepository,
  }) : _soundsPlayerRepository = hearingTestSoundsPlayerRepository,
       super(HearingTestState()) {
    on<HearingTestStartTest>(_onStartTest);
    on<HearingTestButtonPressed>(_onButtonPressed);
    on<HearingTestButtonReleased>(_onButtonReleased);
    on<HearingTestEndTestEarly>(_onEndTestEarly);

    add(HearingTestStartTest());
  }

  void _onStartTest(
    HearingTestStartTest event,
    Emitter<HearingTestState> emit,
  ) async {}

  void _onButtonPressed(
    HearingTestButtonPressed event,
    Emitter<HearingTestState> emit,
  ) async {
    emit(state.copyWith(isButtonPressed: true));
  }

  void _onButtonReleased(
    HearingTestButtonReleased event,
    Emitter<HearingTestState> emit,
  ) async {
    emit(state.copyWith(isButtonPressed: false));
  }

  void _onEndTestEarly(
    HearingTestEndTestEarly event,
    Emitter<HearingTestState> emit,
  ) {}
}
