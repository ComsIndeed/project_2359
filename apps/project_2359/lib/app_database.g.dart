// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SourceItemsTable extends SourceItems
    with TableInfo<$SourceItemsTable, SourceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indexContentMeta = const VerificationMeta(
    'indexContent',
  );
  @override
  late final GeneratedColumn<String> indexContent = GeneratedColumn<String>(
    'index_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label, path, type, indexContent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('index_content')) {
      context.handle(
        _indexContentMeta,
        indexContent.isAcceptableOrUnknown(
          data['index_content']!,
          _indexContentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SourceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      indexContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}index_content'],
      ),
    );
  }

  @override
  $SourceItemsTable createAlias(String alias) {
    return $SourceItemsTable(attachedDatabase, alias);
  }
}

class SourceItem extends DataClass implements Insertable<SourceItem> {
  final String id;
  final String label;
  final String? path;
  final String type;
  final String? indexContent;
  const SourceItem({
    required this.id,
    required this.label,
    this.path,
    required this.type,
    this.indexContent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || indexContent != null) {
      map['index_content'] = Variable<String>(indexContent);
    }
    return map;
  }

  SourceItemsCompanion toCompanion(bool nullToAbsent) {
    return SourceItemsCompanion(
      id: Value(id),
      label: Value(label),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      type: Value(type),
      indexContent: indexContent == null && nullToAbsent
          ? const Value.absent()
          : Value(indexContent),
    );
  }

  factory SourceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceItem(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      path: serializer.fromJson<String?>(json['path']),
      type: serializer.fromJson<String>(json['type']),
      indexContent: serializer.fromJson<String?>(json['indexContent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'path': serializer.toJson<String?>(path),
      'type': serializer.toJson<String>(type),
      'indexContent': serializer.toJson<String?>(indexContent),
    };
  }

  SourceItem copyWith({
    String? id,
    String? label,
    Value<String?> path = const Value.absent(),
    String? type,
    Value<String?> indexContent = const Value.absent(),
  }) => SourceItem(
    id: id ?? this.id,
    label: label ?? this.label,
    path: path.present ? path.value : this.path,
    type: type ?? this.type,
    indexContent: indexContent.present ? indexContent.value : this.indexContent,
  );
  SourceItem copyWithCompanion(SourceItemsCompanion data) {
    return SourceItem(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      path: data.path.present ? data.path.value : this.path,
      type: data.type.present ? data.type.value : this.type,
      indexContent: data.indexContent.present
          ? data.indexContent.value
          : this.indexContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceItem(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('indexContent: $indexContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, path, type, indexContent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceItem &&
          other.id == this.id &&
          other.label == this.label &&
          other.path == this.path &&
          other.type == this.type &&
          other.indexContent == this.indexContent);
}

class SourceItemsCompanion extends UpdateCompanion<SourceItem> {
  final Value<String> id;
  final Value<String> label;
  final Value<String?> path;
  final Value<String> type;
  final Value<String?> indexContent;
  final Value<int> rowid;
  const SourceItemsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.path = const Value.absent(),
    this.type = const Value.absent(),
    this.indexContent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceItemsCompanion.insert({
    required String id,
    required String label,
    this.path = const Value.absent(),
    required String type,
    this.indexContent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       type = Value(type);
  static Insertable<SourceItem> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? path,
    Expression<String>? type,
    Expression<String>? indexContent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (path != null) 'path': path,
      if (type != null) 'type': type,
      if (indexContent != null) 'index_content': indexContent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String?>? path,
    Value<String>? type,
    Value<String?>? indexContent,
    Value<int>? rowid,
  }) {
    return SourceItemsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      path: path ?? this.path,
      type: type ?? this.type,
      indexContent: indexContent ?? this.indexContent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (indexContent.present) {
      map['index_content'] = Variable<String>(indexContent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceItemsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('indexContent: $indexContent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyMaterialItemsTable extends StudyMaterialItems
    with TableInfo<$StudyMaterialItemsTable, StudyMaterialItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyMaterialItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialTypeMeta = const VerificationMeta(
    'materialType',
  );
  @override
  late final GeneratedColumn<String> materialType = GeneratedColumn<String>(
    'material_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _citationJsonMeta = const VerificationMeta(
    'citationJson',
  );
  @override
  late final GeneratedColumn<String> citationJson = GeneratedColumn<String>(
    'citation_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _optionsListJsonMeta = const VerificationMeta(
    'optionsListJson',
  );
  @override
  late final GeneratedColumn<String> optionsListJson = GeneratedColumn<String>(
    'options_list_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    materialType,
    citationJson,
    question,
    optionsListJson,
    answer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_material_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyMaterialItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('material_type')) {
      context.handle(
        _materialTypeMeta,
        materialType.isAcceptableOrUnknown(
          data['material_type']!,
          _materialTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_materialTypeMeta);
    }
    if (data.containsKey('citation_json')) {
      context.handle(
        _citationJsonMeta,
        citationJson.isAcceptableOrUnknown(
          data['citation_json']!,
          _citationJsonMeta,
        ),
      );
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    }
    if (data.containsKey('options_list_json')) {
      context.handle(
        _optionsListJsonMeta,
        optionsListJson.isAcceptableOrUnknown(
          data['options_list_json']!,
          _optionsListJsonMeta,
        ),
      );
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyMaterialItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyMaterialItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      materialType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_type'],
      )!,
      citationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}citation_json'],
      ),
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      ),
      optionsListJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_list_json'],
      ),
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      ),
    );
  }

  @override
  $StudyMaterialItemsTable createAlias(String alias) {
    return $StudyMaterialItemsTable(attachedDatabase, alias);
  }
}

class StudyMaterialItem extends DataClass
    implements Insertable<StudyMaterialItem> {
  final String id;
  final String packId;
  final String materialType;
  final String? citationJson;

  /// Everything else is nullable because not all types will have the same props.
  /// MCQ: Question, choices, answer
  /// Free-Text: Question, answer
  /// Image Occlusion (not yet implemented; under drafting): List of {question -> answer, and their coordinates and masking values}
  final String? question;
  final String? optionsListJson;
  final String? answer;
  const StudyMaterialItem({
    required this.id,
    required this.packId,
    required this.materialType,
    this.citationJson,
    this.question,
    this.optionsListJson,
    this.answer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['material_type'] = Variable<String>(materialType);
    if (!nullToAbsent || citationJson != null) {
      map['citation_json'] = Variable<String>(citationJson);
    }
    if (!nullToAbsent || question != null) {
      map['question'] = Variable<String>(question);
    }
    if (!nullToAbsent || optionsListJson != null) {
      map['options_list_json'] = Variable<String>(optionsListJson);
    }
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    return map;
  }

  StudyMaterialItemsCompanion toCompanion(bool nullToAbsent) {
    return StudyMaterialItemsCompanion(
      id: Value(id),
      packId: Value(packId),
      materialType: Value(materialType),
      citationJson: citationJson == null && nullToAbsent
          ? const Value.absent()
          : Value(citationJson),
      question: question == null && nullToAbsent
          ? const Value.absent()
          : Value(question),
      optionsListJson: optionsListJson == null && nullToAbsent
          ? const Value.absent()
          : Value(optionsListJson),
      answer: answer == null && nullToAbsent
          ? const Value.absent()
          : Value(answer),
    );
  }

  factory StudyMaterialItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyMaterialItem(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      materialType: serializer.fromJson<String>(json['materialType']),
      citationJson: serializer.fromJson<String?>(json['citationJson']),
      question: serializer.fromJson<String?>(json['question']),
      optionsListJson: serializer.fromJson<String?>(json['optionsListJson']),
      answer: serializer.fromJson<String?>(json['answer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'materialType': serializer.toJson<String>(materialType),
      'citationJson': serializer.toJson<String?>(citationJson),
      'question': serializer.toJson<String?>(question),
      'optionsListJson': serializer.toJson<String?>(optionsListJson),
      'answer': serializer.toJson<String?>(answer),
    };
  }

  StudyMaterialItem copyWith({
    String? id,
    String? packId,
    String? materialType,
    Value<String?> citationJson = const Value.absent(),
    Value<String?> question = const Value.absent(),
    Value<String?> optionsListJson = const Value.absent(),
    Value<String?> answer = const Value.absent(),
  }) => StudyMaterialItem(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    materialType: materialType ?? this.materialType,
    citationJson: citationJson.present ? citationJson.value : this.citationJson,
    question: question.present ? question.value : this.question,
    optionsListJson: optionsListJson.present
        ? optionsListJson.value
        : this.optionsListJson,
    answer: answer.present ? answer.value : this.answer,
  );
  StudyMaterialItem copyWithCompanion(StudyMaterialItemsCompanion data) {
    return StudyMaterialItem(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      materialType: data.materialType.present
          ? data.materialType.value
          : this.materialType,
      citationJson: data.citationJson.present
          ? data.citationJson.value
          : this.citationJson,
      question: data.question.present ? data.question.value : this.question,
      optionsListJson: data.optionsListJson.present
          ? data.optionsListJson.value
          : this.optionsListJson,
      answer: data.answer.present ? data.answer.value : this.answer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyMaterialItem(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('materialType: $materialType, ')
          ..write('citationJson: $citationJson, ')
          ..write('question: $question, ')
          ..write('optionsListJson: $optionsListJson, ')
          ..write('answer: $answer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    materialType,
    citationJson,
    question,
    optionsListJson,
    answer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyMaterialItem &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.materialType == this.materialType &&
          other.citationJson == this.citationJson &&
          other.question == this.question &&
          other.optionsListJson == this.optionsListJson &&
          other.answer == this.answer);
}

class StudyMaterialItemsCompanion extends UpdateCompanion<StudyMaterialItem> {
  final Value<String> id;
  final Value<String> packId;
  final Value<String> materialType;
  final Value<String?> citationJson;
  final Value<String?> question;
  final Value<String?> optionsListJson;
  final Value<String?> answer;
  final Value<int> rowid;
  const StudyMaterialItemsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.materialType = const Value.absent(),
    this.citationJson = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyMaterialItemsCompanion.insert({
    required String id,
    required String packId,
    required String materialType,
    this.citationJson = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       materialType = Value(materialType);
  static Insertable<StudyMaterialItem> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<String>? materialType,
    Expression<String>? citationJson,
    Expression<String>? question,
    Expression<String>? optionsListJson,
    Expression<String>? answer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (materialType != null) 'material_type': materialType,
      if (citationJson != null) 'citation_json': citationJson,
      if (question != null) 'question': question,
      if (optionsListJson != null) 'options_list_json': optionsListJson,
      if (answer != null) 'answer': answer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyMaterialItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<String>? materialType,
    Value<String?>? citationJson,
    Value<String?>? question,
    Value<String?>? optionsListJson,
    Value<String?>? answer,
    Value<int>? rowid,
  }) {
    return StudyMaterialItemsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      materialType: materialType ?? this.materialType,
      citationJson: citationJson ?? this.citationJson,
      question: question ?? this.question,
      optionsListJson: optionsListJson ?? this.optionsListJson,
      answer: answer ?? this.answer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (materialType.present) {
      map['material_type'] = Variable<String>(materialType.value);
    }
    if (citationJson.present) {
      map['citation_json'] = Variable<String>(citationJson.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (optionsListJson.present) {
      map['options_list_json'] = Variable<String>(optionsListJson.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyMaterialItemsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('materialType: $materialType, ')
          ..write('citationJson: $citationJson, ')
          ..write('question: $question, ')
          ..write('optionsListJson: $optionsListJson, ')
          ..write('answer: $answer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyMaterialPackItemsTable extends StudyMaterialPackItems
    with TableInfo<$StudyMaterialPackItemsTable, StudyMaterialPackItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyMaterialPackItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_material_pack_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyMaterialPackItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyMaterialPackItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyMaterialPackItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $StudyMaterialPackItemsTable createAlias(String alias) {
    return $StudyMaterialPackItemsTable(attachedDatabase, alias);
  }
}

class StudyMaterialPackItem extends DataClass
    implements Insertable<StudyMaterialPackItem> {
  final String id;
  final String name;
  final String? description;
  const StudyMaterialPackItem({
    required this.id,
    required this.name,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  StudyMaterialPackItemsCompanion toCompanion(bool nullToAbsent) {
    return StudyMaterialPackItemsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory StudyMaterialPackItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyMaterialPackItem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
    };
  }

  StudyMaterialPackItem copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
  }) => StudyMaterialPackItem(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
  );
  StudyMaterialPackItem copyWithCompanion(
    StudyMaterialPackItemsCompanion data,
  ) {
    return StudyMaterialPackItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyMaterialPackItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyMaterialPackItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class StudyMaterialPackItemsCompanion
    extends UpdateCompanion<StudyMaterialPackItem> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> rowid;
  const StudyMaterialPackItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyMaterialPackItemsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<StudyMaterialPackItem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyMaterialPackItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return StudyMaterialPackItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyMaterialPackItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SourceItemsTable sourceItems = $SourceItemsTable(this);
  late final $StudyMaterialItemsTable studyMaterialItems =
      $StudyMaterialItemsTable(this);
  late final $StudyMaterialPackItemsTable studyMaterialPackItems =
      $StudyMaterialPackItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sourceItems,
    studyMaterialItems,
    studyMaterialPackItems,
  ];
}

typedef $$SourceItemsTableCreateCompanionBuilder =
    SourceItemsCompanion Function({
      required String id,
      required String label,
      Value<String?> path,
      required String type,
      Value<String?> indexContent,
      Value<int> rowid,
    });
typedef $$SourceItemsTableUpdateCompanionBuilder =
    SourceItemsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String?> path,
      Value<String> type,
      Value<String?> indexContent,
      Value<int> rowid,
    });

class $$SourceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceItemsTable> {
  $$SourceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get indexContent => $composableBuilder(
    column: $table.indexContent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceItemsTable> {
  $$SourceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get indexContent => $composableBuilder(
    column: $table.indexContent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceItemsTable> {
  $$SourceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get indexContent => $composableBuilder(
    column: $table.indexContent,
    builder: (column) => column,
  );
}

class $$SourceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceItemsTable,
          SourceItem,
          $$SourceItemsTableFilterComposer,
          $$SourceItemsTableOrderingComposer,
          $$SourceItemsTableAnnotationComposer,
          $$SourceItemsTableCreateCompanionBuilder,
          $$SourceItemsTableUpdateCompanionBuilder,
          (
            SourceItem,
            BaseReferences<_$AppDatabase, $SourceItemsTable, SourceItem>,
          ),
          SourceItem,
          PrefetchHooks Function()
        > {
  $$SourceItemsTableTableManager(_$AppDatabase db, $SourceItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> indexContent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceItemsCompanion(
                id: id,
                label: label,
                path: path,
                type: type,
                indexContent: indexContent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<String?> path = const Value.absent(),
                required String type,
                Value<String?> indexContent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceItemsCompanion.insert(
                id: id,
                label: label,
                path: path,
                type: type,
                indexContent: indexContent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceItemsTable,
      SourceItem,
      $$SourceItemsTableFilterComposer,
      $$SourceItemsTableOrderingComposer,
      $$SourceItemsTableAnnotationComposer,
      $$SourceItemsTableCreateCompanionBuilder,
      $$SourceItemsTableUpdateCompanionBuilder,
      (
        SourceItem,
        BaseReferences<_$AppDatabase, $SourceItemsTable, SourceItem>,
      ),
      SourceItem,
      PrefetchHooks Function()
    >;
typedef $$StudyMaterialItemsTableCreateCompanionBuilder =
    StudyMaterialItemsCompanion Function({
      required String id,
      required String packId,
      required String materialType,
      Value<String?> citationJson,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<int> rowid,
    });
typedef $$StudyMaterialItemsTableUpdateCompanionBuilder =
    StudyMaterialItemsCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<String> materialType,
      Value<String?> citationJson,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<int> rowid,
    });

class $$StudyMaterialItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyMaterialItemsTable> {
  $$StudyMaterialItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get materialType => $composableBuilder(
    column: $table.materialType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get citationJson => $composableBuilder(
    column: $table.citationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsListJson => $composableBuilder(
    column: $table.optionsListJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyMaterialItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyMaterialItemsTable> {
  $$StudyMaterialItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get materialType => $composableBuilder(
    column: $table.materialType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citationJson => $composableBuilder(
    column: $table.citationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsListJson => $composableBuilder(
    column: $table.optionsListJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyMaterialItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyMaterialItemsTable> {
  $$StudyMaterialItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get materialType => $composableBuilder(
    column: $table.materialType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get citationJson => $composableBuilder(
    column: $table.citationJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get optionsListJson => $composableBuilder(
    column: $table.optionsListJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);
}

class $$StudyMaterialItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyMaterialItemsTable,
          StudyMaterialItem,
          $$StudyMaterialItemsTableFilterComposer,
          $$StudyMaterialItemsTableOrderingComposer,
          $$StudyMaterialItemsTableAnnotationComposer,
          $$StudyMaterialItemsTableCreateCompanionBuilder,
          $$StudyMaterialItemsTableUpdateCompanionBuilder,
          (
            StudyMaterialItem,
            BaseReferences<
              _$AppDatabase,
              $StudyMaterialItemsTable,
              StudyMaterialItem
            >,
          ),
          StudyMaterialItem,
          PrefetchHooks Function()
        > {
  $$StudyMaterialItemsTableTableManager(
    _$AppDatabase db,
    $StudyMaterialItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyMaterialItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyMaterialItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyMaterialItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> materialType = const Value.absent(),
                Value<String?> citationJson = const Value.absent(),
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyMaterialItemsCompanion(
                id: id,
                packId: packId,
                materialType: materialType,
                citationJson: citationJson,
                question: question,
                optionsListJson: optionsListJson,
                answer: answer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required String materialType,
                Value<String?> citationJson = const Value.absent(),
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyMaterialItemsCompanion.insert(
                id: id,
                packId: packId,
                materialType: materialType,
                citationJson: citationJson,
                question: question,
                optionsListJson: optionsListJson,
                answer: answer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyMaterialItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyMaterialItemsTable,
      StudyMaterialItem,
      $$StudyMaterialItemsTableFilterComposer,
      $$StudyMaterialItemsTableOrderingComposer,
      $$StudyMaterialItemsTableAnnotationComposer,
      $$StudyMaterialItemsTableCreateCompanionBuilder,
      $$StudyMaterialItemsTableUpdateCompanionBuilder,
      (
        StudyMaterialItem,
        BaseReferences<
          _$AppDatabase,
          $StudyMaterialItemsTable,
          StudyMaterialItem
        >,
      ),
      StudyMaterialItem,
      PrefetchHooks Function()
    >;
typedef $$StudyMaterialPackItemsTableCreateCompanionBuilder =
    StudyMaterialPackItemsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$StudyMaterialPackItemsTableUpdateCompanionBuilder =
    StudyMaterialPackItemsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<int> rowid,
    });

class $$StudyMaterialPackItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyMaterialPackItemsTable> {
  $$StudyMaterialPackItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyMaterialPackItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyMaterialPackItemsTable> {
  $$StudyMaterialPackItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyMaterialPackItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyMaterialPackItemsTable> {
  $$StudyMaterialPackItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$StudyMaterialPackItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyMaterialPackItemsTable,
          StudyMaterialPackItem,
          $$StudyMaterialPackItemsTableFilterComposer,
          $$StudyMaterialPackItemsTableOrderingComposer,
          $$StudyMaterialPackItemsTableAnnotationComposer,
          $$StudyMaterialPackItemsTableCreateCompanionBuilder,
          $$StudyMaterialPackItemsTableUpdateCompanionBuilder,
          (
            StudyMaterialPackItem,
            BaseReferences<
              _$AppDatabase,
              $StudyMaterialPackItemsTable,
              StudyMaterialPackItem
            >,
          ),
          StudyMaterialPackItem,
          PrefetchHooks Function()
        > {
  $$StudyMaterialPackItemsTableTableManager(
    _$AppDatabase db,
    $StudyMaterialPackItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyMaterialPackItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StudyMaterialPackItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StudyMaterialPackItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyMaterialPackItemsCompanion(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyMaterialPackItemsCompanion.insert(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyMaterialPackItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyMaterialPackItemsTable,
      StudyMaterialPackItem,
      $$StudyMaterialPackItemsTableFilterComposer,
      $$StudyMaterialPackItemsTableOrderingComposer,
      $$StudyMaterialPackItemsTableAnnotationComposer,
      $$StudyMaterialPackItemsTableCreateCompanionBuilder,
      $$StudyMaterialPackItemsTableUpdateCompanionBuilder,
      (
        StudyMaterialPackItem,
        BaseReferences<
          _$AppDatabase,
          $StudyMaterialPackItemsTable,
          StudyMaterialPackItem
        >,
      ),
      StudyMaterialPackItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SourceItemsTableTableManager get sourceItems =>
      $$SourceItemsTableTableManager(_db, _db.sourceItems);
  $$StudyMaterialItemsTableTableManager get studyMaterialItems =>
      $$StudyMaterialItemsTableTableManager(_db, _db.studyMaterialItems);
  $$StudyMaterialPackItemsTableTableManager get studyMaterialPackItems =>
      $$StudyMaterialPackItemsTableTableManager(
        _db,
        _db.studyMaterialPackItems,
      );
}
