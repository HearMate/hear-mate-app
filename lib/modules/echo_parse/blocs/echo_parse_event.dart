part of 'echo_parse_bloc.dart';

@immutable
sealed class EchoParseEvent {}

class EchoParseChooseAudiogramFileEvent extends EchoParseEvent {}

class EchoParseUploadAudiogramFileToServerEvent extends EchoParseEvent {}

class EchoParseSaveProcessedCsvEvent extends EchoParseEvent {}

class EchoParseReceivedServerResponseEvent extends EchoParseEvent {
  final int statusCode;
  final Map<String, dynamic> audiogramData;

  EchoParseReceivedServerResponseEvent({
    required this.statusCode,
    required this.audiogramData,
  });
}

class EchoParsePrepareForTheNewFileUpload extends EchoParseEvent {}

class EchoParseNavigationDestinationSelected extends EchoParseEvent {
  final int destination;

  EchoParseNavigationDestinationSelected({
    required this.destination,
  });
}