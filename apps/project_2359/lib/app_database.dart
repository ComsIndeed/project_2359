import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:project_2359/core/tables/source_item_blobs.dart';
import 'package:project_2359/core/tables/source_items.dart';
import 'package:project_2359/core/tables/study_material_items.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';
import 'package:project_2359/core/tables/study_card_items.dart';
import 'package:project_2359/core/tables/study_session_events.dart';
import 'package:project_2359/core/utils/logger.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SourceItems,
    StudyMaterialItems,
    StudyFolderItems,
    SourceItemBlobs,
    StudyCardItems,
    StudySessionEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        AppLogger.info('Creating database tables...', tag: 'Database');
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        AppLogger.info('Upgrading database from $from to $to', tag: 'Database');
      },
      beforeOpen: (details) async {
        AppLogger.info('Database opened successfully', tag: 'Database');
      },
    );
  }

  /// Clears all data from the database.
  Future<void> resetDatabase() async {
    AppLogger.warning('Wiping entire database...', tag: 'Database');
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'project_2359_database_v2',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
      native: const DriftNativeOptions(
        databaseDirectory: path.getApplicationSupportDirectory,
      ),
    );
  }
}
