/// PDF Text Extractor
///
/// Uses `pdftotext` (poppler) with the `-bbox-layout` flag to extract
/// per-word text and bounding boxes from PDFs. Outputs one JSON file per PDF
/// into the `extracted/` directory relative to this script.
///
/// Output JSON structure per PDF:
/// {
///   "source_filename": "cellular_respiration-v1.pdf",
///   "pages": [
///     {
///       "page": 1,
///       "width": 612.0,
///       "height": 792.0,
///       "blocks": [
///         {
///           "text": "full block text joined",
///           "lines": [
///             {
///               "text": "full line text joined",
///               "words": [
///                 {
///                   "text": "Mitochondria",
///                   "rect": { "left": 72.0, "top": 100.0, "right": 200.0, "bottom": 115.0 }
///                 }
///               ],
///               "rect": { "left": 72.0, "top": 100.0, "right": 540.0, "bottom": 115.0 }
///             }
///           ],
///           "rect": { "left": 72.0, "top": 100.0, "right": 540.0, "bottom": 500.0 }
///         }
///       ]
///     }
///   ]
/// }
///
/// Usage:
///   dart run tools/extract_pdf_text.dart [optional: path/to/pdf_or_dir]
///
/// Defaults to scanning `seeds/biology/` relative to repo root.

import 'dart:convert';
import 'dart:io';

bool _dumpSample = false;

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

Future<void> main(List<String> args) async {
  // Resolve paths relative to the repo root (two levels up from tools/).
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final repoRoot = scriptDir.parent;

  final filteredArgs = args.where((a) => a != '--dump-sample').toList();
  _dumpSample = args.contains('--dump-sample');

  final inputPath =
      filteredArgs.isNotEmpty ? filteredArgs[0] : p(repoRoot, 'tools', 'input');
  final outputDir = Directory(p(repoRoot, 'tools', 'output'));

  await outputDir.create(recursive: true);

  final pdfs = await _collectPdfs(inputPath);

  if (pdfs.isEmpty) {
    stderr.writeln('No PDFs found at: $inputPath');
    exitCode = 1;
    return;
  }

  stdout.writeln('Found ${pdfs.length} PDF(s). Extracting...\n');

  for (final pdf in pdfs) {
    await _processPdf(pdf, outputDir);
  }

  stdout.writeln('\nDone. Output written to: ${outputDir.path}');
}

// ---------------------------------------------------------------------------
// Path helper (avoids importing path package)
// ---------------------------------------------------------------------------

String p(Directory base, String a, [String? b, String? c]) {
  var result = '${base.path}${Platform.pathSeparator}$a';
  if (b != null) result += '${Platform.pathSeparator}$b';
  if (c != null) result += '${Platform.pathSeparator}$c';
  return result;
}

// ---------------------------------------------------------------------------
// Collect PDFs
// ---------------------------------------------------------------------------

Future<List<File>> _collectPdfs(String inputPath) async {
  final entity = FileSystemEntity.typeSync(inputPath);
  if (entity == FileSystemEntityType.file && inputPath.endsWith('.pdf')) {
    return [File(inputPath)];
  } else if (entity == FileSystemEntityType.directory) {
    final dir = Directory(inputPath);
    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.pdf'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));
  }
  return [];
}

// ---------------------------------------------------------------------------
// Process one PDF
// ---------------------------------------------------------------------------

Future<void> _processPdf(File pdf, Directory outputDir) async {
  final filename = pdf.uri.pathSegments.last;
  stdout.write('  Processing $filename ... ');

  // pdftotext -bbox-layout outputs an XHTML document.
  // <block>/<line> use x/y/width/height; <word> uses xMin/yMin/xMax/yMax.
  final result = await Process.run(
    'pdftotext',
    ['-bbox-layout', pdf.path, '-'],
    stdoutEncoding: const Utf8Codec(allowMalformed: true),
    stderrEncoding: utf8,
  );

  if (result.exitCode != 0) {
    stdout.writeln('FAILED');
    stderr.writeln('  pdftotext error: ${result.stderr}');
    return;
  }

  final xhtml = result.stdout as String;
  final parsed = _parseXhtml(xhtml, filename);

  if (_dumpSample) {
    // Print just the first word of the first block of page 1 for verification.
    final pages = parsed['pages'] as List?;
    final firstPage = pages?.isNotEmpty == true ? pages!.first : null;
    final blocks = firstPage?['blocks'] as List?;
    final firstBlock = blocks?.isNotEmpty == true ? blocks!.first : null;
    final lines = firstBlock?['lines'] as List?;
    final firstLine = lines?.isNotEmpty == true ? lines!.first : null;
    final words = firstLine?['words'] as List?;
    final firstWord = words?.isNotEmpty == true ? words!.first : null;
    stdout.writeln('SAMPLE:');
    stdout.writeln('  page size: ${firstPage?["width"]} x ${firstPage?["height"]}');
    stdout.writeln('  first word: ${firstWord?["text"]}');
    stdout.writeln('  rect: ${firstWord?["rect"]}');
    stdout.writeln('  line rect: ${firstLine?["rect"]}');
  } else {
    final outFile = File(
      '${outputDir.path}${Platform.pathSeparator}${filename.replaceAll('.pdf', '.json')}',
    );
    await outFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(parsed),
    );
    stdout.writeln('OK → ${outFile.path.split(Platform.pathSeparator).last}');
  }
}

// ---------------------------------------------------------------------------
// Parse the bbox-layout XHTML
//
// Structure produced by pdftotext -bbox-layout:
//   <page width="..." height="...">
//     <block x="..." y="..." width="..." height="...">
//       <line x="..." y="..." width="..." height="...">
//         <word xMin="..." yMin="..." xMax="..." yMax="...">text</word>
//       </line>
//     </block>
//   </page>
//
// block/line use (x, y, width, height); word uses (xMin, yMin, xMax, yMax).
// All converted to {left, top, right, bottom} to match ProjectRect.
// ---------------------------------------------------------------------------

Map<String, dynamic> _parseXhtml(String xhtml, String filename) {
  final pages = <Map<String, dynamic>>[];

  // --- Pages ---
  final pageRegex = RegExp(
    r'<page\s[^>]*>.*?</page>',
    dotAll: true,
  );
  int pageNumber = 0;

  for (final pageMatch in pageRegex.allMatches(xhtml)) {
    pageNumber++;
    final pageTag = pageMatch.group(0)!;

    final pageWidth = _attrDouble(pageTag, 'width') ?? 0.0;
    final pageHeight = _attrDouble(pageTag, 'height') ?? 0.0;

    final blocks = <Map<String, dynamic>>[];

    // --- Blocks ---
    final blockRegex = RegExp(r'<block\s[^>]*>.*?</block>', dotAll: true);

    for (final blockMatch in blockRegex.allMatches(pageTag)) {
      final blockTag = blockMatch.group(0)!;
      final blockRect = _minMaxRect(_openingTag(blockTag));
      final lines = <Map<String, dynamic>>[];

      // --- Lines ---
      final lineRegex = RegExp(r'<line\s[^>]*>.*?</line>', dotAll: true);

      for (final lineMatch in lineRegex.allMatches(blockTag)) {
        final lineTag = lineMatch.group(0)!;
        final lineRect = _minMaxRect(_openingTag(lineTag));
        final words = <Map<String, dynamic>>[];
        final wordTexts = <String>[];

        // --- Words ---
        // pdftotext -bbox-layout uses xMin/yMin/xMax/yMax for <word> elements.
        final wordRegex = RegExp(
          r'<word\s([^>]*)>(.*?)</word>',
          dotAll: true,
        );

        for (final wordMatch in wordRegex.allMatches(lineTag)) {
          final attrs = wordMatch.group(1)!;
          final rawText = wordMatch.group(2)!;
          final text = _unescapeXml(rawText).trim();
          if (text.isEmpty) continue;

          final wordRect = _wordRect(attrs);
          wordTexts.add(text);
          words.add({'text': text, 'rect': wordRect});
        }

        if (words.isEmpty) continue;

        lines.add({
          'text': wordTexts.join(' '),
          'words': words,
          'rect': lineRect,
        });
      }

      if (lines.isEmpty) continue;

      // Aggregate block text from lines.
      final blockText = lines.map((l) => l['text']).join(' ');
      blocks.add({'text': blockText, 'lines': lines, 'rect': blockRect});
    }

    pages.add({
      'page': pageNumber,
      'width': pageWidth,
      'height': pageHeight,
      'blocks': blocks,
    });
  }

  return {
    'source_filename': filename,
    'pages': pages,
  };
}

// ---------------------------------------------------------------------------
// Attribute helpers
// ---------------------------------------------------------------------------

/// Extract just the opening tag text (e.g. `<line xMin="...">`) so that
/// attribute regexes don't accidentally match attributes of child elements.
String _openingTag(String tag) {
  final end = tag.indexOf('>');
  return end == -1 ? tag : tag.substring(0, end + 1);
}

/// All block/line/word elements use xMin/yMin/xMax/yMax in pdftotext output.
Map<String, double> _minMaxRect(String tag) {
  final left = _attrDouble(tag, 'xMin') ?? 0.0;
  final top = _attrDouble(tag, 'yMin') ?? 0.0;
  final right = _attrDouble(tag, 'xMax') ?? 0.0;
  final bottom = _attrDouble(tag, 'yMax') ?? 0.0;
  return {
    'left': _r(left),
    'top': _r(top),
    'right': _r(right),
    'bottom': _r(bottom),
  };
}

/// word elements: xMin, yMin, xMax, yMax → left/top/right/bottom.
Map<String, double> _wordRect(String attrs) => _minMaxRect(attrs);

double? _attrDouble(String tag, String name) {
  final r = RegExp('$name="([^"]+)"');
  final m = r.firstMatch(tag);
  if (m == null) return null;
  return double.tryParse(m.group(1)!);
}

/// Round to 4 decimal places to keep JSON tidy.
double _r(double v) => double.parse(v.toStringAsFixed(4));

String _unescapeXml(String s) => s
    .replaceAll('&amp;', '&')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&#160;', '\u00A0');
