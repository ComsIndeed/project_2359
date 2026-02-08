import 'package:drift/drift.dart';

/// The type of source content.
enum SourceType { document, video, audio, image, text }

class SourceItems extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get path => text().nullable()();
  TextColumn get type => text()(); // Use SourceType.name to store as string
  TextColumn get extractedContent => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
