import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/source_items.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [SourceItems])
class AppDatabase extends _$AppDatabase {}
