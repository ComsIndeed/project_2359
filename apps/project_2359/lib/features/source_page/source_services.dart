import 'package:project_2359/core/ai_helpers.dart';

class SourceServices {
  SourceServices._();

  static Stream<String> indexExtractedText({
    required String extractedText,
    required String sourceId,
  }) {
    final stream = AiHelpers.indexExtractedText(extractedText);
    return stream;
  }
}
