import 'package:drift/drift.dart';
import 'package:project_2359/core/converters/json_list_converter.dart';
import 'package:project_2359/core/converters/project_rect_list_converter.dart';
import 'package:project_2359/core/converters/project_time_range_list_converter.dart';

class CitationItems extends Table {
  TextColumn get id => text()();

  /// The actual cited text or content summary.
  TextColumn get citedText => text().nullable()();

  /// References one or more sources (e.g. multiple PDF files).
  TextColumn get sourceIds =>
      text().map(const JsonListConverter<String>()).nullable()();

  /// One or more page numbers (e.g. non-contiguous pages like "4, 7, 12").
  TextColumn get pageNumbers =>
      text().map(const JsonListConverter<int>()).nullable()();

  /// One or more time segments (e.g. for video timestamps).
  TextColumn get timeRanges =>
      text().map(const ProjectTimeRangeListConverter()).nullable()();

  /// One or more bounding boxes (e.g. for multi-line text selections in a PDF).
  TextColumn get rects =>
      text().map(const ProjectRectListConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
