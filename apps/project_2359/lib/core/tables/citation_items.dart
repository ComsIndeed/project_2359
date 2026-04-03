import 'dart:convert';
import 'package:drift/drift.dart';

/// A time range segment for playable sources.
class CitationTimeRange {
  final double start;
  final double end;

  const CitationTimeRange({required this.start, required this.end});

  Map<String, dynamic> toMap() => {'start': start, 'end': end};

  factory CitationTimeRange.fromMap(Map<String, dynamic> map) =>
      CitationTimeRange(
        start: (map['start'] as num).toDouble(),
        end: (map['end'] as num).toDouble(),
      );

  String toJson() => json.encode(toMap());

  factory CitationTimeRange.fromJson(String source) =>
      CitationTimeRange.fromMap(json.decode(source) as Map<String, dynamic>);
}

/// A bounding box for document sources, based on [PdfRect] coordinates.
class CitationRect {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const CitationRect({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  Map<String, dynamic> toMap() => {
    'left': left,
    'top': top,
    'right': right,
    'bottom': bottom,
  };

  factory CitationRect.fromMap(Map<String, dynamic> map) => CitationRect(
    left: (map['left'] as num).toDouble(),
    top: (map['top'] as num).toDouble(),
    right: (map['right'] as num).toDouble(),
    bottom: (map['bottom'] as num).toDouble(),
  );

  String toJson() => json.encode(toMap());

  factory CitationRect.fromJson(String source) =>
      CitationRect.fromMap(json.decode(source) as Map<String, dynamic>);
}

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
      text().map(const CitationTimeRangeListConverter()).nullable()();

  /// One or more bounding boxes (e.g. for multi-line text selections in a PDF).
  TextColumn get rects =>
      text().map(const CitationRectListConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// --- Converters ---

class JsonListConverter<T> extends TypeConverter<List<T>, String> {
  const JsonListConverter();
  @override
  List<T> fromSql(String fromDb) => (json.decode(fromDb) as List).cast<T>();
  @override
  String toSql(List<T> value) => json.encode(value);
}

class CitationTimeRangeListConverter
    extends TypeConverter<List<CitationTimeRange>, String> {
  const CitationTimeRangeListConverter();
  @override
  List<CitationTimeRange> fromSql(String fromDb) =>
      (json.decode(fromDb) as List)
          .map((i) => CitationTimeRange.fromMap(i as Map<String, dynamic>))
          .toList();
  @override
  String toSql(List<CitationTimeRange> value) =>
      json.encode(value.map((i) => i.toMap()).toList());
}

class CitationRectListConverter
    extends TypeConverter<List<CitationRect>, String> {
  const CitationRectListConverter();
  @override
  List<CitationRect> fromSql(String fromDb) => (json.decode(fromDb) as List)
      .map((i) => CitationRect.fromMap(i as Map<String, dynamic>))
      .toList();
  @override
  String toSql(List<CitationRect> value) =>
      json.encode(value.map((i) => i.toMap()).toList());
}
