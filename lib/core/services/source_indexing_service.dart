/// Source indexing service for Project 2359
///
/// Handles content extraction and indexing from sources.
/// Pipeline: Identify type → Extract content → Generate IndexItems
library;

import 'dart:convert';
import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/index_item.dart';
import '../models/source.dart';
import 'llm_service.dart';

/// Callback for indexing progress updates
typedef IndexingProgressCallback =
    void Function(double progress, String status);

/// Service for indexing source content.
///
/// Uses LLM service for content analysis and description generation.
/// Supports PDF, audio, video, image, note, and link source types.
class SourceIndexingService {
  final LlmService? _llmService;

  SourceIndexingService({LlmService? llmService}) : _llmService = llmService;

  /// Indexes a source and returns extracted IndexItems.
  ///
  /// [onProgress] callback provides progress updates during indexing.
  Future<List<IndexItem>> indexSource(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    onProgress?.call(0.0, 'Starting indexing...');

    try {
      final items = switch (source.type) {
        SourceType.pdf => await _indexPdf(source, onProgress: onProgress),
        SourceType.audio => await _indexAudio(source, onProgress: onProgress),
        SourceType.video => await _indexVideo(source, onProgress: onProgress),
        SourceType.image => await _indexImage(source, onProgress: onProgress),
        SourceType.note => await _indexNote(source, onProgress: onProgress),
        SourceType.link => await _indexLink(source, onProgress: onProgress),
      };

      onProgress?.call(1.0, 'Indexing complete');
      return items;
    } catch (e) {
      onProgress?.call(0.0, 'Indexing failed: $e');
      rethrow;
    }
  }

  /// Indexes a PDF document by extracting text from each page.
  Future<List<IndexItem>> _indexPdf(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    if (source.filePath == null) {
      return [_createPlaceholderItem(source, 'No file path provided')];
    }

    onProgress?.call(0.1, 'Loading PDF...');

    try {
      final file = File(source.filePath!);
      if (!await file.exists()) {
        return [_createPlaceholderItem(source, 'PDF file not found')];
      }

      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final pageCount = document.pages.count;
      final items = <IndexItem>[];

      onProgress?.call(0.2, 'Extracting text from $pageCount pages...');

      for (var i = 0; i < pageCount; i++) {
        final page = document.pages[i];
        final textExtractor = PdfTextExtractor(document);
        final text = textExtractor.extractText(
          startPageIndex: i,
          endPageIndex: i,
        );

        if (text.trim().isNotEmpty) {
          // Split into paragraphs
          final paragraphs = text
              .split(RegExp(r'\n\s*\n'))
              .where((p) => p.trim().isNotEmpty)
              .toList();

          for (var j = 0; j < paragraphs.length; j++) {
            items.add(
              IndexItem.text(
                sourceId: source.id,
                content: paragraphs[j].trim(),
                pageNumber: i + 1,
                paragraphNumber: j + 1,
              ),
            );
          }
        }

        final progress = 0.2 + (0.7 * (i + 1) / pageCount);
        onProgress?.call(progress, 'Processed page ${i + 1} of $pageCount');
      }

      document.dispose();

      if (items.isEmpty) {
        return [_createPlaceholderItem(source, 'No text content found in PDF')];
      }

      onProgress?.call(0.95, 'Finalizing...');
      return items;
    } catch (e) {
      return [_createPlaceholderItem(source, 'PDF extraction failed: $e')];
    }
  }

  /// Indexes an audio file using LLM transcription.
  Future<List<IndexItem>> _indexAudio(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    if (source.filePath == null) {
      return [_createPlaceholderItem(source, 'No audio file path')];
    }

    onProgress?.call(0.1, 'Preparing audio...');

    // TODO: Implement audio transcription
    // This would require:
    // 1. Reading audio file
    // 2. Converting to base64 or streaming format
    // 3. Calling transcription service (Groq Whisper, etc.)
    //
    // For now, return placeholder

    if (_llmService != null) {
      try {
        final file = File(source.filePath!);
        if (await file.exists()) {
          onProgress?.call(0.3, 'Transcribing audio...');

          // Note: Direct audio transcription not yet implemented
          // Would use: _llmService!.transcribeAudio(audioBase64, format)
        }
      } catch (e) {
        return [
          _createPlaceholderItem(source, 'Audio transcription failed: $e'),
        ];
      }
    }

    return [
      IndexItem.transcription(
        sourceId: source.id,
        content:
            '[Audio transcription pending - file stored at ${source.filePath}]',
        startTimestamp: 0,
      ),
    ];
  }

  /// Indexes a video file.
  Future<List<IndexItem>> _indexVideo(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    if (source.filePath == null) {
      return [_createPlaceholderItem(source, 'No video file path')];
    }

    onProgress?.call(0.1, 'Processing video...');

    // TODO: Implement video indexing
    // Strategy:
    // 1. Extract audio track → transcribe
    // 2. Extract keyframes (1fps) → analyze for text/changes
    // 3. Combine transcription with visual analysis

    return [
      IndexItem.transcription(
        sourceId: source.id,
        content: '[Video indexing pending - file stored at ${source.filePath}]',
        startTimestamp: 0,
      ),
    ];
  }

  /// Indexes an image file using LLM vision.
  Future<List<IndexItem>> _indexImage(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    if (source.filePath == null) {
      return [_createPlaceholderItem(source, 'No image file path')];
    }

    onProgress?.call(0.1, 'Loading image...');

    try {
      final file = File(source.filePath!);
      if (!await file.exists()) {
        return [_createPlaceholderItem(source, 'Image file not found')];
      }

      if (_llmService != null) {
        onProgress?.call(0.3, 'Analyzing image with AI...');

        final bytes = await file.readAsBytes();
        final base64 = base64Encode(bytes);

        try {
          final description = await _llmService.describeImage(
            base64,
            prompt:
                'Describe this image in detail. Extract and list any visible text, diagrams, charts, or educational content.',
          );

          onProgress?.call(0.9, 'Finalizing...');

          return [
            IndexItem.imageDescription(
              sourceId: source.id,
              content: description,
              imagePath: source.filePath,
            ),
          ];
        } catch (e) {
          return [_createPlaceholderItem(source, 'Image analysis failed: $e')];
        }
      }

      // No LLM service available
      return [
        IndexItem.imageDescription(
          sourceId: source.id,
          content: '[Image stored - analysis pending LLM service]',
          imagePath: source.filePath,
        ),
      ];
    } catch (e) {
      return [_createPlaceholderItem(source, 'Image processing failed: $e')];
    }
  }

  /// Indexes a text note by splitting into paragraphs.
  Future<List<IndexItem>> _indexNote(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    String content = source.content ?? '';

    onProgress?.call(0.2, 'Processing note...');

    // If content is empty but we have a file path, read from file
    if (content.isEmpty && source.filePath != null) {
      try {
        final file = File(source.filePath!);
        if (await file.exists()) {
          content = await file.readAsString();
        }
      } catch (_) {
        // Ignore read errors
      }
    }

    if (content.isEmpty) {
      return [];
    }

    onProgress?.call(0.5, 'Extracting paragraphs...');

    // Split into paragraphs
    final paragraphs = content
        .split(RegExp(r'\n\s*\n'))
        .where((p) => p.trim().isNotEmpty)
        .toList();

    final items = <IndexItem>[];
    for (var i = 0; i < paragraphs.length; i++) {
      items.add(
        IndexItem.text(
          sourceId: source.id,
          content: paragraphs[i].trim(),
          paragraphNumber: i + 1,
        ),
      );
    }

    onProgress?.call(0.9, 'Finalizing...');

    // If only one paragraph, just return it
    if (items.isEmpty && content.isNotEmpty) {
      return [
        IndexItem.text(
          sourceId: source.id,
          content: content,
          paragraphNumber: 1,
        ),
      ];
    }

    return items;
  }

  /// Indexes a web link.
  Future<List<IndexItem>> _indexLink(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    onProgress?.call(0.5, 'Link stored...');

    // TODO: Implement web scraping
    // Would require:
    // 1. Fetch page content
    // 2. Extract main text using readability algorithm
    // 3. Create IndexItems from extracted content

    return [
      IndexItem.text(
        sourceId: source.id,
        content:
            '[Web link stored - content extraction pending: ${source.url}]',
        paragraphNumber: 1,
      ),
    ];
  }

  /// Creates a placeholder item for error cases.
  IndexItem _createPlaceholderItem(Source source, String message) {
    return IndexItem(
      id: IndexItem.generateId(),
      sourceId: source.id,
      type: IndexItemType.text,
      content: '[$message]',
      createdAt: DateTime.now(),
    );
  }

  /// Re-indexes a source (for when content changes or indexing improves).
  Future<List<IndexItem>> reindexSource(
    Source source, {
    IndexingProgressCallback? onProgress,
  }) async {
    return indexSource(source, onProgress: onProgress);
  }
}
