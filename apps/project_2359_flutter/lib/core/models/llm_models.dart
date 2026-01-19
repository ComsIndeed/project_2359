/// LLM service models for Project 2359
///
/// Contains data models for LLM service requests and responses.
library;

/// Supported LLM providers
enum LlmProvider {
  /// Deepseek AI API (OpenAI-compatible)
  deepseek,

  /// OpenRouter API (OpenAI-compatible, multi-model)
  openrouter,

  /// Google Gemini API
  gemini,

  /// Groq API (fast inference)
  groq,
}

/// Extension for provider configuration
extension LlmProviderExtension on LlmProvider {
  /// Get the provider name for API calls
  String get apiName {
    switch (this) {
      case LlmProvider.deepseek:
        return 'deepseek';
      case LlmProvider.openrouter:
        return 'openrouter';
      case LlmProvider.gemini:
        return 'gemini';
      case LlmProvider.groq:
        return 'groq';
    }
  }
}

/// A message in a chat conversation
class ChatMessage {
  /// Role of the message sender
  final ChatRole role;

  /// Content of the message
  final String content;

  const ChatMessage({required this.role, required this.content});

  /// Create a user message
  factory ChatMessage.user(String content) =>
      ChatMessage(role: ChatRole.user, content: content);

  /// Create an assistant message
  factory ChatMessage.assistant(String content) =>
      ChatMessage(role: ChatRole.assistant, content: content);

  /// Create a system message
  factory ChatMessage.system(String content) =>
      ChatMessage(role: ChatRole.system, content: content);

  Map<String, dynamic> toJson() => {'role': role.name, 'content': content};
}

/// Role in a chat conversation
enum ChatRole { user, assistant, system }

/// Response from an LLM API call
class LlmResponse {
  /// Generated text content
  final String content;

  /// Number of input tokens used
  final int inputTokens;

  /// Number of output tokens generated
  final int outputTokens;

  /// Model used for generation
  final String model;

  /// Provider used
  final LlmProvider provider;

  const LlmResponse({
    required this.content,
    required this.inputTokens,
    required this.outputTokens,
    required this.model,
    required this.provider,
  });

  /// Total tokens used
  int get totalTokens => inputTokens + outputTokens;

  factory LlmResponse.fromJson(
    Map<String, dynamic> json,
    LlmProvider provider,
  ) {
    final usage = json['usage'] as Map<String, dynamic>? ?? {};
    return LlmResponse(
      content: json['content'] as String? ?? '',
      inputTokens: usage['inputTokens'] as int? ?? 0,
      outputTokens: usage['outputTokens'] as int? ?? 0,
      model: json['model'] as String? ?? 'unknown',
      provider: provider,
    );
  }
}

/// Request configuration for LLM calls
class LlmRequest {
  /// Provider to use
  final LlmProvider provider;

  /// Model name (e.g., 'deepseek-chat', 'gemini-pro')
  final String model;

  /// Chat messages
  final List<ChatMessage> messages;

  /// Optional system prompt
  final String? systemPrompt;

  /// Maximum tokens to generate
  final int? maxTokens;

  /// Temperature for sampling (0.0-2.0)
  final double? temperature;

  const LlmRequest({
    required this.provider,
    required this.model,
    required this.messages,
    this.systemPrompt,
    this.maxTokens,
    this.temperature,
  });

  Map<String, dynamic> toJson() => {
    'provider': provider.apiName,
    'model': model,
    'messages': messages.map((m) => m.toJson()).toList(),
    if (systemPrompt != null) 'systemPrompt': systemPrompt,
    if (maxTokens != null) 'maxTokens': maxTokens,
    if (temperature != null) 'temperature': temperature,
  };
}

/// Exception thrown when LLM API call fails
class LlmException implements Exception {
  final String message;
  final String? code;
  final LlmProvider? provider;

  const LlmException(this.message, {this.code, this.provider});

  @override
  String toString() =>
      'LlmException: $message${code != null ? ' ($code)' : ''}';
}
