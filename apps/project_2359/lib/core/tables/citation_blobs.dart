import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/citation_items.dart';

class CitationBlobs extends Table {
  TextColumn get id => text()();
  TextColumn get citationId => text().references(CitationItems, #id)();
  BlobColumn get bytes => blob()();

  @override
  Set<Column> get primaryKey => {id};
}
