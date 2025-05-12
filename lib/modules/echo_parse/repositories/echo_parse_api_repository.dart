import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';


class EchoParseApiRepository {
  static const String uploadUrl = "https://audiogram-reader-1.onrender.com/upload-image";

  Future<FilePickerResult?> chooseAudiogramFileForUpload() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
  }

  Future<Map<String, dynamic>> postAudiogramFileToServer(Uint8List image, String fileName) async {
    var uri = Uri.parse(uploadUrl);

    var request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes('image', image, filename: fileName),
      );

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      Map<String, dynamic> audiogramData = jsonDecode(responseBody);
      if (kDebugMode) {
        debugPrint("Response: $audiogramData");
      }

      return {
        "statusCode": response.statusCode,
        "audiogramData": audiogramData,
      };
    } catch (e) {
      throw Exception("Error sending image: $e");
    }
  }
}
