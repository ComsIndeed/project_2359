/// Web database connection (for web platform)
library;

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import '../../../config/app_config.dart';

/// Opens a connection to the SQLite database on web platform
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    // Use the new Drift WASM database for web
    final result = await WasmDatabase.open(
      databaseName: kDatabaseName,
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    return result.resolvedExecutor;
  });
}
