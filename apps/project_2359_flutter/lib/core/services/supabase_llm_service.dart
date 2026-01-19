/// Supabase LLM service implementation for Project 2359
///
/// Connects to Supabase Edge Functions for LLM operations.
/// Supports multiple providers: Deepseek, OpenRouter, Gemini, Groq.
library;

import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/llm_models.dart';
import 'llm_service.dart';

/// LLM service implementation using Supabase Edge Functions.
///
/// This service calls the `llm-chat` Edge Function which routes
/// requests to the appropriate LLM provider.
class SupabaseLlmService implements LlmService {
  final SupabaseClient _client;

  /// Default model for each provider
  static const defaultModels = {
    LlmProvider.deepseek: 'deepseek-chat',
    LlmProvider.gemini: 'gemini-2.0-flash',
    LlmProvider.groq: 'llama-3.3-70b-versatile',
    LlmProvider.openrouter: 'deepseek/deepseek-chat',
  };

  SupabaseLlmService(this._client);

  @override
  Future<LlmResponse> chat(LlmRequest request) async {
    try {
      final response = await _client.functions.invoke(
        'llm-chat',
        body: request.toJson(),
      );

      if (response.status != 200) {
        throw LlmException(
          'LLM request failed with status ${response.status}',
          code: response.status.toString(),
          provider: request.provider,
        );
      }

      final data = response.data as Map<String, dynamic>;
      return LlmResponse.fromJson(data, request.provider);
    } on FunctionException catch (e) {
      throw LlmException(
        e.details?.toString() ?? 'Function invocation failed',
        code: e.status.toString(),
        provider: request.provider,
      );
    } catch (e) {
      if (e is LlmException) rethrow;
      throw LlmException('Unexpected error: $e', provider: request.provider);
    }
  }

  @override
  Future<List<TextSegment>> analyzeText(
    String content, {
    String? context,
  }) async {
    final systemPrompt =
        '''
You are a document analyzer. Break the given text into logical segments/paragraphs.
For each segment, provide the content as-is.
${context != null ? 'Context: $context' : ''}

Respond in JSON format:
{
  "segments": [
    {"content": "segment text here", "index": 1},
    ...
  ]
}
''';

    final response = await chat(
      LlmRequest(
        provider: LlmProvider.deepseek,
        model: defaultModels[LlmProvider.deepseek]!,
        messages: [ChatMessage.user(content)],
        systemPrompt: systemPrompt,
        temperature: 0.3,
      ),
    );

    try {
      final json = jsonDecode(response.content) as Map<String, dynamic>;
      final segments = json['segments'] as List<dynamic>;
      return segments.map((s) {
        final map = s as Map<String, dynamic>;
        return TextSegment(
          content: map['content'] as String,
          summary: map['summary'] as String?,
          index: map['index'] as int,
        );
      }).toList();
    } catch (e) {
      // If parsing fails, return the whole content as one segment
      return [TextSegment(content: content, index: 1)];
    }
  }

  @override
  Future<String> describeImage(String imageBase64, {String? prompt}) async {
    final userPrompt =
        prompt ?? 'Describe this image in detail. Extract any visible text.';

    // Use Gemini for vision capabilities
    final response = await chat(
      LlmRequest(
        provider: LlmProvider.gemini,
        model: 'gemini-2.0-flash',
        messages: [
          ChatMessage.user('$userPrompt\n\n[Image data: $imageBase64]'),
        ],
        systemPrompt:
            'You are an image analyzer. Describe images accurately and extract any text visible in them.',
        temperature: 0.5,
      ),
    );

    return response.content;
  }

  @override
  Future<List<TranscriptSegment>> transcribeAudio(
    String audioBase64,
    String format,
  ) async {
    // Note: Most LLM providers don't support direct audio transcription
    // This would need a specialized transcription service like Whisper
    // For now, return a placeholder indicating transcription is needed

    // TODO: Implement with Groq's Whisper API or similar
    throw LlmException(
      'Audio transcription not yet implemented. Consider using Groq Whisper API.',
      code: 'NOT_IMPLEMENTED',
    );
  }

  /// Get the default model for a provider
  String getDefaultModel(LlmProvider provider) {
    return defaultModels[provider] ?? 'unknown';
  }
}
