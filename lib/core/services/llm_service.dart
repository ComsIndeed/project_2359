/// LLM service interface for Project 2359
///
/// Abstract interface for LLM operations, allowing different implementations
/// (Supabase Edge Functions, direct API calls, mock for testing).
library;

import '../models/llm_models.dart';

/// Abstract interface for LLM operations.
///
/// This interface defines all LLM-related operations for the app.
/// The primary implementation is [SupabaseLlmService] which calls
/// Supabase Edge Functions.
abstract class LlmService {
  /// Send a chat request to the LLM.
  ///
  /// [request] contains the provider, model, messages, and optional parameters.
  /// Returns an [LlmResponse] with the generated content and token usage.
  /// Throws [LlmException] on failure.
  Future<LlmResponse> chat(LlmRequest request);

  /// Analyze text content and return structured segments.
  ///
  /// Useful for breaking down documents into meaningful chunks.
  Future<List<TextSegment>> analyzeText(String content, {String? context});

  /// Describe an image using a vision model.
  ///
  /// [imageBase64] is the base64-encoded image data.
  /// Returns a description of the image content.
  Future<String> describeImage(String imageBase64, {String? prompt});

  /// Transcribe audio content.
  ///
  /// Note: This may require a specific provider that supports audio
  /// or may return a placeholder if transcription is not supported.
  Future<List<TranscriptSegment>> transcribeAudio(
    String audioBase64,
    String format,
  );
}

/// A segment of analyzed text
class TextSegment {
  /// The text content of this segment
  final String content;

  /// Optional summary of the segment
  final String? summary;

  /// Paragraph or section number
  final int index;

  const TextSegment({required this.content, this.summary, required this.index});
}

/// A segment of transcribed audio/video
class TranscriptSegment {
  /// The transcribed text
  final String text;

  /// Start timestamp in seconds
  final double startTime;

  /// End timestamp in seconds
  final double endTime;

  const TranscriptSegment({
    required this.text,
    required this.startTime,
    required this.endTime,
  });
}
