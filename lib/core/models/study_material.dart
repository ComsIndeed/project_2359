import 'dart:convert';

abstract class StudyMaterial {
  final String id;
  StudyMaterialType get materialType;

  StudyMaterial({required this.id});

  // Abstract serialization methods
  Map<String, dynamic> toMap();
  String toJson() => json.encode(toMap());

  // Abstract copyWith
  StudyMaterial copyWith({String? id});

  // Factory constructor to create the correct subclass from a map
  static StudyMaterial fromMap(Map<String, dynamic> map) {
    final typeString = map['type'] as String;
    final type = StudyMaterialType.values.firstWhere(
      (e) => e.name == typeString,
    );

    switch (type) {
      case StudyMaterialType.multipleChoiceQuestion:
        return StudyMaterialMultipleChoiceQuestion.fromMap(map);
      case StudyMaterialType.freeTextQuestion:
        return StudyMaterialFreeTextQuestion.fromMap(map);
      case StudyMaterialType.imageOcclusion:
        throw UnimplementedError('ImageOcclusion not yet implemented');
    }
  }

  // Factory constructor to create from JSON string
  static StudyMaterial fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

enum StudyMaterialType {
  multipleChoiceQuestion,
  freeTextQuestion,
  imageOcclusion,
}

class StudyMaterialMultipleChoiceQuestion extends StudyMaterial {
  @override
  StudyMaterialType get materialType =>
      StudyMaterialType.multipleChoiceQuestion;
  final String question;
  final List<String> options;
  final String answer;

  StudyMaterialMultipleChoiceQuestion({
    required super.id,
    required this.question,
    required this.options,
    required this.answer,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': materialType.name,
      'question': question,
      'options': options,
      'answer': answer,
    };
  }

  factory StudyMaterialMultipleChoiceQuestion.fromMap(
    Map<String, dynamic> map,
  ) {
    return StudyMaterialMultipleChoiceQuestion(
      id: map['id'] as String,
      question: map['question'] as String,
      options: List<String>.from(map['options'] as List),
      answer: map['answer'] as String,
    );
  }

  factory StudyMaterialMultipleChoiceQuestion.fromJson(String source) =>
      StudyMaterialMultipleChoiceQuestion.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  StudyMaterialMultipleChoiceQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    String? answer,
  }) {
    return StudyMaterialMultipleChoiceQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      answer: answer ?? this.answer,
    );
  }
}

class StudyMaterialFreeTextQuestion extends StudyMaterial {
  @override
  StudyMaterialType get materialType => StudyMaterialType.freeTextQuestion;
  final String question;
  final String answer;

  StudyMaterialFreeTextQuestion({
    required super.id,
    required this.question,
    required this.answer,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': materialType.name,
      'question': question,
      'answer': answer,
    };
  }

  factory StudyMaterialFreeTextQuestion.fromMap(Map<String, dynamic> map) {
    return StudyMaterialFreeTextQuestion(
      id: map['id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
    );
  }

  factory StudyMaterialFreeTextQuestion.fromJson(String source) =>
      StudyMaterialFreeTextQuestion.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  StudyMaterialFreeTextQuestion copyWith({
    String? id,
    String? question,
    String? answer,
  }) {
    return StudyMaterialFreeTextQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}
