import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

// ── Data classes ─────────────────────────────────────────────────────────────

/// Metadata returned by the generate-material function after streaming completes.
class GenerateMaterialMetadata {
  final int inputTokens;
  final int outputTokens;
  final int totalTokens;

  const GenerateMaterialMetadata({
    required this.inputTokens,
    required this.outputTokens,
    required this.totalTokens,
  });

  factory GenerateMaterialMetadata.fromJson(Map<String, dynamic> json) {
    return GenerateMaterialMetadata(
      inputTokens: (json['inputTokens'] as num).toInt(),
      outputTokens: (json['outputTokens'] as num).toInt(),
      totalTokens: (json['totalTokens'] as num).toInt(),
    );
  }

  @override
  String toString() =>
      'GenerateMaterialMetadata(in=$inputTokens, out=$outputTokens, total=$totalTokens)';
}

/// A single study material item parsed from the LLM JSON stream.
///
/// Fields are mutable because they are populated progressively as the
/// streaming parser yields chunks.
class StreamedStudyCard {
  String? sourceId;
  String? type;

  // flashcard
  String frontContent = '';
  String backContent = '';

  // free-text
  String question = '';
  String criteria = '';

  // multiple-choice-question
  List<String> choices = [];
  int? correctAnswerIndex;

  DateTime? startTime;
  DateTime? endTime;

  int get totalCharacters {
    if (type == 'flashcard') {
      return frontContent.length + backContent.length;
    }
    if (type == 'multiple-choice-question') {
      return question.length + choices.fold(0, (p, c) => p + c.length);
    }
    return question.length + criteria.length;
  }
}

/// A single event emitted by [AiHelpers.generateMaterial].
///
/// Either a text [chunk] from the LLM or the final [metadata] summary.
sealed class GenerateMaterialEvent {}

class GenerateMaterialChunk extends GenerateMaterialEvent {
  final String text;
  GenerateMaterialChunk(this.text);
}

class GenerateMaterialMeta extends GenerateMaterialEvent {
  final GenerateMaterialMetadata metadata;
  GenerateMaterialMeta(this.metadata);
}

// ── Helper class ─────────────────────────────────────────────────────────────

/// Helper class for AI-related Supabase Edge Function calls.
class AiHelpers {
  AiHelpers._();

  /// Invokes the `index-extracted-text` edge function with the given
  /// [extractedText] and returns a [Stream<String>] of LLM output chunks.
  ///
  /// The edge function streams back server-sent events (SSE), where each
  /// chunk is a `data: "<text>"\n\n` line. This method parses those events
  /// and yields the text content as individual [String] values.
  ///
  /// The stream completes when the server sends `data: [DONE]\n\n`.
  ///
  /// Example:
  /// ```dart
  /// final stream = AiHelpers.indexExtractedText('Some extracted PDF text...');
  /// await for (final chunk in stream) {
  ///   print(chunk); // prints each streamed text fragment
  /// }
  /// ```
  static Stream<String> indexExtractedText(String extractedText) async* {
    final supabase = Supabase.instance.client;

    // Call the edge function — the response is an SSE stream
    final response = await supabase.functions.invoke(
      'index-extracted-text',
      body: {'input': extractedText},
    );

    // The response data comes back as a String from the SSE stream.
    // supabase_flutter >= 2.x returns the raw response body.
    final rawData = response.data;

    Stream<String> linesStream;

    if (rawData is String) {
      // Parse SSE lines from the complete response
      linesStream = Stream.fromIterable(const LineSplitter().convert(rawData));
    } else if (rawData is List<int>) {
      // Binary response — decode as UTF-8 then parse
      linesStream = Stream.fromIterable(
        const LineSplitter().convert(utf8.decode(rawData)),
      );
    } else if (rawData is Stream<List<int>>) {
      // Streamed response (ByteStream)
      linesStream = rawData
          .transform(utf8.decoder)
          .transform(const LineSplitter());
    } else {
      throw Exception(
        'Unexpected response type from index-extracted-text: '
        '${rawData.runtimeType}',
      );
    }

    yield* _parseSseLines(linesStream);
  }

  /// Parses an SSE-formatted string and yields the text content from each
  /// `data:` line. Stops when it encounters `[DONE]`.
  static Stream<String> _parseSseLines(Stream<String> lines) async* {
    await for (final line in lines) {
      if (!line.startsWith('data: ')) continue;

      final payload = line.substring(6).trim(); // strip "data: "

      if (payload == '[DONE]') break;

      try {
        // Each payload is a JSON-encoded string, e.g. "\"Hello\""
        final decoded = jsonDecode(payload);
        if (decoded is String) {
          yield decoded;
        } else if (decoded is Map && decoded.containsKey('error')) {
          throw Exception(decoded['error']);
        }
      } catch (e) {
        if (e is FormatException) {
          // If it's not valid JSON, yield the raw payload
          yield payload;
        } else {
          rethrow;
        }
      }
    }
  }

  /// Invokes the `generate-material` edge function and returns a stream of
  /// [GenerateMaterialEvent]s.
  ///
  /// Each [GenerateMaterialChunk] carries a text fragment from the LLM.
  /// The final [GenerateMaterialMeta] carries usage metadata (token counts).
  ///
  /// Example:
  /// ```dart
  /// await for (final event in AiHelpers.generateMaterial(texts, prefs)) {
  ///   switch (event) {
  ///     case GenerateMaterialChunk(:final text) => buffer.write(text);
  ///     case GenerateMaterialMeta(:final metadata) => print(metadata);
  ///   }
  /// }
  /// ```
  static Stream<GenerateMaterialEvent> generateMaterial({
    required List<Map<String, String>> extractedTexts,
    required Map<String, String> preferences,
  }) async* {
    final supabase = Supabase.instance.client;

    final response = await supabase.functions.invoke(
      'generate-material',
      body: {'extractedTexts': extractedTexts, 'preferences': preferences},
    );

    final rawData = response.data;
    Stream<String> linesStream;

    if (rawData is String) {
      linesStream = Stream.fromIterable(const LineSplitter().convert(rawData));
    } else if (rawData is List<int>) {
      linesStream = Stream.fromIterable(
        const LineSplitter().convert(utf8.decode(rawData)),
      );
    } else if (rawData is Stream<List<int>>) {
      linesStream = rawData
          .transform(utf8.decoder)
          .transform(const LineSplitter());
    } else {
      throw Exception(
        'Unexpected response type from generate-material: '
        '${rawData.runtimeType}',
      );
    }

    yield* _parseSseEvents(linesStream);
  }

  /// Parses SSE lines and yields [GenerateMaterialEvent]s.
  ///
  /// Text chunks are wrapped in [GenerateMaterialChunk].
  /// The optional trailing `[METADATA]:` line is parsed into [GenerateMaterialMeta].
  static Stream<GenerateMaterialEvent> _parseSseEvents(
    Stream<String> lines,
  ) async* {
    await for (final line in lines) {
      if (!line.startsWith('data: ')) continue;

      final payload = line.substring(6).trim();

      if (payload == '[DONE]') continue; // metadata may follow, keep going

      try {
        final decoded = jsonDecode(payload);
        if (decoded is String) {
          // Check for the metadata trailer embedded in the text chunk
          if (decoded.startsWith('\n[METADATA]:')) {
            final jsonPart = decoded.substring('\n[METADATA]:'.length);
            final meta = GenerateMaterialMetadata.fromJson(
              jsonDecode(jsonPart) as Map<String, dynamic>,
            );
            yield GenerateMaterialMeta(meta);
          } else {
            yield GenerateMaterialChunk(decoded);
          }
        } else if (decoded is Map && decoded.containsKey('error')) {
          throw Exception(decoded['error']);
        }
      } catch (e) {
        if (e is FormatException) {
          yield GenerateMaterialChunk(payload);
        } else {
          rethrow;
        }
      }
    }
  }
}
