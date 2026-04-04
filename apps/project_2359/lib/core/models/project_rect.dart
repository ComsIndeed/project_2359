import 'dart:convert';

/// A bounding box for document sources, based on [PdfRect] coordinates.
class ProjectRect {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const ProjectRect({
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

  factory ProjectRect.fromMap(Map<String, dynamic> map) => ProjectRect(
    left: (map['left'] as num).toDouble(),
    top: (map['top'] as num).toDouble(),
    right: (map['right'] as num).toDouble(),
    bottom: (map['bottom'] as num).toDouble(),
  );

  String toJson() => json.encode(toMap());

  factory ProjectRect.fromJson(String source) =>
      ProjectRect.fromMap(json.decode(source) as Map<String, dynamic>);
}
