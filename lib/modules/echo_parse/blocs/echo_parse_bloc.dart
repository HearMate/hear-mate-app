import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hear_mate_app/modules/echo_parse/repositories/echo_parse_api_repository.dart';
import 'package:meta/meta.dart';

part 'echo_parse_event.dart';
part 'echo_parse_state.dart';

class EchoParseBloc extends Bloc<EchoParseEvent, EchoParseState> {
  final EchoParseApiRepository repository;

  EchoParseBloc({required this.repository}) : super(EchoParseState()) {
    on<EchoParseChooseAudiogramFileEvent>(_onChooseAudiogramFile);
    on<EchoParseUploadAudiogramFileToServerEvent>(_onSendAudiogramToServer);
    on<EchoParseReceivedServerResponseEvent>(_onReceivedServerResponse);
  }

  Future<void> _onChooseAudiogramFile(EchoParseChooseAudiogramFileEvent event, Emitter<EchoParseState> emit) async {
    var result = await repository.chooseAudiogramFileForUpload();

    if (result != null && result.files.single.bytes != null) {
      emit(state.copyWith(
        fileName: result.files.single.name,
        image: result.files.single.bytes,
      ));
    } else if (kDebugMode) {
        debugPrint("No file selected or file is empty.");
      }
    }
  }

  Future<void> _onSendAudiogramToServer(EchoParseUploadAudiogramFileToServerEvent event, Emitter<EchoParseState> emit) async {
    if (state.image != null) {
      try {
        var response = await repository.postAudiogramFileToServer(state.image!, state.fileName);

        // Dispatch the EchoParseResult event with the response data
        add(EchoParseReceivedServerResponseEvent(
          statusCode: response["statusCode"],
          audiogramData: response["audiogramData"],
        ));
      } catch (e) {
        if (kDebugMode) {
          debugPrint("$e");
        }
      }
    }
  }

  Future<void> _onReceivedServerResponse(EchoParseReceivedServerResponseEvent event, Emitter<EchoParseState> emit) async {
    emit(state.copyWith(
      isResultReady: event.statusCode == 200,
      audiogramData: event.audiogramData,
    ));
  }
}
