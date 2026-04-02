import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/source_items.dart';
import 'package:project_2359/core/models/citation.dart';

class CitationItems extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(SourceItems, #id)();
  TextColumn get type => text()(); // text, image
  IntColumn get pageNumber => integer().nullable()();

  TextColumn get citation => text().map(const CitationConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
