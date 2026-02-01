import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:project_2359/core/models/study_material.dart';
import 'package:project_2359/core/tables/source_items.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [SourceItems, StudyMaterial])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'project_2359_database',
      native: const DriftNativeOptions(
        databaseDirectory: path.getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
      // TODO: Implement web support
    );
  }
}
