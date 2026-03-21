class OcrSpaceResponse {
  final List<ParsedResult> parsedResults;
  final int ocrExitCode;
  final bool isErroredOnProcessing;
  final String? errorMessage;
  final String? errorDetails;

  OcrSpaceResponse({
    required this.parsedResults,
    required this.ocrExitCode,
    required this.isErroredOnProcessing,
    this.errorMessage,
    this.errorDetails,
  });

  factory OcrSpaceResponse.fromJson(Map<String, dynamic> json) {
    return OcrSpaceResponse(
      parsedResults: (json['ParsedResults'] as List? ?? [])
          .map((e) => ParsedResult.fromJson(e))
          .toList(),
      ocrExitCode: json['OCRExitCode'] as int? ?? 0,
      isErroredOnProcessing: json['IsErroredOnProcessing'] as bool? ?? true,
      errorMessage: json['ErrorMessage']?.toString(),
      errorDetails: json['ErrorDetails']?.toString(),
    );
  }
}

class ParsedResult {
  final TextOverlay? textOverlay;
  final String parsedText;
  final String? errorMessage;
  final String? errorDetails;

  ParsedResult({
    this.textOverlay,
    required this.parsedText,
    this.errorMessage,
    this.errorDetails,
  });

  factory ParsedResult.fromJson(Map<String, dynamic> json) {
    return ParsedResult(
      textOverlay: json['TextOverlay'] != null
          ? TextOverlay.fromJson(json['TextOverlay'])
          : null,
      parsedText: json['ParsedText']?.toString() ?? '',
      errorMessage: json['ErrorMessage']?.toString(),
      errorDetails: json['ErrorDetails']?.toString(),
    );
  }
}

class TextOverlay {
  final List<OcrLine> lines;
  final bool hasOverlay;
  final String? message;

  TextOverlay({required this.lines, required this.hasOverlay, this.message});

  factory TextOverlay.fromJson(Map<String, dynamic> json) {
    return TextOverlay(
      lines: (json['Lines'] as List? ?? [])
          .map((e) => OcrLine.fromJson(e))
          .toList(),
      hasOverlay: json['HasOverlay'] as bool? ?? false,
      message: json['Message']?.toString(),
    );
  }
}

class OcrLine {
  final List<OcrWord> words;
  final double? maxHeight;
  final double? minTop;

  OcrLine({required this.words, this.maxHeight, this.minTop});

  factory OcrLine.fromJson(Map<String, dynamic> json) {
    return OcrLine(
      words: (json['Words'] as List? ?? [])
          .map((e) => OcrWord.fromJson(e))
          .toList(),
      maxHeight: (json['MaxHeight'] as num?)?.toDouble(),
      minTop: (json['MinTop'] as num?)?.toDouble(),
    );
  }
}

class OcrWord {
  final String wordText;
  final double left;
  final double top;
  final double height;
  final double width;

  OcrWord({
    required this.wordText,
    required this.left,
    required this.top,
    required this.height,
    required this.width,
  });

  factory OcrWord.fromJson(Map<String, dynamic> json) {
    return OcrWord(
      wordText: json['WordText']?.toString() ?? '',
      left: (json['Left'] as num? ?? 0).toDouble(),
      top: (json['Top'] as num? ?? 0).toDouble(),
      height: (json['Height'] as num? ?? 0).toDouble(),
      width: (json['Width'] as num? ?? 0).toDouble(),
    );
  }
}
