import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

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

    if (rawData is String) {
      // Parse SSE lines from the complete response
      yield* _parseSseString(rawData);
    } else if (rawData is List<int>) {
      // Binary response — decode as UTF-8 then parse
      final decoded = utf8.decode(rawData);
      yield* _parseSseString(decoded);
    } else {
      throw Exception(
        'Unexpected response type from index-extracted-text: '
        '${rawData.runtimeType}',
      );
    }
  }

  /// Parses an SSE-formatted string and yields the text content from each
  /// `data:` line. Stops when it encounters `[DONE]`.
  static Stream<String> _parseSseString(String sseData) async* {
    final lines = const LineSplitter().convert(sseData);

    for (final line in lines) {
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
}
