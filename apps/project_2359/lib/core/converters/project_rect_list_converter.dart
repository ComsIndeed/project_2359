import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:project_2359/core/models/project_rect.dart';

class ProjectRectListConverter
    extends TypeConverter<List<ProjectRect>, String> {
  const ProjectRectListConverter();
  @override
  List<ProjectRect> fromSql(String fromDb) => (json.decode(fromDb) as List)
      .map((i) => ProjectRect.fromMap(i as Map<String, dynamic>))
      .toList();
  @override
  String toSql(List<ProjectRect> value) =>
      json.encode(value.map((i) => i.toMap()).toList());
}
