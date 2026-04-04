import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:project_2359/core/models/project_time_range.dart';

class ProjectTimeRangeListConverter
    extends TypeConverter<List<ProjectTimeRange>, String> {
  const ProjectTimeRangeListConverter();
  @override
  List<ProjectTimeRange> fromSql(String fromDb) => (json.decode(fromDb) as List)
      .map((i) => ProjectTimeRange.fromMap(i as Map<String, dynamic>))
      .toList();
  @override
  String toSql(List<ProjectTimeRange> value) =>
      json.encode(value.map((i) => i.toMap()).toList());
}
