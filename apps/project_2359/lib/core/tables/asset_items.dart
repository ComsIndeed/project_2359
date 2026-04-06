import 'package:drift/drift.dart';
import 'package:project_2359/core/enums/media_type.dart';

/// Centralized storage for media (images, PDFs, blobs).
/// Used by CardItems for stable media references.
class AssetItems extends Table {
  TextColumn get id => text()();
  BlobColumn get data => blob()();
  TextColumn get name => text().nullable()();
  TextColumn get type => textEnum<MediaType>()();
  TextColumn get sourceId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
