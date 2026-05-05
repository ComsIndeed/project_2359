/// Biology Citation Seed Generator
///
/// This script:
/// 1. Reads the extracted JSON data from `seeds/biology/`.
/// 2. Selects text segments to create realistic cards and citations.
/// 3. Generates a Dart seeder file: `apps/project_2359/lib/core/services/biology_citation_seeder.dart`.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() async {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final repoRoot = scriptDir.parent;
  final seedsDir = Directory('${repoRoot.path}/seeds/biology');
  final outputSeederFile = File('${repoRoot.path}/apps/project_2359/lib/core/services/biology_citation_seeder.dart');

  if (!seedsDir.existsSync()) {
    print('Seeds directory not found at ${seedsDir.path}');
    return;
  }

  final jsonFiles = seedsDir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList();

  if (jsonFiles.isEmpty) {
    print('No JSON files found in ${seedsDir.path}');
    return;
  }

  print('Found ${jsonFiles.length} JSON files. Generating seeder...');

  final List<Map<String, dynamic>> allPdfData = [];
  for (final file in jsonFiles) {
    allPdfData.add(json.decode(file.readAsStringSync()));
  }

  final random = Random(42); // Deterministic seeds

  final sb = StringBuffer();
  sb.writeln("// ignore_for_file: leading_newlines_in_over_line_strings, depend_on_referenced_packages");
  sb.writeln("import 'package:drift/drift.dart';");
  sb.writeln("import 'package:http/http.dart' as http;");
  sb.writeln("import 'package:project_2359/app_database.dart';");
  sb.writeln("import 'package:uuid/uuid.dart';");
  sb.writeln("import 'package:project_2359/core/enums/media_type.dart';");
  sb.writeln("import 'package:project_2359/core/models/project_rect.dart';");
  sb.writeln("import 'package:project_2359/core/tables/source_item_blobs.dart';");
  sb.writeln("import 'package:project_2359/core/utils/logger.dart';");
  sb.writeln("");
  sb.writeln("class BiologyCitationSeeder {");
  sb.writeln("  static const String _baseUrl = 'https://raw.githubusercontent.com/ComsIndeed/project_2359/main/seeds/biology/';");
  sb.writeln("");
  sb.writeln("  static Future<void> seed(AppDatabase db) async {");
  sb.writeln("    final uuid = const Uuid();");
  sb.writeln("    AppLogger.info('Starting Biology Citation Seeding (Download from GitHub)...', tag: 'BiologySeeder');");
  sb.writeln("");
  sb.writeln("    // 1. Create Folder");
  sb.writeln("    final folderId = uuid.v4();");
  sb.writeln("    await db.into(db.studyFolderItems).insert(");
  sb.writeln("      StudyFolderItemsCompanion(");
  sb.writeln("        id: Value(folderId),");
  sb.writeln("        name: const Value('Biology (CITATION DEMOs)'),");
  sb.writeln("        isPinned: const Value(true),");
  sb.writeln("        createdAt: Value(DateTime.now().toIso8601String()),");
  sb.writeln("        updatedAt: Value(DateTime.now().toIso8601String()),");
  sb.writeln("      ),");
  sb.writeln("    );");
  sb.writeln("");
  sb.writeln("    // 2. Download and Create Sources/Blobs");
  for (final pdfData in allPdfData) {
    final filename = pdfData['source_filename'];
    final varName = filename.replaceAll('-', '_').replaceAll('.', '_');
    sb.writeln("    final sourceId_$varName = uuid.v4();");
    sb.writeln("    try {");
    sb.writeln("      final response = await http.get(Uri.parse('\${_baseUrl}$filename'));");
    sb.writeln("      if (response.statusCode == 200) {");
    sb.writeln("        AppLogger.info('Downloaded $filename (\${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');");
    sb.writeln("        await db.into(db.sourceItemBlobs).insert(");
    sb.writeln("          SourceItemBlobsCompanion(");
    sb.writeln("            id: Value(uuid.v4()),");
    sb.writeln("            sourceItemId: Value(sourceId_$varName),");
    sb.writeln("            sourceItemName: const Value('$filename'),");
    sb.writeln("            type: const Value(SourceFileType.pdf),");
    sb.writeln("            bytes: Value(response.bodyBytes),");
    sb.writeln("          ),");
    sb.writeln("        );");
    sb.writeln("      } else {");
    sb.writeln("        AppLogger.warning('Failed to download $filename: \${response.statusCode}', tag: 'BiologySeeder');");
    sb.writeln("      }");
    sb.writeln("    } catch (e) {");
    sb.writeln("      AppLogger.error('Error downloading $filename: \$e', tag: 'BiologySeeder');");
    sb.writeln("    }");
    sb.writeln("");
    sb.writeln("    await db.into(db.sourceItems).insert(");
    sb.writeln("      SourceItemsCompanion(");
    sb.writeln("        id: Value(sourceId_$varName),");
    sb.writeln("        folderId: Value(folderId),");
    sb.writeln("        label: const Value('$filename'),");
    sb.writeln("        type: const Value(MediaType.document),");
    sb.writeln("      ),");
    sb.writeln("    );");
  }

  sb.writeln("");
  sb.writeln("    // 3. Create Decks");
  final deckConfigs = [
    {'name': 'Cellular & Molecular Foundation', 'desc': 'Core biology concepts with varied mastery states.', 'count': 50, 'mixed': true},
    {'name': 'Systems & Ecology', 'desc': 'Dynamics of populations and internal systems.', 'count': 50, 'mixed': true},
    {'name': 'Immunology Basics', 'desc': 'Foundational immunology for new learners.', 'count': 40, 'mixed': false},
    {'name': 'Genetic Architecture', 'desc': 'Molecular genetics and inheritance patterns.', 'count': 40, 'mixed': false},
  ];

  for (int i = 0; i < deckConfigs.length; i++) {
    final config = deckConfigs[i];
    final deckId = "deck${i + 1}Id";
    sb.writeln("    final $deckId = uuid.v4();");
    sb.writeln("    await db.into(db.deckItems).insert(");
    sb.writeln("      DeckItemsCompanion(");
    sb.writeln("        id: Value($deckId),");
    sb.writeln("        folderId: Value(folderId),");
    sb.writeln("        name: const Value('${config['name']}'),");
    sb.writeln("        description: const Value('${config['desc']}'),");
    sb.writeln("      ),");
    sb.writeln("    );");
  }

  sb.writeln("");
  sb.writeln("    // 4. Create Citations and Cards");
  
  for (int d = 0; d < deckConfigs.length; d++) {
    final config = deckConfigs[d];
    final deckIdVar = "deck${d + 1}Id";
    
    for (int c = 0; c < (config['count'] as int); c++) {
      final pdf = allPdfData[random.nextInt(allPdfData.length)];
      final pages = pdf['pages'] as List;
      final page = pages[random.nextInt(pages.length)];
      final blocks = page['blocks'] as List;
      if (blocks.isEmpty) continue;
      
      final block = blocks[random.nextInt(blocks.length)];
      final text = block['text'] as String;
      final rect = block['rect'];
      final pageNum = page['page'];
      final filename = pdf['source_filename'];
      final sourceIdVar = "sourceId_${filename.replaceAll('-', '_').replaceAll('.', '_')}";

      String q = "Identify the key concept described in $filename page $pageNum.";
      String a = text.length > 100 ? text.substring(0, 100) + "..." : text;
      
      final words = text.split(' ').where((w) => w.length > 4).toList();
      if (words.length > 3) {
        final keyword = words[random.nextInt(words.length)];
        q = "In the context of **$filename**, what is the significance of **$keyword**?";
        a = "According to the source on page $pageNum: \"$text\"";
      }

      sb.writeln("    {");
      sb.writeln("      final citationId = uuid.v4();");
      sb.writeln("      await db.into(db.citationItems).insert(");
      sb.writeln("        CitationItemsCompanion(");
      sb.writeln("          id: Value(citationId),");
      sb.writeln("          citedText: const Value(${json.encode(text)}),");
      sb.writeln("          sourceIds: Value([$sourceIdVar]),");
      sb.writeln("          pageNumbers: const Value([$pageNum]),");
      sb.writeln("          rects: const Value([ProjectRect(left: ${rect['left']}, top: ${rect['top']}, right: ${rect['right']}, bottom: ${rect['bottom']})]),");
      sb.writeln("        ),");
      sb.writeln("      );");

      int state = 0;
      double stability = 0.0;
      double difficulty = 0.0;
      String dueExpr = "DateTime.now()";
      
      if (config['mixed'] as bool) {
        final r = random.nextDouble();
        if (r < 0.3) {
          state = 2; // Graduated
          stability = 10.0 + random.nextDouble() * 50;
          difficulty = 2.0 + random.nextDouble() * 5;
          dueExpr = "DateTime.now().add(const Duration(days: ${random.nextInt(30)}))";
        } else if (r < 0.6) {
          state = 1; // Learning
          stability = 1.0 + random.nextDouble() * 2;
          difficulty = 5.0 + random.nextDouble() * 3;
          dueExpr = "DateTime.now().subtract(const Duration(hours: ${random.nextInt(12)}))";
        }
      }

      sb.writeln("      await db.into(db.cardItems).insert(");
      sb.writeln("        CardItemsCompanion(");
      sb.writeln("          id: Value(uuid.v4()),");
      sb.writeln("          deckId: Value($deckIdVar),");
      sb.writeln("          citationId: Value(citationId),");
      sb.writeln("          frontText: const Value(${json.encode(q)}),");
      sb.writeln("          backText: const Value(${json.encode(a)}),");
      sb.writeln("          spacedState: const Value($state),");
      sb.writeln("          spacedStability: const Value($stability),");
      sb.writeln("          spacedDifficulty: const Value($difficulty),");
      sb.writeln("          spacedDue: Value($dueExpr),");
      sb.writeln("        ),");
      sb.writeln("      );");
      sb.writeln("    }");
    }
  }

  sb.writeln("    AppLogger.info('Biology Citation Seeding COMPLETED.', tag: 'BiologySeeder');");
  sb.writeln("  }");
  sb.writeln("}");

  outputSeederFile.writeAsStringSync(sb.toString());
  print('Successfully generated seeder at ${outputSeederFile.path}');
}
