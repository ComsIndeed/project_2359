import 'dart:convert';

/// A time range segment for playable sources.
class ProjectTimeRange {
  final double start;
  final double end;

  const ProjectTimeRange({required this.start, required this.end});

  Map<String, dynamic> toMap() => {'start': start, 'end': end};

  factory ProjectTimeRange.fromMap(Map<String, dynamic> map) =>
      ProjectTimeRange(
        start: (map['start'] as num).toDouble(),
        end: (map['end'] as num).toDouble(),
      );

  String toJson() => json.encode(toMap());

  factory ProjectTimeRange.fromJson(String source) =>
      ProjectTimeRange.fromMap(json.decode(source) as Map<String, dynamic>);
}
