import 'dart:convert';
import 'package:project_2359/core/models/study_material.dart';

class StudyMaterialPack {
  final String id;
  final String name;
  final String? description;
  final List<StudyMaterial> studyMaterials;

  StudyMaterialPack({
    required this.id,
    required this.name,
    this.description,
    required this.studyMaterials,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'studyMaterials': studyMaterials.map((m) => m.toMap()).toList(),
    };
  }

  factory StudyMaterialPack.fromMap(Map<String, dynamic> map) {
    return StudyMaterialPack(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      studyMaterials: (map['studyMaterials'] as List)
          .map((item) => StudyMaterial.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudyMaterialPack.fromJson(String source) =>
      StudyMaterialPack.fromMap(json.decode(source) as Map<String, dynamic>);

  StudyMaterialPack copyWith({
    String? id,
    String? name,
    String? description,
    List<StudyMaterial>? studyMaterials,
  }) {
    return StudyMaterialPack(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      studyMaterials: studyMaterials ?? this.studyMaterials,
    );
  }
}
