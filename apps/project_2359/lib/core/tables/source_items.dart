import 'package:drift/drift.dart';

class SourceItems extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get path => text().nullable()();
  TextColumn get type => text()();
  TextColumn get indexContent => text().nullable()();
}
