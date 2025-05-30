part of 'echo_parse_bloc.dart';

class EchoParseState {
  final bool isResultReady;
  final String fileName;
  final Uint8List? image;
  final int statusCode;
  // this format should be changed after final backend version, additionally it should be unified with the hearing test
  final Map<String, dynamic> audiogramData;
  final bool nextFile;
  

  EchoParseState({
    this.isResultReady = false,
    this.fileName = "",
    this.image,
    this.statusCode = 0,
    this.audiogramData = const {},
    this.nextFile = true,
  });

  

  EchoParseState copyWith({
    bool? isResultReady,
    String? fileName,
    Uint8List? image,
    int? statusCode,
    Map<String, dynamic>? audiogramData,
    bool? nextFile
  }) {
    return EchoParseState(
      isResultReady: isResultReady ?? this.isResultReady,
      fileName: fileName ?? this.fileName,
      image: image ?? this.image,
      statusCode: statusCode ?? this.statusCode,
      audiogramData: audiogramData ?? this.audiogramData,
      nextFile: nextFile ?? this.nextFile,
    );
  }

  EchoParseState resetState() {
    return EchoParseState();
  }
}
