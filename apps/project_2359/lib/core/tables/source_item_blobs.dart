import 'package:drift/drift.dart';

/// The type of source content.
enum SourceFileType { pdf, docx, xlsx, txt, unknown }

class SourceItemBlobs extends Table {
  TextColumn get id => text()();
  TextColumn get sourceItemId => text()();
  TextColumn get sourceItemName => text()();
  TextColumn get type => textEnum<SourceFileType>()();
  BlobColumn get bytes => blob()();

  @override
  Set<Column> get primaryKey => {id};
}
