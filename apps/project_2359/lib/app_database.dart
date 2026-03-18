import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:project_2359/core/tables/source_item_blobs.dart';
import 'package:project_2359/core/tables/source_items.dart';
import 'package:project_2359/core/tables/study_material_items.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';
import 'package:project_2359/core/tables/study_card_items.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SourceItems,
    StudyMaterialItems,
    StudyFolderItems,
    SourceItemBlobs,
    StudyCardItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add missing tables that were introduced
          await m.createTable(studyFolderItems);
          await m.createTable(studyCardItems);
          await m.createTable(sourceItemBlobs);
        }
        if (from < 3) {
          // Add isPinned to existing tables
          await m.addColumn(studyFolderItems, studyFolderItems.isPinned);
          await m.addColumn(studyMaterialItems, studyMaterialItems.isPinned);
          await m.addColumn(sourceItems, sourceItems.isPinned);
        }
        if (from < 4) {
          // Add FSRS fields to StudyCardItems
          await m.addColumn(studyCardItems, studyCardItems.due);
          await m.addColumn(studyCardItems, studyCardItems.stability);
          await m.addColumn(studyCardItems, studyCardItems.difficulty);
          await m.addColumn(studyCardItems, studyCardItems.elapsedDays);
          await m.addColumn(studyCardItems, studyCardItems.scheduledDays);
          await m.addColumn(studyCardItems, studyCardItems.reps);
          await m.addColumn(studyCardItems, studyCardItems.lapses);
          await m.addColumn(studyCardItems, studyCardItems.fsrsState);
          await m.addColumn(studyCardItems, studyCardItems.lastReview);
        }
      },
      beforeOpen: (details) async {
        // Enable foreign keys if needed
        // await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'project_2359_database',
      native: const DriftNativeOptions(
        databaseDirectory: path.getApplicationSupportDirectory,
      ),
    );
  }
}
