import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/ocr_space_response.dart';

class OcrSpaceService {
  static const String _baseUrl = 'https://api.ocr.space/parse/image';

  /// Performs OCR on a local image file using OCR.space API.
  /// [apiKey] is your OCR.space API key.
  /// [imageFile] is the File object of the image to process.
  /// [language] is the OCR language (default: 'eng').
  /// [ocrEngine] is the engine to use ('1' or '2').
  Future<OcrSpaceResponse> processImage({
    required String apiKey,
    required File imageFile,
    String language = 'eng',
    String ocrEngine = '2', // Engine 2 is usually better for coordinates
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

    // Headers
    request.headers['apikey'] = apiKey;

    // Parameters
    request.fields['language'] = language;
    request.fields['isOverlayRequired'] = 'true';
    request.fields['OCREngine'] = ocrEngine;
    request.fields['scale'] = 'true';
    request.fields['detectOrientation'] = 'true';

    // File
    final fileStream = http.ByteStream(imageFile.openRead());
    final length = await imageFile.length();
    final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      length,
      filename: imageFile.path.split(Platform.pathSeparator).last,
    );
    request.files.add(multipartFile);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OcrSpaceResponse.fromJson(jsonResponse);
      } else {
        return OcrSpaceResponse(
          parsedResults: [],
          ocrExitCode: 0,
          isErroredOnProcessing: true,
          errorMessage: 'HTTP Error: ${response.statusCode}',
          errorDetails: response.body,
        );
      }
    } catch (e) {
      return OcrSpaceResponse(
        parsedResults: [],
        ocrExitCode: 0,
        isErroredOnProcessing: true,
        errorMessage: 'Exception occurred',
        errorDetails: e.toString(),
      );
    }
  }
}
