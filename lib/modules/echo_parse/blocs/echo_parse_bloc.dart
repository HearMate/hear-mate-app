import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hear_mate_app/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/repositories/echo_parse_api_repository.dart';

part 'echo_parse_event.dart';
part 'echo_parse_state.dart';

class EchoParseBloc extends Bloc<EchoParseEvent, EchoParseState> {
  final EchoParseApiRepository repository;

  EchoParseBloc({required this.repository}) : super(EchoParseState()) {
    on<EchoParseChooseAudiogramFileEvent>(_onChooseAudiogramFile);
    on<EchoParseUploadAudiogramFileToServerEvent>(_onSendAudiogramToServer);
    on<EchoParseReceivedServerResponseEvent>(_onReceivedServerResponse);
    on<EchoParseSaveProcessedCsvEvent>(_onSaveProcessedCsv);
    on<EchoParsePrepareForTheNewFileUpload>(_onPrepareForTheNewFile);
    on<EchoParseNavigationDestinationSelected>(
      _onNavigationDestinationSelected,
    );
  }

  Future<void> _onNavigationDestinationSelected(
    EchoParseNavigationDestinationSelected event,
    Emitter<EchoParseState> emit,
  ) async {
    emit(state.copyWith(navigationDestinationSelected: event.destination));
  }

  Future<void> _onPrepareForTheNewFile(
    EchoParsePrepareForTheNewFileUpload event,
    Emitter<EchoParseState> emit,
  ) async {
    emit(state.clearFileDataBeforeNewFile());
  }

  Future<void> _onChooseAudiogramFile(
    EchoParseChooseAudiogramFileEvent event,
    Emitter<EchoParseState> emit,
  ) async {
    var result = await repository.chooseAudiogramFileForUpload();

    if (result != null && result.files.single.bytes != null) {
      emit(
        state.copyWith(
          fileName: result.files.single.name,
          image: result.files.single.bytes,
          nextFile: false,
        ),
      );
    } else {
      HMLogger.print("No file selected or file is empty.");
    }
  }

  Future<void> _onSendAudiogramToServer(
    EchoParseUploadAudiogramFileToServerEvent event,
    Emitter<EchoParseState> emit,
  ) async {
    if (state.image != null) {
      try {
        var response = await repository.postAudiogramFileToServer(
          state.image!,
          state.fileName,
        );

        // Dispatch the EchoParseResult event with the response data
        add(
          EchoParseReceivedServerResponseEvent(
            statusCode: response["statusCode"],
            audiogramData: response["audiogramData"],
          ),
        );
      } catch (e) {
        HMLogger.print("$e");
      }
    }
  }

  Future<void> _onReceivedServerResponse(
    EchoParseReceivedServerResponseEvent event,
    Emitter<EchoParseState> emit,
  ) async {
    emit(
      state.copyWith(
        isResultReady: event.statusCode == 200,
        audiogramData: event.audiogramData,
      ),
    );
  }

  Future<void> _onSaveProcessedCsv(
    EchoParseSaveProcessedCsvEvent event,
    Emitter<EchoParseState> emit,
  ) async {
    final data = state.audiogramData;

    if (data.isEmpty) {
      HMLogger.print("No audiogram data available.");
      return;
    }
    final timestamp = DateTime.now()
        .toIso8601String()
        .split('T')
        .join('_')
        .split('.')
        .first
        .replaceAll(':', '-');
    final defaultFileName = 'audiogram_result_$timestamp.csv';
    final csv = _generateAudiogramCsv(data);

    try {
      final baseDir = await getApplicationSupportDirectory();
      final echoParseDir = Directory('${baseDir.path}/EchoParse');
      if (!await echoParseDir.exists()) {
        await echoParseDir.create(recursive: true);
      }
      final internalPath = '${echoParseDir.path}/$defaultFileName';
      final internalFile = File(internalPath);
      await internalFile.writeAsString(csv);
      HMLogger.print("CSV saved internally at: $internalPath");

      Directory? userDir;

      if (Platform.isAndroid) {
        userDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        userDir = await getApplicationDocumentsDirectory();
      } else {
        final outputPath = await FilePicker.platform.saveFile(
          dialogTitle: 'Save as...',
          fileName: defaultFileName,
          type: FileType.custom,
          allowedExtensions: ['csv'],
        );

        if (outputPath != null) {
          final userFile = File(outputPath);
          await userFile.writeAsString(csv);
          HMLogger.print("CSV saved to user-selected path: $outputPath");
        } else {
          HMLogger.print("User canceled save dialog.");
        }
        return;
      }

      final userFilePath = '${userDir.path}/$defaultFileName';
      final userFile = File(userFilePath);
      await userFile.writeAsString(csv);
      HMLogger.print("CSV saved in user directory: $userFilePath");
    } catch (e) {
      HMLogger.print("Error saving CSV file: $e");
    }
  }

  String _generateAudiogramCsv(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    buffer.writeln("Ear,Frequency_Hz,Hearing_Level_dB");

    for (final ear in ['Left Ear', 'Right Ear']) {
      final Option<Map<String, dynamic>> earDataOption = Option.fromNullable(
        data[ear] as Map<String, dynamic>?,
      );

      earDataOption.match(() => {HMLogger.print('No data found for $ear')}, (
        earData,
      ) {
        earData.forEach((frequency, level) {
          buffer.writeln('$ear,$frequency,$level');
        });
      });
    }

    return buffer.toString();
  }
}
