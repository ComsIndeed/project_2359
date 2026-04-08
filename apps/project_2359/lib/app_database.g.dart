// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudyFolderItemsTable extends StudyFolderItems
    with TableInfo<$StudyFolderItemsTable, StudyFolderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyFolderItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    updatedAt,
    isPinned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_folder_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyFolderItem> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyFolderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyFolderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
    );
  }

  @override
  $StudyFolderItemsTable createAlias(String alias) {
    return $StudyFolderItemsTable(attachedDatabase, alias);
  }
}

class StudyFolderItem extends DataClass implements Insertable<StudyFolderItem> {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final bool isPinned;
  const StudyFolderItem({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['is_pinned'] = Variable<bool>(isPinned);
    return map;
  }

  StudyFolderItemsCompanion toCompanion(bool nullToAbsent) {
    return StudyFolderItemsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isPinned: Value(isPinned),
    );
  }

  factory StudyFolderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyFolderItem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'isPinned': serializer.toJson<bool>(isPinned),
    };
  }

  StudyFolderItem copyWith({
    String? id,
    String? name,
    String? createdAt,
    String? updatedAt,
    bool? isPinned,
  }) => StudyFolderItem(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isPinned: isPinned ?? this.isPinned,
  );
  StudyFolderItem copyWithCompanion(StudyFolderItemsCompanion data) {
    return StudyFolderItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyFolderItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt, isPinned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyFolderItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isPinned == this.isPinned);
}

class StudyFolderItemsCompanion extends UpdateCompanion<StudyFolderItem> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<bool> isPinned;
  final Value<int> rowid;
  const StudyFolderItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyFolderItemsCompanion.insert({
    required String id,
    required String name,
    required String createdAt,
    required String updatedAt,
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StudyFolderItem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<bool>? isPinned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isPinned != null) 'is_pinned': isPinned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyFolderItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<bool>? isPinned,
    Value<int>? rowid,
  }) {
    return StudyFolderItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
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
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyFolderItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_folder_items (id)',
    ),
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
  @override
  late final GeneratedColumnWithTypeConverter<MediaType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaType>($SourceItemsTable.$convertertype);
  static const VerificationMeta _extractedContentMeta = const VerificationMeta(
    'extractedContent',
  );
  @override
  late final GeneratedColumn<String> extractedContent = GeneratedColumn<String>(
    'extracted_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    label,
    path,
    type,
    extractedContent,
    isPinned,
  ];
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
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
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
    if (data.containsKey('extracted_content')) {
      context.handle(
        _extractedContentMeta,
        extractedContent.isAcceptableOrUnknown(
          data['extracted_content']!,
          _extractedContentMeta,
        ),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      ),
      type: $SourceItemsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      extractedContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_content'],
      ),
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
    );
  }

  @override
  $SourceItemsTable createAlias(String alias) {
    return $SourceItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaType, String, String> $convertertype =
      const EnumNameConverter<MediaType>(MediaType.values);
}

class SourceItem extends DataClass implements Insertable<SourceItem> {
  final String id;
  final String? folderId;
  final String label;
  final String? path;
  final MediaType type;
  final String? extractedContent;
  final bool isPinned;
  const SourceItem({
    required this.id,
    this.folderId,
    required this.label,
    this.path,
    required this.type,
    this.extractedContent,
    required this.isPinned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<String>(folderId);
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    {
      map['type'] = Variable<String>(
        $SourceItemsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || extractedContent != null) {
      map['extracted_content'] = Variable<String>(extractedContent);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    return map;
  }

  SourceItemsCompanion toCompanion(bool nullToAbsent) {
    return SourceItemsCompanion(
      id: Value(id),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      label: Value(label),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      type: Value(type),
      extractedContent: extractedContent == null && nullToAbsent
          ? const Value.absent()
          : Value(extractedContent),
      isPinned: Value(isPinned),
    );
  }

  factory SourceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceItem(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String?>(json['folderId']),
      label: serializer.fromJson<String>(json['label']),
      path: serializer.fromJson<String?>(json['path']),
      type: $SourceItemsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      extractedContent: serializer.fromJson<String?>(json['extractedContent']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String?>(folderId),
      'label': serializer.toJson<String>(label),
      'path': serializer.toJson<String?>(path),
      'type': serializer.toJson<String>(
        $SourceItemsTable.$convertertype.toJson(type),
      ),
      'extractedContent': serializer.toJson<String?>(extractedContent),
      'isPinned': serializer.toJson<bool>(isPinned),
    };
  }

  SourceItem copyWith({
    String? id,
    Value<String?> folderId = const Value.absent(),
    String? label,
    Value<String?> path = const Value.absent(),
    MediaType? type,
    Value<String?> extractedContent = const Value.absent(),
    bool? isPinned,
  }) => SourceItem(
    id: id ?? this.id,
    folderId: folderId.present ? folderId.value : this.folderId,
    label: label ?? this.label,
    path: path.present ? path.value : this.path,
    type: type ?? this.type,
    extractedContent: extractedContent.present
        ? extractedContent.value
        : this.extractedContent,
    isPinned: isPinned ?? this.isPinned,
  );
  SourceItem copyWithCompanion(SourceItemsCompanion data) {
    return SourceItem(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      label: data.label.present ? data.label.value : this.label,
      path: data.path.present ? data.path.value : this.path,
      type: data.type.present ? data.type.value : this.type,
      extractedContent: data.extractedContent.present
          ? data.extractedContent.value
          : this.extractedContent,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceItem(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('label: $label, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('extractedContent: $extractedContent, ')
          ..write('isPinned: $isPinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, folderId, label, path, type, extractedContent, isPinned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceItem &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.label == this.label &&
          other.path == this.path &&
          other.type == this.type &&
          other.extractedContent == this.extractedContent &&
          other.isPinned == this.isPinned);
}

class SourceItemsCompanion extends UpdateCompanion<SourceItem> {
  final Value<String> id;
  final Value<String?> folderId;
  final Value<String> label;
  final Value<String?> path;
  final Value<MediaType> type;
  final Value<String?> extractedContent;
  final Value<bool> isPinned;
  final Value<int> rowid;
  const SourceItemsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.label = const Value.absent(),
    this.path = const Value.absent(),
    this.type = const Value.absent(),
    this.extractedContent = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceItemsCompanion.insert({
    required String id,
    this.folderId = const Value.absent(),
    required String label,
    this.path = const Value.absent(),
    required MediaType type,
    this.extractedContent = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       type = Value(type);
  static Insertable<SourceItem> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? label,
    Expression<String>? path,
    Expression<String>? type,
    Expression<String>? extractedContent,
    Expression<bool>? isPinned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (label != null) 'label': label,
      if (path != null) 'path': path,
      if (type != null) 'type': type,
      if (extractedContent != null) 'extracted_content': extractedContent,
      if (isPinned != null) 'is_pinned': isPinned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? folderId,
    Value<String>? label,
    Value<String?>? path,
    Value<MediaType>? type,
    Value<String?>? extractedContent,
    Value<bool>? isPinned,
    Value<int>? rowid,
  }) {
    return SourceItemsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      label: label ?? this.label,
      path: path ?? this.path,
      type: type ?? this.type,
      extractedContent: extractedContent ?? this.extractedContent,
      isPinned: isPinned ?? this.isPinned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $SourceItemsTable.$convertertype.toSql(type.value),
      );
    }
    if (extractedContent.present) {
      map['extracted_content'] = Variable<String>(extractedContent.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
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
          ..write('folderId: $folderId, ')
          ..write('label: $label, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('extractedContent: $extractedContent, ')
          ..write('isPinned: $isPinned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeckItemsTable extends DeckItems
    with TableInfo<$DeckItemsTable, DeckItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_folder_items (id)',
    ),
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
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    name,
    description,
    isPinned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
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
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeckItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
    );
  }

  @override
  $DeckItemsTable createAlias(String alias) {
    return $DeckItemsTable(attachedDatabase, alias);
  }
}

class DeckItem extends DataClass implements Insertable<DeckItem> {
  final String id;
  final String folderId;
  final String name;
  final String? description;
  final bool isPinned;
  const DeckItem({
    required this.id,
    required this.folderId,
    required this.name,
    this.description,
    required this.isPinned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder_id'] = Variable<String>(folderId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    return map;
  }

  DeckItemsCompanion toCompanion(bool nullToAbsent) {
    return DeckItemsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isPinned: Value(isPinned),
    );
  }

  factory DeckItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckItem(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String>(json['folderId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String>(folderId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isPinned': serializer.toJson<bool>(isPinned),
    };
  }

  DeckItem copyWith({
    String? id,
    String? folderId,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? isPinned,
  }) => DeckItem(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isPinned: isPinned ?? this.isPinned,
  );
  DeckItem copyWithCompanion(DeckItemsCompanion data) {
    return DeckItem(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckItem(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isPinned: $isPinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, folderId, name, description, isPinned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckItem &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.name == this.name &&
          other.description == this.description &&
          other.isPinned == this.isPinned);
}

class DeckItemsCompanion extends UpdateCompanion<DeckItem> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> isPinned;
  final Value<int> rowid;
  const DeckItemsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeckItemsCompanion.insert({
    required String id,
    required String folderId,
    required String name,
    this.description = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       name = Value(name);
  static Insertable<DeckItem> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? isPinned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isPinned != null) 'is_pinned': isPinned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeckItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? isPinned,
    Value<int>? rowid,
  }) {
    return DeckItemsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      name: name ?? this.name,
      description: description ?? this.description,
      isPinned: isPinned ?? this.isPinned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckItemsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isPinned: $isPinned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceItemBlobsTable extends SourceItemBlobs
    with TableInfo<$SourceItemBlobsTable, SourceItemBlob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceItemBlobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceItemIdMeta = const VerificationMeta(
    'sourceItemId',
  );
  @override
  late final GeneratedColumn<String> sourceItemId = GeneratedColumn<String>(
    'source_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceItemNameMeta = const VerificationMeta(
    'sourceItemName',
  );
  @override
  late final GeneratedColumn<String> sourceItemName = GeneratedColumn<String>(
    'source_item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SourceFileType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SourceFileType>($SourceItemBlobsTable.$convertertype);
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<Uint8List> bytes = GeneratedColumn<Uint8List>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceItemId,
    sourceItemName,
    type,
    bytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_item_blobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceItemBlob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_item_id')) {
      context.handle(
        _sourceItemIdMeta,
        sourceItemId.isAcceptableOrUnknown(
          data['source_item_id']!,
          _sourceItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceItemIdMeta);
    }
    if (data.containsKey('source_item_name')) {
      context.handle(
        _sourceItemNameMeta,
        sourceItemName.isAcceptableOrUnknown(
          data['source_item_name']!,
          _sourceItemNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceItemNameMeta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceItemBlob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceItemBlob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_item_id'],
      )!,
      sourceItemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_item_name'],
      )!,
      type: $SourceItemBlobsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      )!,
    );
  }

  @override
  $SourceItemBlobsTable createAlias(String alias) {
    return $SourceItemBlobsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceFileType, String, String> $convertertype =
      const EnumNameConverter<SourceFileType>(SourceFileType.values);
}

class SourceItemBlob extends DataClass implements Insertable<SourceItemBlob> {
  final String id;
  final String sourceItemId;
  final String sourceItemName;
  final SourceFileType type;
  final Uint8List bytes;
  const SourceItemBlob({
    required this.id,
    required this.sourceItemId,
    required this.sourceItemName,
    required this.type,
    required this.bytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_item_id'] = Variable<String>(sourceItemId);
    map['source_item_name'] = Variable<String>(sourceItemName);
    {
      map['type'] = Variable<String>(
        $SourceItemBlobsTable.$convertertype.toSql(type),
      );
    }
    map['bytes'] = Variable<Uint8List>(bytes);
    return map;
  }

  SourceItemBlobsCompanion toCompanion(bool nullToAbsent) {
    return SourceItemBlobsCompanion(
      id: Value(id),
      sourceItemId: Value(sourceItemId),
      sourceItemName: Value(sourceItemName),
      type: Value(type),
      bytes: Value(bytes),
    );
  }

  factory SourceItemBlob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceItemBlob(
      id: serializer.fromJson<String>(json['id']),
      sourceItemId: serializer.fromJson<String>(json['sourceItemId']),
      sourceItemName: serializer.fromJson<String>(json['sourceItemName']),
      type: $SourceItemBlobsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      bytes: serializer.fromJson<Uint8List>(json['bytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceItemId': serializer.toJson<String>(sourceItemId),
      'sourceItemName': serializer.toJson<String>(sourceItemName),
      'type': serializer.toJson<String>(
        $SourceItemBlobsTable.$convertertype.toJson(type),
      ),
      'bytes': serializer.toJson<Uint8List>(bytes),
    };
  }

  SourceItemBlob copyWith({
    String? id,
    String? sourceItemId,
    String? sourceItemName,
    SourceFileType? type,
    Uint8List? bytes,
  }) => SourceItemBlob(
    id: id ?? this.id,
    sourceItemId: sourceItemId ?? this.sourceItemId,
    sourceItemName: sourceItemName ?? this.sourceItemName,
    type: type ?? this.type,
    bytes: bytes ?? this.bytes,
  );
  SourceItemBlob copyWithCompanion(SourceItemBlobsCompanion data) {
    return SourceItemBlob(
      id: data.id.present ? data.id.value : this.id,
      sourceItemId: data.sourceItemId.present
          ? data.sourceItemId.value
          : this.sourceItemId,
      sourceItemName: data.sourceItemName.present
          ? data.sourceItemName.value
          : this.sourceItemName,
      type: data.type.present ? data.type.value : this.type,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceItemBlob(')
          ..write('id: $id, ')
          ..write('sourceItemId: $sourceItemId, ')
          ..write('sourceItemName: $sourceItemName, ')
          ..write('type: $type, ')
          ..write('bytes: $bytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceItemId,
    sourceItemName,
    type,
    $driftBlobEquality.hash(bytes),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceItemBlob &&
          other.id == this.id &&
          other.sourceItemId == this.sourceItemId &&
          other.sourceItemName == this.sourceItemName &&
          other.type == this.type &&
          $driftBlobEquality.equals(other.bytes, this.bytes));
}

class SourceItemBlobsCompanion extends UpdateCompanion<SourceItemBlob> {
  final Value<String> id;
  final Value<String> sourceItemId;
  final Value<String> sourceItemName;
  final Value<SourceFileType> type;
  final Value<Uint8List> bytes;
  final Value<int> rowid;
  const SourceItemBlobsCompanion({
    this.id = const Value.absent(),
    this.sourceItemId = const Value.absent(),
    this.sourceItemName = const Value.absent(),
    this.type = const Value.absent(),
    this.bytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceItemBlobsCompanion.insert({
    required String id,
    required String sourceItemId,
    required String sourceItemName,
    required SourceFileType type,
    required Uint8List bytes,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceItemId = Value(sourceItemId),
       sourceItemName = Value(sourceItemName),
       type = Value(type),
       bytes = Value(bytes);
  static Insertable<SourceItemBlob> custom({
    Expression<String>? id,
    Expression<String>? sourceItemId,
    Expression<String>? sourceItemName,
    Expression<String>? type,
    Expression<Uint8List>? bytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceItemId != null) 'source_item_id': sourceItemId,
      if (sourceItemName != null) 'source_item_name': sourceItemName,
      if (type != null) 'type': type,
      if (bytes != null) 'bytes': bytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceItemBlobsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceItemId,
    Value<String>? sourceItemName,
    Value<SourceFileType>? type,
    Value<Uint8List>? bytes,
    Value<int>? rowid,
  }) {
    return SourceItemBlobsCompanion(
      id: id ?? this.id,
      sourceItemId: sourceItemId ?? this.sourceItemId,
      sourceItemName: sourceItemName ?? this.sourceItemName,
      type: type ?? this.type,
      bytes: bytes ?? this.bytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceItemId.present) {
      map['source_item_id'] = Variable<String>(sourceItemId.value);
    }
    if (sourceItemName.present) {
      map['source_item_name'] = Variable<String>(sourceItemName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $SourceItemBlobsTable.$convertertype.toSql(type.value),
      );
    }
    if (bytes.present) {
      map['bytes'] = Variable<Uint8List>(bytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceItemBlobsCompanion(')
          ..write('id: $id, ')
          ..write('sourceItemId: $sourceItemId, ')
          ..write('sourceItemName: $sourceItemName, ')
          ..write('type: $type, ')
          ..write('bytes: $bytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardCreationDraftItemsTable extends CardCreationDraftItems
    with TableInfo<$CardCreationDraftItemsTable, CardCreationDraftItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardCreationDraftItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedSourceIdMeta =
      const VerificationMeta('lastOpenedSourceId');
  @override
  late final GeneratedColumn<String> lastOpenedSourceId =
      GeneratedColumn<String>(
        'last_opened_source_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastOpenedPageMeta = const VerificationMeta(
    'lastOpenedPage',
  );
  @override
  late final GeneratedColumn<String> lastOpenedPage = GeneratedColumn<String>(
    'last_opened_page',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    deckId,
    createdAt,
    updatedAt,
    lastOpenedSourceId,
    lastOpenedPage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_creation_draft_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardCreationDraftItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_opened_source_id')) {
      context.handle(
        _lastOpenedSourceIdMeta,
        lastOpenedSourceId.isAcceptableOrUnknown(
          data['last_opened_source_id']!,
          _lastOpenedSourceIdMeta,
        ),
      );
    }
    if (data.containsKey('last_opened_page')) {
      context.handle(
        _lastOpenedPageMeta,
        lastOpenedPage.isAcceptableOrUnknown(
          data['last_opened_page']!,
          _lastOpenedPageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardCreationDraftItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardCreationDraftItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      lastOpenedSourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_opened_source_id'],
      ),
      lastOpenedPage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_opened_page'],
      ),
    );
  }

  @override
  $CardCreationDraftItemsTable createAlias(String alias) {
    return $CardCreationDraftItemsTable(attachedDatabase, alias);
  }
}

class CardCreationDraftItem extends DataClass
    implements Insertable<CardCreationDraftItem> {
  final String id;
  final String folderId;
  final String deckId;
  final String createdAt;
  final String updatedAt;
  final String? lastOpenedSourceId;
  final String? lastOpenedPage;
  const CardCreationDraftItem({
    required this.id,
    required this.folderId,
    required this.deckId,
    required this.createdAt,
    required this.updatedAt,
    this.lastOpenedSourceId,
    this.lastOpenedPage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder_id'] = Variable<String>(folderId);
    map['deck_id'] = Variable<String>(deckId);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || lastOpenedSourceId != null) {
      map['last_opened_source_id'] = Variable<String>(lastOpenedSourceId);
    }
    if (!nullToAbsent || lastOpenedPage != null) {
      map['last_opened_page'] = Variable<String>(lastOpenedPage);
    }
    return map;
  }

  CardCreationDraftItemsCompanion toCompanion(bool nullToAbsent) {
    return CardCreationDraftItemsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      deckId: Value(deckId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastOpenedSourceId: lastOpenedSourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedSourceId),
      lastOpenedPage: lastOpenedPage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedPage),
    );
  }

  factory CardCreationDraftItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardCreationDraftItem(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String>(json['folderId']),
      deckId: serializer.fromJson<String>(json['deckId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      lastOpenedSourceId: serializer.fromJson<String?>(
        json['lastOpenedSourceId'],
      ),
      lastOpenedPage: serializer.fromJson<String?>(json['lastOpenedPage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String>(folderId),
      'deckId': serializer.toJson<String>(deckId),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'lastOpenedSourceId': serializer.toJson<String?>(lastOpenedSourceId),
      'lastOpenedPage': serializer.toJson<String?>(lastOpenedPage),
    };
  }

  CardCreationDraftItem copyWith({
    String? id,
    String? folderId,
    String? deckId,
    String? createdAt,
    String? updatedAt,
    Value<String?> lastOpenedSourceId = const Value.absent(),
    Value<String?> lastOpenedPage = const Value.absent(),
  }) => CardCreationDraftItem(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    deckId: deckId ?? this.deckId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastOpenedSourceId: lastOpenedSourceId.present
        ? lastOpenedSourceId.value
        : this.lastOpenedSourceId,
    lastOpenedPage: lastOpenedPage.present
        ? lastOpenedPage.value
        : this.lastOpenedPage,
  );
  CardCreationDraftItem copyWithCompanion(
    CardCreationDraftItemsCompanion data,
  ) {
    return CardCreationDraftItem(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastOpenedSourceId: data.lastOpenedSourceId.present
          ? data.lastOpenedSourceId.value
          : this.lastOpenedSourceId,
      lastOpenedPage: data.lastOpenedPage.present
          ? data.lastOpenedPage.value
          : this.lastOpenedPage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardCreationDraftItem(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('deckId: $deckId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedSourceId: $lastOpenedSourceId, ')
          ..write('lastOpenedPage: $lastOpenedPage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    folderId,
    deckId,
    createdAt,
    updatedAt,
    lastOpenedSourceId,
    lastOpenedPage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardCreationDraftItem &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.deckId == this.deckId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastOpenedSourceId == this.lastOpenedSourceId &&
          other.lastOpenedPage == this.lastOpenedPage);
}

class CardCreationDraftItemsCompanion
    extends UpdateCompanion<CardCreationDraftItem> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String> deckId;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> lastOpenedSourceId;
  final Value<String?> lastOpenedPage;
  final Value<int> rowid;
  const CardCreationDraftItemsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.deckId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedSourceId = const Value.absent(),
    this.lastOpenedPage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardCreationDraftItemsCompanion.insert({
    required String id,
    required String folderId,
    required String deckId,
    required String createdAt,
    required String updatedAt,
    this.lastOpenedSourceId = const Value.absent(),
    this.lastOpenedPage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       deckId = Value(deckId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CardCreationDraftItem> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? deckId,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? lastOpenedSourceId,
    Expression<String>? lastOpenedPage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (deckId != null) 'deck_id': deckId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastOpenedSourceId != null)
        'last_opened_source_id': lastOpenedSourceId,
      if (lastOpenedPage != null) 'last_opened_page': lastOpenedPage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardCreationDraftItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String>? deckId,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? lastOpenedSourceId,
    Value<String?>? lastOpenedPage,
    Value<int>? rowid,
  }) {
    return CardCreationDraftItemsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      deckId: deckId ?? this.deckId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastOpenedSourceId: lastOpenedSourceId ?? this.lastOpenedSourceId,
      lastOpenedPage: lastOpenedPage ?? this.lastOpenedPage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (lastOpenedSourceId.present) {
      map['last_opened_source_id'] = Variable<String>(lastOpenedSourceId.value);
    }
    if (lastOpenedPage.present) {
      map['last_opened_page'] = Variable<String>(lastOpenedPage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardCreationDraftItemsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('deckId: $deckId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedSourceId: $lastOpenedSourceId, ')
          ..write('lastOpenedPage: $lastOpenedPage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardItemsTable extends CardItems
    with TableInfo<$CardItemsTable, CardItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frontTextMeta = const VerificationMeta(
    'frontText',
  );
  @override
  late final GeneratedColumn<String> frontText = GeneratedColumn<String>(
    'front_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backTextMeta = const VerificationMeta(
    'backText',
  );
  @override
  late final GeneratedColumn<String> backText = GeneratedColumn<String>(
    'back_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frontImageIdMeta = const VerificationMeta(
    'frontImageId',
  );
  @override
  late final GeneratedColumn<String> frontImageId = GeneratedColumn<String>(
    'front_image_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backImageIdMeta = const VerificationMeta(
    'backImageId',
  );
  @override
  late final GeneratedColumn<String> backImageId = GeneratedColumn<String>(
    'back_image_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CardOcclusion?, String>
  occlusionData = GeneratedColumn<String>(
    'occlusion_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<CardOcclusion?>($CardItemsTable.$converterocclusionDatan);
  static const VerificationMeta _spacedDueMeta = const VerificationMeta(
    'spacedDue',
  );
  @override
  late final GeneratedColumn<DateTime> spacedDue = GeneratedColumn<DateTime>(
    'spaced_due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _spacedStabilityMeta = const VerificationMeta(
    'spacedStability',
  );
  @override
  late final GeneratedColumn<double> spacedStability = GeneratedColumn<double>(
    'spaced_stability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _spacedDifficultyMeta = const VerificationMeta(
    'spacedDifficulty',
  );
  @override
  late final GeneratedColumn<double> spacedDifficulty = GeneratedColumn<double>(
    'spaced_difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _spacedStateMeta = const VerificationMeta(
    'spacedState',
  );
  @override
  late final GeneratedColumn<int> spacedState = GeneratedColumn<int>(
    'spaced_state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spacedStepMeta = const VerificationMeta(
    'spacedStep',
  );
  @override
  late final GeneratedColumn<int> spacedStep = GeneratedColumn<int>(
    'spaced_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spacedLastReviewMeta = const VerificationMeta(
    'spacedLastReview',
  );
  @override
  late final GeneratedColumn<DateTime> spacedLastReview =
      GeneratedColumn<DateTime>(
        'spaced_last_review',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _drillDueMeta = const VerificationMeta(
    'drillDue',
  );
  @override
  late final GeneratedColumn<DateTime> drillDue = GeneratedColumn<DateTime>(
    'drill_due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _drillStabilityMeta = const VerificationMeta(
    'drillStability',
  );
  @override
  late final GeneratedColumn<double> drillStability = GeneratedColumn<double>(
    'drill_stability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _drillDifficultyMeta = const VerificationMeta(
    'drillDifficulty',
  );
  @override
  late final GeneratedColumn<double> drillDifficulty = GeneratedColumn<double>(
    'drill_difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _drillStateMeta = const VerificationMeta(
    'drillState',
  );
  @override
  late final GeneratedColumn<int> drillState = GeneratedColumn<int>(
    'drill_state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _drillStepMeta = const VerificationMeta(
    'drillStep',
  );
  @override
  late final GeneratedColumn<int> drillStep = GeneratedColumn<int>(
    'drill_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _drillLastReviewMeta = const VerificationMeta(
    'drillLastReview',
  );
  @override
  late final GeneratedColumn<DateTime> drillLastReview =
      GeneratedColumn<DateTime>(
        'drill_last_review',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES deck_items (id)',
    ),
  );
  static const VerificationMeta _draftIdMeta = const VerificationMeta(
    'draftId',
  );
  @override
  late final GeneratedColumn<String> draftId = GeneratedColumn<String>(
    'draft_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES card_creation_draft_items (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    frontText,
    backText,
    frontImageId,
    backImageId,
    occlusionData,
    spacedDue,
    spacedStability,
    spacedDifficulty,
    spacedState,
    spacedStep,
    spacedLastReview,
    drillDue,
    drillStability,
    drillDifficulty,
    drillState,
    drillStep,
    drillLastReview,
    deckId,
    draftId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('front_text')) {
      context.handle(
        _frontTextMeta,
        frontText.isAcceptableOrUnknown(data['front_text']!, _frontTextMeta),
      );
    }
    if (data.containsKey('back_text')) {
      context.handle(
        _backTextMeta,
        backText.isAcceptableOrUnknown(data['back_text']!, _backTextMeta),
      );
    }
    if (data.containsKey('front_image_id')) {
      context.handle(
        _frontImageIdMeta,
        frontImageId.isAcceptableOrUnknown(
          data['front_image_id']!,
          _frontImageIdMeta,
        ),
      );
    }
    if (data.containsKey('back_image_id')) {
      context.handle(
        _backImageIdMeta,
        backImageId.isAcceptableOrUnknown(
          data['back_image_id']!,
          _backImageIdMeta,
        ),
      );
    }
    if (data.containsKey('spaced_due')) {
      context.handle(
        _spacedDueMeta,
        spacedDue.isAcceptableOrUnknown(data['spaced_due']!, _spacedDueMeta),
      );
    }
    if (data.containsKey('spaced_stability')) {
      context.handle(
        _spacedStabilityMeta,
        spacedStability.isAcceptableOrUnknown(
          data['spaced_stability']!,
          _spacedStabilityMeta,
        ),
      );
    }
    if (data.containsKey('spaced_difficulty')) {
      context.handle(
        _spacedDifficultyMeta,
        spacedDifficulty.isAcceptableOrUnknown(
          data['spaced_difficulty']!,
          _spacedDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('spaced_state')) {
      context.handle(
        _spacedStateMeta,
        spacedState.isAcceptableOrUnknown(
          data['spaced_state']!,
          _spacedStateMeta,
        ),
      );
    }
    if (data.containsKey('spaced_step')) {
      context.handle(
        _spacedStepMeta,
        spacedStep.isAcceptableOrUnknown(data['spaced_step']!, _spacedStepMeta),
      );
    }
    if (data.containsKey('spaced_last_review')) {
      context.handle(
        _spacedLastReviewMeta,
        spacedLastReview.isAcceptableOrUnknown(
          data['spaced_last_review']!,
          _spacedLastReviewMeta,
        ),
      );
    }
    if (data.containsKey('drill_due')) {
      context.handle(
        _drillDueMeta,
        drillDue.isAcceptableOrUnknown(data['drill_due']!, _drillDueMeta),
      );
    }
    if (data.containsKey('drill_stability')) {
      context.handle(
        _drillStabilityMeta,
        drillStability.isAcceptableOrUnknown(
          data['drill_stability']!,
          _drillStabilityMeta,
        ),
      );
    }
    if (data.containsKey('drill_difficulty')) {
      context.handle(
        _drillDifficultyMeta,
        drillDifficulty.isAcceptableOrUnknown(
          data['drill_difficulty']!,
          _drillDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('drill_state')) {
      context.handle(
        _drillStateMeta,
        drillState.isAcceptableOrUnknown(data['drill_state']!, _drillStateMeta),
      );
    }
    if (data.containsKey('drill_step')) {
      context.handle(
        _drillStepMeta,
        drillStep.isAcceptableOrUnknown(data['drill_step']!, _drillStepMeta),
      );
    }
    if (data.containsKey('drill_last_review')) {
      context.handle(
        _drillLastReviewMeta,
        drillLastReview.isAcceptableOrUnknown(
          data['drill_last_review']!,
          _drillLastReviewMeta,
        ),
      );
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    }
    if (data.containsKey('draft_id')) {
      context.handle(
        _draftIdMeta,
        draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      frontText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front_text'],
      ),
      backText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back_text'],
      ),
      frontImageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front_image_id'],
      ),
      backImageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back_image_id'],
      ),
      occlusionData: $CardItemsTable.$converterocclusionDatan.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}occlusion_data'],
        ),
      ),
      spacedDue: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spaced_due'],
      )!,
      spacedStability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spaced_stability'],
      )!,
      spacedDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spaced_difficulty'],
      )!,
      spacedState: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spaced_state'],
      )!,
      spacedStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spaced_step'],
      )!,
      spacedLastReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spaced_last_review'],
      ),
      drillDue: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}drill_due'],
      )!,
      drillStability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}drill_stability'],
      )!,
      drillDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}drill_difficulty'],
      )!,
      drillState: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drill_state'],
      )!,
      drillStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drill_step'],
      )!,
      drillLastReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}drill_last_review'],
      ),
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      ),
      draftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CardItemsTable createAlias(String alias) {
    return $CardItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<CardOcclusion, String> $converterocclusionData =
      const CardOcclusionConverter();
  static TypeConverter<CardOcclusion?, String?> $converterocclusionDatan =
      NullAwareTypeConverter.wrap($converterocclusionData);
}

class CardItem extends DataClass implements Insertable<CardItem> {
  final String id;
  final String? frontText;
  final String? backText;
  final String? frontImageId;
  final String? backImageId;
  final CardOcclusion? occlusionData;
  final DateTime spacedDue;
  final double spacedStability;
  final double spacedDifficulty;
  final int spacedState;
  final int spacedStep;
  final DateTime? spacedLastReview;
  final DateTime drillDue;
  final double drillStability;
  final double drillDifficulty;
  final int drillState;
  final int drillStep;
  final DateTime? drillLastReview;
  final String? deckId;
  final String? draftId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CardItem({
    required this.id,
    this.frontText,
    this.backText,
    this.frontImageId,
    this.backImageId,
    this.occlusionData,
    required this.spacedDue,
    required this.spacedStability,
    required this.spacedDifficulty,
    required this.spacedState,
    required this.spacedStep,
    this.spacedLastReview,
    required this.drillDue,
    required this.drillStability,
    required this.drillDifficulty,
    required this.drillState,
    required this.drillStep,
    this.drillLastReview,
    this.deckId,
    this.draftId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || frontText != null) {
      map['front_text'] = Variable<String>(frontText);
    }
    if (!nullToAbsent || backText != null) {
      map['back_text'] = Variable<String>(backText);
    }
    if (!nullToAbsent || frontImageId != null) {
      map['front_image_id'] = Variable<String>(frontImageId);
    }
    if (!nullToAbsent || backImageId != null) {
      map['back_image_id'] = Variable<String>(backImageId);
    }
    if (!nullToAbsent || occlusionData != null) {
      map['occlusion_data'] = Variable<String>(
        $CardItemsTable.$converterocclusionDatan.toSql(occlusionData),
      );
    }
    map['spaced_due'] = Variable<DateTime>(spacedDue);
    map['spaced_stability'] = Variable<double>(spacedStability);
    map['spaced_difficulty'] = Variable<double>(spacedDifficulty);
    map['spaced_state'] = Variable<int>(spacedState);
    map['spaced_step'] = Variable<int>(spacedStep);
    if (!nullToAbsent || spacedLastReview != null) {
      map['spaced_last_review'] = Variable<DateTime>(spacedLastReview);
    }
    map['drill_due'] = Variable<DateTime>(drillDue);
    map['drill_stability'] = Variable<double>(drillStability);
    map['drill_difficulty'] = Variable<double>(drillDifficulty);
    map['drill_state'] = Variable<int>(drillState);
    map['drill_step'] = Variable<int>(drillStep);
    if (!nullToAbsent || drillLastReview != null) {
      map['drill_last_review'] = Variable<DateTime>(drillLastReview);
    }
    if (!nullToAbsent || deckId != null) {
      map['deck_id'] = Variable<String>(deckId);
    }
    if (!nullToAbsent || draftId != null) {
      map['draft_id'] = Variable<String>(draftId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CardItemsCompanion toCompanion(bool nullToAbsent) {
    return CardItemsCompanion(
      id: Value(id),
      frontText: frontText == null && nullToAbsent
          ? const Value.absent()
          : Value(frontText),
      backText: backText == null && nullToAbsent
          ? const Value.absent()
          : Value(backText),
      frontImageId: frontImageId == null && nullToAbsent
          ? const Value.absent()
          : Value(frontImageId),
      backImageId: backImageId == null && nullToAbsent
          ? const Value.absent()
          : Value(backImageId),
      occlusionData: occlusionData == null && nullToAbsent
          ? const Value.absent()
          : Value(occlusionData),
      spacedDue: Value(spacedDue),
      spacedStability: Value(spacedStability),
      spacedDifficulty: Value(spacedDifficulty),
      spacedState: Value(spacedState),
      spacedStep: Value(spacedStep),
      spacedLastReview: spacedLastReview == null && nullToAbsent
          ? const Value.absent()
          : Value(spacedLastReview),
      drillDue: Value(drillDue),
      drillStability: Value(drillStability),
      drillDifficulty: Value(drillDifficulty),
      drillState: Value(drillState),
      drillStep: Value(drillStep),
      drillLastReview: drillLastReview == null && nullToAbsent
          ? const Value.absent()
          : Value(drillLastReview),
      deckId: deckId == null && nullToAbsent
          ? const Value.absent()
          : Value(deckId),
      draftId: draftId == null && nullToAbsent
          ? const Value.absent()
          : Value(draftId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CardItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardItem(
      id: serializer.fromJson<String>(json['id']),
      frontText: serializer.fromJson<String?>(json['frontText']),
      backText: serializer.fromJson<String?>(json['backText']),
      frontImageId: serializer.fromJson<String?>(json['frontImageId']),
      backImageId: serializer.fromJson<String?>(json['backImageId']),
      occlusionData: serializer.fromJson<CardOcclusion?>(json['occlusionData']),
      spacedDue: serializer.fromJson<DateTime>(json['spacedDue']),
      spacedStability: serializer.fromJson<double>(json['spacedStability']),
      spacedDifficulty: serializer.fromJson<double>(json['spacedDifficulty']),
      spacedState: serializer.fromJson<int>(json['spacedState']),
      spacedStep: serializer.fromJson<int>(json['spacedStep']),
      spacedLastReview: serializer.fromJson<DateTime?>(
        json['spacedLastReview'],
      ),
      drillDue: serializer.fromJson<DateTime>(json['drillDue']),
      drillStability: serializer.fromJson<double>(json['drillStability']),
      drillDifficulty: serializer.fromJson<double>(json['drillDifficulty']),
      drillState: serializer.fromJson<int>(json['drillState']),
      drillStep: serializer.fromJson<int>(json['drillStep']),
      drillLastReview: serializer.fromJson<DateTime?>(json['drillLastReview']),
      deckId: serializer.fromJson<String?>(json['deckId']),
      draftId: serializer.fromJson<String?>(json['draftId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'frontText': serializer.toJson<String?>(frontText),
      'backText': serializer.toJson<String?>(backText),
      'frontImageId': serializer.toJson<String?>(frontImageId),
      'backImageId': serializer.toJson<String?>(backImageId),
      'occlusionData': serializer.toJson<CardOcclusion?>(occlusionData),
      'spacedDue': serializer.toJson<DateTime>(spacedDue),
      'spacedStability': serializer.toJson<double>(spacedStability),
      'spacedDifficulty': serializer.toJson<double>(spacedDifficulty),
      'spacedState': serializer.toJson<int>(spacedState),
      'spacedStep': serializer.toJson<int>(spacedStep),
      'spacedLastReview': serializer.toJson<DateTime?>(spacedLastReview),
      'drillDue': serializer.toJson<DateTime>(drillDue),
      'drillStability': serializer.toJson<double>(drillStability),
      'drillDifficulty': serializer.toJson<double>(drillDifficulty),
      'drillState': serializer.toJson<int>(drillState),
      'drillStep': serializer.toJson<int>(drillStep),
      'drillLastReview': serializer.toJson<DateTime?>(drillLastReview),
      'deckId': serializer.toJson<String?>(deckId),
      'draftId': serializer.toJson<String?>(draftId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CardItem copyWith({
    String? id,
    Value<String?> frontText = const Value.absent(),
    Value<String?> backText = const Value.absent(),
    Value<String?> frontImageId = const Value.absent(),
    Value<String?> backImageId = const Value.absent(),
    Value<CardOcclusion?> occlusionData = const Value.absent(),
    DateTime? spacedDue,
    double? spacedStability,
    double? spacedDifficulty,
    int? spacedState,
    int? spacedStep,
    Value<DateTime?> spacedLastReview = const Value.absent(),
    DateTime? drillDue,
    double? drillStability,
    double? drillDifficulty,
    int? drillState,
    int? drillStep,
    Value<DateTime?> drillLastReview = const Value.absent(),
    Value<String?> deckId = const Value.absent(),
    Value<String?> draftId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CardItem(
    id: id ?? this.id,
    frontText: frontText.present ? frontText.value : this.frontText,
    backText: backText.present ? backText.value : this.backText,
    frontImageId: frontImageId.present ? frontImageId.value : this.frontImageId,
    backImageId: backImageId.present ? backImageId.value : this.backImageId,
    occlusionData: occlusionData.present
        ? occlusionData.value
        : this.occlusionData,
    spacedDue: spacedDue ?? this.spacedDue,
    spacedStability: spacedStability ?? this.spacedStability,
    spacedDifficulty: spacedDifficulty ?? this.spacedDifficulty,
    spacedState: spacedState ?? this.spacedState,
    spacedStep: spacedStep ?? this.spacedStep,
    spacedLastReview: spacedLastReview.present
        ? spacedLastReview.value
        : this.spacedLastReview,
    drillDue: drillDue ?? this.drillDue,
    drillStability: drillStability ?? this.drillStability,
    drillDifficulty: drillDifficulty ?? this.drillDifficulty,
    drillState: drillState ?? this.drillState,
    drillStep: drillStep ?? this.drillStep,
    drillLastReview: drillLastReview.present
        ? drillLastReview.value
        : this.drillLastReview,
    deckId: deckId.present ? deckId.value : this.deckId,
    draftId: draftId.present ? draftId.value : this.draftId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CardItem copyWithCompanion(CardItemsCompanion data) {
    return CardItem(
      id: data.id.present ? data.id.value : this.id,
      frontText: data.frontText.present ? data.frontText.value : this.frontText,
      backText: data.backText.present ? data.backText.value : this.backText,
      frontImageId: data.frontImageId.present
          ? data.frontImageId.value
          : this.frontImageId,
      backImageId: data.backImageId.present
          ? data.backImageId.value
          : this.backImageId,
      occlusionData: data.occlusionData.present
          ? data.occlusionData.value
          : this.occlusionData,
      spacedDue: data.spacedDue.present ? data.spacedDue.value : this.spacedDue,
      spacedStability: data.spacedStability.present
          ? data.spacedStability.value
          : this.spacedStability,
      spacedDifficulty: data.spacedDifficulty.present
          ? data.spacedDifficulty.value
          : this.spacedDifficulty,
      spacedState: data.spacedState.present
          ? data.spacedState.value
          : this.spacedState,
      spacedStep: data.spacedStep.present
          ? data.spacedStep.value
          : this.spacedStep,
      spacedLastReview: data.spacedLastReview.present
          ? data.spacedLastReview.value
          : this.spacedLastReview,
      drillDue: data.drillDue.present ? data.drillDue.value : this.drillDue,
      drillStability: data.drillStability.present
          ? data.drillStability.value
          : this.drillStability,
      drillDifficulty: data.drillDifficulty.present
          ? data.drillDifficulty.value
          : this.drillDifficulty,
      drillState: data.drillState.present
          ? data.drillState.value
          : this.drillState,
      drillStep: data.drillStep.present ? data.drillStep.value : this.drillStep,
      drillLastReview: data.drillLastReview.present
          ? data.drillLastReview.value
          : this.drillLastReview,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardItem(')
          ..write('id: $id, ')
          ..write('frontText: $frontText, ')
          ..write('backText: $backText, ')
          ..write('frontImageId: $frontImageId, ')
          ..write('backImageId: $backImageId, ')
          ..write('occlusionData: $occlusionData, ')
          ..write('spacedDue: $spacedDue, ')
          ..write('spacedStability: $spacedStability, ')
          ..write('spacedDifficulty: $spacedDifficulty, ')
          ..write('spacedState: $spacedState, ')
          ..write('spacedStep: $spacedStep, ')
          ..write('spacedLastReview: $spacedLastReview, ')
          ..write('drillDue: $drillDue, ')
          ..write('drillStability: $drillStability, ')
          ..write('drillDifficulty: $drillDifficulty, ')
          ..write('drillState: $drillState, ')
          ..write('drillStep: $drillStep, ')
          ..write('drillLastReview: $drillLastReview, ')
          ..write('deckId: $deckId, ')
          ..write('draftId: $draftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    frontText,
    backText,
    frontImageId,
    backImageId,
    occlusionData,
    spacedDue,
    spacedStability,
    spacedDifficulty,
    spacedState,
    spacedStep,
    spacedLastReview,
    drillDue,
    drillStability,
    drillDifficulty,
    drillState,
    drillStep,
    drillLastReview,
    deckId,
    draftId,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardItem &&
          other.id == this.id &&
          other.frontText == this.frontText &&
          other.backText == this.backText &&
          other.frontImageId == this.frontImageId &&
          other.backImageId == this.backImageId &&
          other.occlusionData == this.occlusionData &&
          other.spacedDue == this.spacedDue &&
          other.spacedStability == this.spacedStability &&
          other.spacedDifficulty == this.spacedDifficulty &&
          other.spacedState == this.spacedState &&
          other.spacedStep == this.spacedStep &&
          other.spacedLastReview == this.spacedLastReview &&
          other.drillDue == this.drillDue &&
          other.drillStability == this.drillStability &&
          other.drillDifficulty == this.drillDifficulty &&
          other.drillState == this.drillState &&
          other.drillStep == this.drillStep &&
          other.drillLastReview == this.drillLastReview &&
          other.deckId == this.deckId &&
          other.draftId == this.draftId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CardItemsCompanion extends UpdateCompanion<CardItem> {
  final Value<String> id;
  final Value<String?> frontText;
  final Value<String?> backText;
  final Value<String?> frontImageId;
  final Value<String?> backImageId;
  final Value<CardOcclusion?> occlusionData;
  final Value<DateTime> spacedDue;
  final Value<double> spacedStability;
  final Value<double> spacedDifficulty;
  final Value<int> spacedState;
  final Value<int> spacedStep;
  final Value<DateTime?> spacedLastReview;
  final Value<DateTime> drillDue;
  final Value<double> drillStability;
  final Value<double> drillDifficulty;
  final Value<int> drillState;
  final Value<int> drillStep;
  final Value<DateTime?> drillLastReview;
  final Value<String?> deckId;
  final Value<String?> draftId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CardItemsCompanion({
    this.id = const Value.absent(),
    this.frontText = const Value.absent(),
    this.backText = const Value.absent(),
    this.frontImageId = const Value.absent(),
    this.backImageId = const Value.absent(),
    this.occlusionData = const Value.absent(),
    this.spacedDue = const Value.absent(),
    this.spacedStability = const Value.absent(),
    this.spacedDifficulty = const Value.absent(),
    this.spacedState = const Value.absent(),
    this.spacedStep = const Value.absent(),
    this.spacedLastReview = const Value.absent(),
    this.drillDue = const Value.absent(),
    this.drillStability = const Value.absent(),
    this.drillDifficulty = const Value.absent(),
    this.drillState = const Value.absent(),
    this.drillStep = const Value.absent(),
    this.drillLastReview = const Value.absent(),
    this.deckId = const Value.absent(),
    this.draftId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardItemsCompanion.insert({
    required String id,
    this.frontText = const Value.absent(),
    this.backText = const Value.absent(),
    this.frontImageId = const Value.absent(),
    this.backImageId = const Value.absent(),
    this.occlusionData = const Value.absent(),
    this.spacedDue = const Value.absent(),
    this.spacedStability = const Value.absent(),
    this.spacedDifficulty = const Value.absent(),
    this.spacedState = const Value.absent(),
    this.spacedStep = const Value.absent(),
    this.spacedLastReview = const Value.absent(),
    this.drillDue = const Value.absent(),
    this.drillStability = const Value.absent(),
    this.drillDifficulty = const Value.absent(),
    this.drillState = const Value.absent(),
    this.drillStep = const Value.absent(),
    this.drillLastReview = const Value.absent(),
    this.deckId = const Value.absent(),
    this.draftId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<CardItem> custom({
    Expression<String>? id,
    Expression<String>? frontText,
    Expression<String>? backText,
    Expression<String>? frontImageId,
    Expression<String>? backImageId,
    Expression<String>? occlusionData,
    Expression<DateTime>? spacedDue,
    Expression<double>? spacedStability,
    Expression<double>? spacedDifficulty,
    Expression<int>? spacedState,
    Expression<int>? spacedStep,
    Expression<DateTime>? spacedLastReview,
    Expression<DateTime>? drillDue,
    Expression<double>? drillStability,
    Expression<double>? drillDifficulty,
    Expression<int>? drillState,
    Expression<int>? drillStep,
    Expression<DateTime>? drillLastReview,
    Expression<String>? deckId,
    Expression<String>? draftId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frontText != null) 'front_text': frontText,
      if (backText != null) 'back_text': backText,
      if (frontImageId != null) 'front_image_id': frontImageId,
      if (backImageId != null) 'back_image_id': backImageId,
      if (occlusionData != null) 'occlusion_data': occlusionData,
      if (spacedDue != null) 'spaced_due': spacedDue,
      if (spacedStability != null) 'spaced_stability': spacedStability,
      if (spacedDifficulty != null) 'spaced_difficulty': spacedDifficulty,
      if (spacedState != null) 'spaced_state': spacedState,
      if (spacedStep != null) 'spaced_step': spacedStep,
      if (spacedLastReview != null) 'spaced_last_review': spacedLastReview,
      if (drillDue != null) 'drill_due': drillDue,
      if (drillStability != null) 'drill_stability': drillStability,
      if (drillDifficulty != null) 'drill_difficulty': drillDifficulty,
      if (drillState != null) 'drill_state': drillState,
      if (drillStep != null) 'drill_step': drillStep,
      if (drillLastReview != null) 'drill_last_review': drillLastReview,
      if (deckId != null) 'deck_id': deckId,
      if (draftId != null) 'draft_id': draftId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? frontText,
    Value<String?>? backText,
    Value<String?>? frontImageId,
    Value<String?>? backImageId,
    Value<CardOcclusion?>? occlusionData,
    Value<DateTime>? spacedDue,
    Value<double>? spacedStability,
    Value<double>? spacedDifficulty,
    Value<int>? spacedState,
    Value<int>? spacedStep,
    Value<DateTime?>? spacedLastReview,
    Value<DateTime>? drillDue,
    Value<double>? drillStability,
    Value<double>? drillDifficulty,
    Value<int>? drillState,
    Value<int>? drillStep,
    Value<DateTime?>? drillLastReview,
    Value<String?>? deckId,
    Value<String?>? draftId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CardItemsCompanion(
      id: id ?? this.id,
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      frontImageId: frontImageId ?? this.frontImageId,
      backImageId: backImageId ?? this.backImageId,
      occlusionData: occlusionData ?? this.occlusionData,
      spacedDue: spacedDue ?? this.spacedDue,
      spacedStability: spacedStability ?? this.spacedStability,
      spacedDifficulty: spacedDifficulty ?? this.spacedDifficulty,
      spacedState: spacedState ?? this.spacedState,
      spacedStep: spacedStep ?? this.spacedStep,
      spacedLastReview: spacedLastReview ?? this.spacedLastReview,
      drillDue: drillDue ?? this.drillDue,
      drillStability: drillStability ?? this.drillStability,
      drillDifficulty: drillDifficulty ?? this.drillDifficulty,
      drillState: drillState ?? this.drillState,
      drillStep: drillStep ?? this.drillStep,
      drillLastReview: drillLastReview ?? this.drillLastReview,
      deckId: deckId ?? this.deckId,
      draftId: draftId ?? this.draftId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (frontText.present) {
      map['front_text'] = Variable<String>(frontText.value);
    }
    if (backText.present) {
      map['back_text'] = Variable<String>(backText.value);
    }
    if (frontImageId.present) {
      map['front_image_id'] = Variable<String>(frontImageId.value);
    }
    if (backImageId.present) {
      map['back_image_id'] = Variable<String>(backImageId.value);
    }
    if (occlusionData.present) {
      map['occlusion_data'] = Variable<String>(
        $CardItemsTable.$converterocclusionDatan.toSql(occlusionData.value),
      );
    }
    if (spacedDue.present) {
      map['spaced_due'] = Variable<DateTime>(spacedDue.value);
    }
    if (spacedStability.present) {
      map['spaced_stability'] = Variable<double>(spacedStability.value);
    }
    if (spacedDifficulty.present) {
      map['spaced_difficulty'] = Variable<double>(spacedDifficulty.value);
    }
    if (spacedState.present) {
      map['spaced_state'] = Variable<int>(spacedState.value);
    }
    if (spacedStep.present) {
      map['spaced_step'] = Variable<int>(spacedStep.value);
    }
    if (spacedLastReview.present) {
      map['spaced_last_review'] = Variable<DateTime>(spacedLastReview.value);
    }
    if (drillDue.present) {
      map['drill_due'] = Variable<DateTime>(drillDue.value);
    }
    if (drillStability.present) {
      map['drill_stability'] = Variable<double>(drillStability.value);
    }
    if (drillDifficulty.present) {
      map['drill_difficulty'] = Variable<double>(drillDifficulty.value);
    }
    if (drillState.present) {
      map['drill_state'] = Variable<int>(drillState.value);
    }
    if (drillStep.present) {
      map['drill_step'] = Variable<int>(drillStep.value);
    }
    if (drillLastReview.present) {
      map['drill_last_review'] = Variable<DateTime>(drillLastReview.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<String>(draftId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardItemsCompanion(')
          ..write('id: $id, ')
          ..write('frontText: $frontText, ')
          ..write('backText: $backText, ')
          ..write('frontImageId: $frontImageId, ')
          ..write('backImageId: $backImageId, ')
          ..write('occlusionData: $occlusionData, ')
          ..write('spacedDue: $spacedDue, ')
          ..write('spacedStability: $spacedStability, ')
          ..write('spacedDifficulty: $spacedDifficulty, ')
          ..write('spacedState: $spacedState, ')
          ..write('spacedStep: $spacedStep, ')
          ..write('spacedLastReview: $spacedLastReview, ')
          ..write('drillDue: $drillDue, ')
          ..write('drillStability: $drillStability, ')
          ..write('drillDifficulty: $drillDifficulty, ')
          ..write('drillState: $drillState, ')
          ..write('drillStep: $drillStep, ')
          ..write('drillLastReview: $drillLastReview, ')
          ..write('deckId: $deckId, ')
          ..write('draftId: $draftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudySessionEventsTable extends StudySessionEvents
    with TableInfo<$StudySessionEventsTable, StudySessionEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<String> reviewedAt = GeneratedColumn<String>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDaysMeta = const VerificationMeta(
    'scheduledDays',
  );
  @override
  late final GeneratedColumn<int> scheduledDays = GeneratedColumn<int>(
    'scheduled_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StudySessionMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StudySessionMode>(
        $StudySessionEventsTable.$convertermode,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    deckId,
    rating,
    reviewedAt,
    scheduledDays,
    mode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_session_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySessionEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
        _scheduledDaysMeta,
        scheduledDays.isAcceptableOrUnknown(
          data['scheduled_days']!,
          _scheduledDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySessionEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySessionEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewed_at'],
      )!,
      scheduledDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_days'],
      )!,
      mode: $StudySessionEventsTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
    );
  }

  @override
  $StudySessionEventsTable createAlias(String alias) {
    return $StudySessionEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StudySessionMode, String, String> $convertermode =
      const EnumNameConverter<StudySessionMode>(StudySessionMode.values);
}

class StudySessionEvent extends DataClass
    implements Insertable<StudySessionEvent> {
  final String id;
  final String cardId;
  final String deckId;
  final int rating;
  final String reviewedAt;
  final int scheduledDays;
  final StudySessionMode mode;
  const StudySessionEvent({
    required this.id,
    required this.cardId,
    required this.deckId,
    required this.rating,
    required this.reviewedAt,
    required this.scheduledDays,
    required this.mode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['deck_id'] = Variable<String>(deckId);
    map['rating'] = Variable<int>(rating);
    map['reviewed_at'] = Variable<String>(reviewedAt);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    {
      map['mode'] = Variable<String>(
        $StudySessionEventsTable.$convertermode.toSql(mode),
      );
    }
    return map;
  }

  StudySessionEventsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionEventsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      deckId: Value(deckId),
      rating: Value(rating),
      reviewedAt: Value(reviewedAt),
      scheduledDays: Value(scheduledDays),
      mode: Value(mode),
    );
  }

  factory StudySessionEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySessionEvent(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      deckId: serializer.fromJson<String>(json['deckId']),
      rating: serializer.fromJson<int>(json['rating']),
      reviewedAt: serializer.fromJson<String>(json['reviewedAt']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      mode: $StudySessionEventsTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'deckId': serializer.toJson<String>(deckId),
      'rating': serializer.toJson<int>(rating),
      'reviewedAt': serializer.toJson<String>(reviewedAt),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'mode': serializer.toJson<String>(
        $StudySessionEventsTable.$convertermode.toJson(mode),
      ),
    };
  }

  StudySessionEvent copyWith({
    String? id,
    String? cardId,
    String? deckId,
    int? rating,
    String? reviewedAt,
    int? scheduledDays,
    StudySessionMode? mode,
  }) => StudySessionEvent(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    deckId: deckId ?? this.deckId,
    rating: rating ?? this.rating,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    scheduledDays: scheduledDays ?? this.scheduledDays,
    mode: mode ?? this.mode,
  );
  StudySessionEvent copyWithCompanion(StudySessionEventsCompanion data) {
    return StudySessionEvent(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      rating: data.rating.present ? data.rating.value : this.rating,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      mode: data.mode.present ? data.mode.value : this.mode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionEvent(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('deckId: $deckId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('mode: $mode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, deckId, rating, reviewedAt, scheduledDays, mode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionEvent &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.deckId == this.deckId &&
          other.rating == this.rating &&
          other.reviewedAt == this.reviewedAt &&
          other.scheduledDays == this.scheduledDays &&
          other.mode == this.mode);
}

class StudySessionEventsCompanion extends UpdateCompanion<StudySessionEvent> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> deckId;
  final Value<int> rating;
  final Value<String> reviewedAt;
  final Value<int> scheduledDays;
  final Value<StudySessionMode> mode;
  final Value<int> rowid;
  const StudySessionEventsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.deckId = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.mode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionEventsCompanion.insert({
    required String id,
    required String cardId,
    required String deckId,
    required int rating,
    required String reviewedAt,
    required int scheduledDays,
    required StudySessionMode mode,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       deckId = Value(deckId),
       rating = Value(rating),
       reviewedAt = Value(reviewedAt),
       scheduledDays = Value(scheduledDays),
       mode = Value(mode);
  static Insertable<StudySessionEvent> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? deckId,
    Expression<int>? rating,
    Expression<String>? reviewedAt,
    Expression<int>? scheduledDays,
    Expression<String>? mode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (deckId != null) 'deck_id': deckId,
      if (rating != null) 'rating': rating,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (mode != null) 'mode': mode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudySessionEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String>? deckId,
    Value<int>? rating,
    Value<String>? reviewedAt,
    Value<int>? scheduledDays,
    Value<StudySessionMode>? mode,
    Value<int>? rowid,
  }) {
    return StudySessionEventsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      deckId: deckId ?? this.deckId,
      rating: rating ?? this.rating,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      mode: mode ?? this.mode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<String>(reviewedAt.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<int>(scheduledDays.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $StudySessionEventsTable.$convertermode.toSql(mode.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionEventsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('deckId: $deckId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('mode: $mode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitationItemsTable extends CitationItems
    with TableInfo<$CitationItemsTable, CitationItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitationItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _citedTextMeta = const VerificationMeta(
    'citedText',
  );
  @override
  late final GeneratedColumn<String> citedText = GeneratedColumn<String>(
    'cited_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String> sourceIds =
      GeneratedColumn<String>(
        'source_ids',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<String>?>($CitationItemsTable.$convertersourceIdsn);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>?, String> pageNumbers =
      GeneratedColumn<String>(
        'page_numbers',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<int>?>($CitationItemsTable.$converterpageNumbersn);
  @override
  late final GeneratedColumnWithTypeConverter<List<ProjectTimeRange>?, String>
  timeRanges =
      GeneratedColumn<String>(
        'time_ranges',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<ProjectTimeRange>?>(
        $CitationItemsTable.$convertertimeRangesn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<ProjectRect>?, String>
  rects = GeneratedColumn<String>(
    'rects',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<ProjectRect>?>($CitationItemsTable.$converterrectsn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    citedText,
    sourceIds,
    pageNumbers,
    timeRanges,
    rects,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citation_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitationItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cited_text')) {
      context.handle(
        _citedTextMeta,
        citedText.isAcceptableOrUnknown(data['cited_text']!, _citedTextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CitationItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitationItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      citedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cited_text'],
      ),
      sourceIds: $CitationItemsTable.$convertersourceIdsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_ids'],
        ),
      ),
      pageNumbers: $CitationItemsTable.$converterpageNumbersn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}page_numbers'],
        ),
      ),
      timeRanges: $CitationItemsTable.$convertertimeRangesn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}time_ranges'],
        ),
      ),
      rects: $CitationItemsTable.$converterrectsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rects'],
        ),
      ),
    );
  }

  @override
  $CitationItemsTable createAlias(String alias) {
    return $CitationItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertersourceIds =
      const JsonListConverter<String>();
  static TypeConverter<List<String>?, String?> $convertersourceIdsn =
      NullAwareTypeConverter.wrap($convertersourceIds);
  static TypeConverter<List<int>, String> $converterpageNumbers =
      const JsonListConverter<int>();
  static TypeConverter<List<int>?, String?> $converterpageNumbersn =
      NullAwareTypeConverter.wrap($converterpageNumbers);
  static TypeConverter<List<ProjectTimeRange>, String> $convertertimeRanges =
      const ProjectTimeRangeListConverter();
  static TypeConverter<List<ProjectTimeRange>?, String?> $convertertimeRangesn =
      NullAwareTypeConverter.wrap($convertertimeRanges);
  static TypeConverter<List<ProjectRect>, String> $converterrects =
      const ProjectRectListConverter();
  static TypeConverter<List<ProjectRect>?, String?> $converterrectsn =
      NullAwareTypeConverter.wrap($converterrects);
}

class CitationItem extends DataClass implements Insertable<CitationItem> {
  final String id;

  /// The actual cited text or content summary.
  final String? citedText;

  /// References one or more sources (e.g. multiple PDF files).
  final List<String>? sourceIds;

  /// One or more page numbers (e.g. non-contiguous pages like "4, 7, 12").
  final List<int>? pageNumbers;

  /// One or more time segments (e.g. for video timestamps).
  final List<ProjectTimeRange>? timeRanges;

  /// One or more bounding boxes (e.g. for multi-line text selections in a PDF).
  final List<ProjectRect>? rects;
  const CitationItem({
    required this.id,
    this.citedText,
    this.sourceIds,
    this.pageNumbers,
    this.timeRanges,
    this.rects,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || citedText != null) {
      map['cited_text'] = Variable<String>(citedText);
    }
    if (!nullToAbsent || sourceIds != null) {
      map['source_ids'] = Variable<String>(
        $CitationItemsTable.$convertersourceIdsn.toSql(sourceIds),
      );
    }
    if (!nullToAbsent || pageNumbers != null) {
      map['page_numbers'] = Variable<String>(
        $CitationItemsTable.$converterpageNumbersn.toSql(pageNumbers),
      );
    }
    if (!nullToAbsent || timeRanges != null) {
      map['time_ranges'] = Variable<String>(
        $CitationItemsTable.$convertertimeRangesn.toSql(timeRanges),
      );
    }
    if (!nullToAbsent || rects != null) {
      map['rects'] = Variable<String>(
        $CitationItemsTable.$converterrectsn.toSql(rects),
      );
    }
    return map;
  }

  CitationItemsCompanion toCompanion(bool nullToAbsent) {
    return CitationItemsCompanion(
      id: Value(id),
      citedText: citedText == null && nullToAbsent
          ? const Value.absent()
          : Value(citedText),
      sourceIds: sourceIds == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceIds),
      pageNumbers: pageNumbers == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumbers),
      timeRanges: timeRanges == null && nullToAbsent
          ? const Value.absent()
          : Value(timeRanges),
      rects: rects == null && nullToAbsent
          ? const Value.absent()
          : Value(rects),
    );
  }

  factory CitationItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitationItem(
      id: serializer.fromJson<String>(json['id']),
      citedText: serializer.fromJson<String?>(json['citedText']),
      sourceIds: serializer.fromJson<List<String>?>(json['sourceIds']),
      pageNumbers: serializer.fromJson<List<int>?>(json['pageNumbers']),
      timeRanges: serializer.fromJson<List<ProjectTimeRange>?>(
        json['timeRanges'],
      ),
      rects: serializer.fromJson<List<ProjectRect>?>(json['rects']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'citedText': serializer.toJson<String?>(citedText),
      'sourceIds': serializer.toJson<List<String>?>(sourceIds),
      'pageNumbers': serializer.toJson<List<int>?>(pageNumbers),
      'timeRanges': serializer.toJson<List<ProjectTimeRange>?>(timeRanges),
      'rects': serializer.toJson<List<ProjectRect>?>(rects),
    };
  }

  CitationItem copyWith({
    String? id,
    Value<String?> citedText = const Value.absent(),
    Value<List<String>?> sourceIds = const Value.absent(),
    Value<List<int>?> pageNumbers = const Value.absent(),
    Value<List<ProjectTimeRange>?> timeRanges = const Value.absent(),
    Value<List<ProjectRect>?> rects = const Value.absent(),
  }) => CitationItem(
    id: id ?? this.id,
    citedText: citedText.present ? citedText.value : this.citedText,
    sourceIds: sourceIds.present ? sourceIds.value : this.sourceIds,
    pageNumbers: pageNumbers.present ? pageNumbers.value : this.pageNumbers,
    timeRanges: timeRanges.present ? timeRanges.value : this.timeRanges,
    rects: rects.present ? rects.value : this.rects,
  );
  CitationItem copyWithCompanion(CitationItemsCompanion data) {
    return CitationItem(
      id: data.id.present ? data.id.value : this.id,
      citedText: data.citedText.present ? data.citedText.value : this.citedText,
      sourceIds: data.sourceIds.present ? data.sourceIds.value : this.sourceIds,
      pageNumbers: data.pageNumbers.present
          ? data.pageNumbers.value
          : this.pageNumbers,
      timeRanges: data.timeRanges.present
          ? data.timeRanges.value
          : this.timeRanges,
      rects: data.rects.present ? data.rects.value : this.rects,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitationItem(')
          ..write('id: $id, ')
          ..write('citedText: $citedText, ')
          ..write('sourceIds: $sourceIds, ')
          ..write('pageNumbers: $pageNumbers, ')
          ..write('timeRanges: $timeRanges, ')
          ..write('rects: $rects')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, citedText, sourceIds, pageNumbers, timeRanges, rects);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitationItem &&
          other.id == this.id &&
          other.citedText == this.citedText &&
          other.sourceIds == this.sourceIds &&
          other.pageNumbers == this.pageNumbers &&
          other.timeRanges == this.timeRanges &&
          other.rects == this.rects);
}

class CitationItemsCompanion extends UpdateCompanion<CitationItem> {
  final Value<String> id;
  final Value<String?> citedText;
  final Value<List<String>?> sourceIds;
  final Value<List<int>?> pageNumbers;
  final Value<List<ProjectTimeRange>?> timeRanges;
  final Value<List<ProjectRect>?> rects;
  final Value<int> rowid;
  const CitationItemsCompanion({
    this.id = const Value.absent(),
    this.citedText = const Value.absent(),
    this.sourceIds = const Value.absent(),
    this.pageNumbers = const Value.absent(),
    this.timeRanges = const Value.absent(),
    this.rects = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitationItemsCompanion.insert({
    required String id,
    this.citedText = const Value.absent(),
    this.sourceIds = const Value.absent(),
    this.pageNumbers = const Value.absent(),
    this.timeRanges = const Value.absent(),
    this.rects = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<CitationItem> custom({
    Expression<String>? id,
    Expression<String>? citedText,
    Expression<String>? sourceIds,
    Expression<String>? pageNumbers,
    Expression<String>? timeRanges,
    Expression<String>? rects,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (citedText != null) 'cited_text': citedText,
      if (sourceIds != null) 'source_ids': sourceIds,
      if (pageNumbers != null) 'page_numbers': pageNumbers,
      if (timeRanges != null) 'time_ranges': timeRanges,
      if (rects != null) 'rects': rects,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitationItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? citedText,
    Value<List<String>?>? sourceIds,
    Value<List<int>?>? pageNumbers,
    Value<List<ProjectTimeRange>?>? timeRanges,
    Value<List<ProjectRect>?>? rects,
    Value<int>? rowid,
  }) {
    return CitationItemsCompanion(
      id: id ?? this.id,
      citedText: citedText ?? this.citedText,
      sourceIds: sourceIds ?? this.sourceIds,
      pageNumbers: pageNumbers ?? this.pageNumbers,
      timeRanges: timeRanges ?? this.timeRanges,
      rects: rects ?? this.rects,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (citedText.present) {
      map['cited_text'] = Variable<String>(citedText.value);
    }
    if (sourceIds.present) {
      map['source_ids'] = Variable<String>(
        $CitationItemsTable.$convertersourceIdsn.toSql(sourceIds.value),
      );
    }
    if (pageNumbers.present) {
      map['page_numbers'] = Variable<String>(
        $CitationItemsTable.$converterpageNumbersn.toSql(pageNumbers.value),
      );
    }
    if (timeRanges.present) {
      map['time_ranges'] = Variable<String>(
        $CitationItemsTable.$convertertimeRangesn.toSql(timeRanges.value),
      );
    }
    if (rects.present) {
      map['rects'] = Variable<String>(
        $CitationItemsTable.$converterrectsn.toSql(rects.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitationItemsCompanion(')
          ..write('id: $id, ')
          ..write('citedText: $citedText, ')
          ..write('sourceIds: $sourceIds, ')
          ..write('pageNumbers: $pageNumbers, ')
          ..write('timeRanges: $timeRanges, ')
          ..write('rects: $rects, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetItemsTable extends AssetItems
    with TableInfo<$AssetItemsTable, AssetItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<Uint8List> data = GeneratedColumn<Uint8List>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MediaType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaType>($AssetItemsTable.$convertertype);
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    data,
    name,
    type,
    sourceId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}data'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      type: $AssetItemsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AssetItemsTable createAlias(String alias) {
    return $AssetItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaType, String, String> $convertertype =
      const EnumNameConverter<MediaType>(MediaType.values);
}

class AssetItem extends DataClass implements Insertable<AssetItem> {
  final String id;
  final Uint8List data;
  final String? name;
  final MediaType type;
  final String? sourceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AssetItem({
    required this.id,
    required this.data,
    this.name,
    required this.type,
    this.sourceId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data'] = Variable<Uint8List>(data);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    {
      map['type'] = Variable<String>(
        $AssetItemsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AssetItemsCompanion toCompanion(bool nullToAbsent) {
    return AssetItemsCompanion(
      id: Value(id),
      data: Value(data),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: Value(type),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssetItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetItem(
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<Uint8List>(json['data']),
      name: serializer.fromJson<String?>(json['name']),
      type: $AssetItemsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<Uint8List>(data),
      'name': serializer.toJson<String?>(name),
      'type': serializer.toJson<String>(
        $AssetItemsTable.$convertertype.toJson(type),
      ),
      'sourceId': serializer.toJson<String?>(sourceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AssetItem copyWith({
    String? id,
    Uint8List? data,
    Value<String?> name = const Value.absent(),
    MediaType? type,
    Value<String?> sourceId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AssetItem(
    id: id ?? this.id,
    data: data ?? this.data,
    name: name.present ? name.value : this.name,
    type: type ?? this.type,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssetItem copyWithCompanion(AssetItemsCompanion data) {
    return AssetItem(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetItem(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('sourceId: $sourceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    $driftBlobEquality.hash(data),
    name,
    type,
    sourceId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetItem &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.data, this.data) &&
          other.name == this.name &&
          other.type == this.type &&
          other.sourceId == this.sourceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AssetItemsCompanion extends UpdateCompanion<AssetItem> {
  final Value<String> id;
  final Value<Uint8List> data;
  final Value<String?> name;
  final Value<MediaType> type;
  final Value<String?> sourceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AssetItemsCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetItemsCompanion.insert({
    required String id,
    required Uint8List data,
    this.name = const Value.absent(),
    required MediaType type,
    this.sourceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       data = Value(data),
       type = Value(type);
  static Insertable<AssetItem> custom({
    Expression<String>? id,
    Expression<Uint8List>? data,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? sourceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (sourceId != null) 'source_id': sourceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetItemsCompanion copyWith({
    Value<String>? id,
    Value<Uint8List>? data,
    Value<String?>? name,
    Value<MediaType>? type,
    Value<String?>? sourceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AssetItemsCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      name: name ?? this.name,
      type: type ?? this.type,
      sourceId: sourceId ?? this.sourceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<Uint8List>(data.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AssetItemsTable.$convertertype.toSql(type.value),
      );
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetItemsCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('sourceId: $sourceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudyFolderItemsTable studyFolderItems = $StudyFolderItemsTable(
    this,
  );
  late final $SourceItemsTable sourceItems = $SourceItemsTable(this);
  late final $DeckItemsTable deckItems = $DeckItemsTable(this);
  late final $SourceItemBlobsTable sourceItemBlobs = $SourceItemBlobsTable(
    this,
  );
  late final $CardCreationDraftItemsTable cardCreationDraftItems =
      $CardCreationDraftItemsTable(this);
  late final $CardItemsTable cardItems = $CardItemsTable(this);
  late final $StudySessionEventsTable studySessionEvents =
      $StudySessionEventsTable(this);
  late final $CitationItemsTable citationItems = $CitationItemsTable(this);
  late final $AssetItemsTable assetItems = $AssetItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    studyFolderItems,
    sourceItems,
    deckItems,
    sourceItemBlobs,
    cardCreationDraftItems,
    cardItems,
    studySessionEvents,
    citationItems,
    assetItems,
  ];
}

typedef $$StudyFolderItemsTableCreateCompanionBuilder =
    StudyFolderItemsCompanion Function({
      required String id,
      required String name,
      required String createdAt,
      required String updatedAt,
      Value<bool> isPinned,
      Value<int> rowid,
    });
typedef $$StudyFolderItemsTableUpdateCompanionBuilder =
    StudyFolderItemsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<bool> isPinned,
      Value<int> rowid,
    });

final class $$StudyFolderItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StudyFolderItemsTable, StudyFolderItem> {
  $$StudyFolderItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SourceItemsTable, List<SourceItem>>
  _sourceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceItems,
    aliasName: $_aliasNameGenerator(
      db.studyFolderItems.id,
      db.sourceItems.folderId,
    ),
  );

  $$SourceItemsTableProcessedTableManager get sourceItemsRefs {
    final manager = $$SourceItemsTableTableManager(
      $_db,
      $_db.sourceItems,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeckItemsTable, List<DeckItem>>
  _deckItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deckItems,
    aliasName: $_aliasNameGenerator(
      db.studyFolderItems.id,
      db.deckItems.folderId,
    ),
  );

  $$DeckItemsTableProcessedTableManager get deckItemsRefs {
    final manager = $$DeckItemsTableTableManager(
      $_db,
      $_db.deckItems,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_deckItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudyFolderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyFolderItemsTable> {
  $$StudyFolderItemsTableFilterComposer({
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

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sourceItemsRefs(
    Expression<bool> Function($$SourceItemsTableFilterComposer f) f,
  ) {
    final $$SourceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceItemsTableFilterComposer(
            $db: $db,
            $table: $db.sourceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deckItemsRefs(
    Expression<bool> Function($$DeckItemsTableFilterComposer f) f,
  ) {
    final $$DeckItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckItems,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckItemsTableFilterComposer(
            $db: $db,
            $table: $db.deckItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyFolderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyFolderItemsTable> {
  $$StudyFolderItemsTableOrderingComposer({
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

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyFolderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyFolderItemsTable> {
  $$StudyFolderItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  Expression<T> sourceItemsRefs<T extends Object>(
    Expression<T> Function($$SourceItemsTableAnnotationComposer a) f,
  ) {
    final $$SourceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deckItemsRefs<T extends Object>(
    Expression<T> Function($$DeckItemsTableAnnotationComposer a) f,
  ) {
    final $$DeckItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckItems,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.deckItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyFolderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyFolderItemsTable,
          StudyFolderItem,
          $$StudyFolderItemsTableFilterComposer,
          $$StudyFolderItemsTableOrderingComposer,
          $$StudyFolderItemsTableAnnotationComposer,
          $$StudyFolderItemsTableCreateCompanionBuilder,
          $$StudyFolderItemsTableUpdateCompanionBuilder,
          (StudyFolderItem, $$StudyFolderItemsTableReferences),
          StudyFolderItem,
          PrefetchHooks Function({bool sourceItemsRefs, bool deckItemsRefs})
        > {
  $$StudyFolderItemsTableTableManager(
    _$AppDatabase db,
    $StudyFolderItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyFolderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyFolderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyFolderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyFolderItemsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isPinned: isPinned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String createdAt,
                required String updatedAt,
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyFolderItemsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isPinned: isPinned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyFolderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceItemsRefs = false, deckItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceItemsRefs) db.sourceItems,
                    if (deckItemsRefs) db.deckItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceItemsRefs)
                        await $_getPrefetchedData<
                          StudyFolderItem,
                          $StudyFolderItemsTable,
                          SourceItem
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderItemsTableReferences
                              ._sourceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deckItemsRefs)
                        await $_getPrefetchedData<
                          StudyFolderItem,
                          $StudyFolderItemsTable,
                          DeckItem
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderItemsTableReferences
                              ._deckItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).deckItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudyFolderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyFolderItemsTable,
      StudyFolderItem,
      $$StudyFolderItemsTableFilterComposer,
      $$StudyFolderItemsTableOrderingComposer,
      $$StudyFolderItemsTableAnnotationComposer,
      $$StudyFolderItemsTableCreateCompanionBuilder,
      $$StudyFolderItemsTableUpdateCompanionBuilder,
      (StudyFolderItem, $$StudyFolderItemsTableReferences),
      StudyFolderItem,
      PrefetchHooks Function({bool sourceItemsRefs, bool deckItemsRefs})
    >;
typedef $$SourceItemsTableCreateCompanionBuilder =
    SourceItemsCompanion Function({
      required String id,
      Value<String?> folderId,
      required String label,
      Value<String?> path,
      required MediaType type,
      Value<String?> extractedContent,
      Value<bool> isPinned,
      Value<int> rowid,
    });
typedef $$SourceItemsTableUpdateCompanionBuilder =
    SourceItemsCompanion Function({
      Value<String> id,
      Value<String?> folderId,
      Value<String> label,
      Value<String?> path,
      Value<MediaType> type,
      Value<String?> extractedContent,
      Value<bool> isPinned,
      Value<int> rowid,
    });

final class $$SourceItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SourceItemsTable, SourceItem> {
  $$SourceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudyFolderItemsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderItems.createAlias(
        $_aliasNameGenerator(db.sourceItems.folderId, db.studyFolderItems.id),
      );

  $$StudyFolderItemsTableProcessedTableManager? get folderId {
    final $_column = $_itemColumn<String>('folder_id');
    if ($_column == null) return null;
    final manager = $$StudyFolderItemsTableTableManager(
      $_db,
      $_db.studyFolderItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnWithTypeConverterFilters<MediaType, MediaType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get extractedContent => $composableBuilder(
    column: $table.extractedContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  $$StudyFolderItemsTableFilterComposer get folderId {
    final $$StudyFolderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderItemsTableFilterComposer(
            $db: $db,
            $table: $db.studyFolderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<String> get extractedContent => $composableBuilder(
    column: $table.extractedContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudyFolderItemsTableOrderingComposer get folderId {
    final $$StudyFolderItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderItemsTableOrderingComposer(
            $db: $db,
            $table: $db.studyFolderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumnWithTypeConverter<MediaType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get extractedContent => $composableBuilder(
    column: $table.extractedContent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  $$StudyFolderItemsTableAnnotationComposer get folderId {
    final $$StudyFolderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyFolderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (SourceItem, $$SourceItemsTableReferences),
          SourceItem,
          PrefetchHooks Function({bool folderId})
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
                Value<String?> folderId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<MediaType> type = const Value.absent(),
                Value<String?> extractedContent = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceItemsCompanion(
                id: id,
                folderId: folderId,
                label: label,
                path: path,
                type: type,
                extractedContent: extractedContent,
                isPinned: isPinned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> folderId = const Value.absent(),
                required String label,
                Value<String?> path = const Value.absent(),
                required MediaType type,
                Value<String?> extractedContent = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceItemsCompanion.insert(
                id: id,
                folderId: folderId,
                label: label,
                path: path,
                type: type,
                extractedContent: extractedContent,
                isPinned: isPinned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourceItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable: $$SourceItemsTableReferences
                                    ._folderIdTable(db),
                                referencedColumn: $$SourceItemsTableReferences
                                    ._folderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (SourceItem, $$SourceItemsTableReferences),
      SourceItem,
      PrefetchHooks Function({bool folderId})
    >;
typedef $$DeckItemsTableCreateCompanionBuilder =
    DeckItemsCompanion Function({
      required String id,
      required String folderId,
      required String name,
      Value<String?> description,
      Value<bool> isPinned,
      Value<int> rowid,
    });
typedef $$DeckItemsTableUpdateCompanionBuilder =
    DeckItemsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String> name,
      Value<String?> description,
      Value<bool> isPinned,
      Value<int> rowid,
    });

final class $$DeckItemsTableReferences
    extends BaseReferences<_$AppDatabase, $DeckItemsTable, DeckItem> {
  $$DeckItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudyFolderItemsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderItems.createAlias(
        $_aliasNameGenerator(db.deckItems.folderId, db.studyFolderItems.id),
      );

  $$StudyFolderItemsTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<String>('folder_id')!;

    final manager = $$StudyFolderItemsTableTableManager(
      $_db,
      $_db.studyFolderItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CardItemsTable, List<CardItem>>
  _cardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardItems,
    aliasName: $_aliasNameGenerator(db.deckItems.id, db.cardItems.deckId),
  );

  $$CardItemsTableProcessedTableManager get cardItemsRefs {
    final manager = $$CardItemsTableTableManager(
      $_db,
      $_db.cardItems,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DeckItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DeckItemsTable> {
  $$DeckItemsTableFilterComposer({
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

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  $$StudyFolderItemsTableFilterComposer get folderId {
    final $$StudyFolderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderItemsTableFilterComposer(
            $db: $db,
            $table: $db.studyFolderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardItemsRefs(
    Expression<bool> Function($$CardItemsTableFilterComposer f) f,
  ) {
    final $$CardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardItems,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardItemsTableFilterComposer(
            $db: $db,
            $table: $db.cardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeckItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeckItemsTable> {
  $$DeckItemsTableOrderingComposer({
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

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudyFolderItemsTableOrderingComposer get folderId {
    final $$StudyFolderItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderItemsTableOrderingComposer(
            $db: $db,
            $table: $db.studyFolderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeckItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeckItemsTable> {
  $$DeckItemsTableAnnotationComposer({
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

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  $$StudyFolderItemsTableAnnotationComposer get folderId {
    final $$StudyFolderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.studyFolderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyFolderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyFolderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardItemsRefs<T extends Object>(
    Expression<T> Function($$CardItemsTableAnnotationComposer a) f,
  ) {
    final $$CardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardItems,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeckItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeckItemsTable,
          DeckItem,
          $$DeckItemsTableFilterComposer,
          $$DeckItemsTableOrderingComposer,
          $$DeckItemsTableAnnotationComposer,
          $$DeckItemsTableCreateCompanionBuilder,
          $$DeckItemsTableUpdateCompanionBuilder,
          (DeckItem, $$DeckItemsTableReferences),
          DeckItem,
          PrefetchHooks Function({bool folderId, bool cardItemsRefs})
        > {
  $$DeckItemsTableTableManager(_$AppDatabase db, $DeckItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folderId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeckItemsCompanion(
                id: id,
                folderId: folderId,
                name: name,
                description: description,
                isPinned: isPinned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folderId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeckItemsCompanion.insert(
                id: id,
                folderId: folderId,
                name: name,
                description: description,
                isPinned: isPinned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeckItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false, cardItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardItemsRefs) db.cardItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable: $$DeckItemsTableReferences
                                    ._folderIdTable(db),
                                referencedColumn: $$DeckItemsTableReferences
                                    ._folderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardItemsRefs)
                    await $_getPrefetchedData<
                      DeckItem,
                      $DeckItemsTable,
                      CardItem
                    >(
                      currentTable: table,
                      referencedTable: $$DeckItemsTableReferences
                          ._cardItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DeckItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).cardItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deckId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DeckItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeckItemsTable,
      DeckItem,
      $$DeckItemsTableFilterComposer,
      $$DeckItemsTableOrderingComposer,
      $$DeckItemsTableAnnotationComposer,
      $$DeckItemsTableCreateCompanionBuilder,
      $$DeckItemsTableUpdateCompanionBuilder,
      (DeckItem, $$DeckItemsTableReferences),
      DeckItem,
      PrefetchHooks Function({bool folderId, bool cardItemsRefs})
    >;
typedef $$SourceItemBlobsTableCreateCompanionBuilder =
    SourceItemBlobsCompanion Function({
      required String id,
      required String sourceItemId,
      required String sourceItemName,
      required SourceFileType type,
      required Uint8List bytes,
      Value<int> rowid,
    });
typedef $$SourceItemBlobsTableUpdateCompanionBuilder =
    SourceItemBlobsCompanion Function({
      Value<String> id,
      Value<String> sourceItemId,
      Value<String> sourceItemName,
      Value<SourceFileType> type,
      Value<Uint8List> bytes,
      Value<int> rowid,
    });

class $$SourceItemBlobsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceItemBlobsTable> {
  $$SourceItemBlobsTableFilterComposer({
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

  ColumnFilters<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceItemName => $composableBuilder(
    column: $table.sourceItemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SourceFileType, SourceFileType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourceItemBlobsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceItemBlobsTable> {
  $$SourceItemBlobsTableOrderingComposer({
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

  ColumnOrderings<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceItemName => $composableBuilder(
    column: $table.sourceItemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceItemBlobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceItemBlobsTable> {
  $$SourceItemBlobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceItemName => $composableBuilder(
    column: $table.sourceItemName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SourceFileType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<Uint8List> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);
}

class $$SourceItemBlobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceItemBlobsTable,
          SourceItemBlob,
          $$SourceItemBlobsTableFilterComposer,
          $$SourceItemBlobsTableOrderingComposer,
          $$SourceItemBlobsTableAnnotationComposer,
          $$SourceItemBlobsTableCreateCompanionBuilder,
          $$SourceItemBlobsTableUpdateCompanionBuilder,
          (
            SourceItemBlob,
            BaseReferences<
              _$AppDatabase,
              $SourceItemBlobsTable,
              SourceItemBlob
            >,
          ),
          SourceItemBlob,
          PrefetchHooks Function()
        > {
  $$SourceItemBlobsTableTableManager(
    _$AppDatabase db,
    $SourceItemBlobsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceItemBlobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceItemBlobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceItemBlobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceItemId = const Value.absent(),
                Value<String> sourceItemName = const Value.absent(),
                Value<SourceFileType> type = const Value.absent(),
                Value<Uint8List> bytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceItemBlobsCompanion(
                id: id,
                sourceItemId: sourceItemId,
                sourceItemName: sourceItemName,
                type: type,
                bytes: bytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceItemId,
                required String sourceItemName,
                required SourceFileType type,
                required Uint8List bytes,
                Value<int> rowid = const Value.absent(),
              }) => SourceItemBlobsCompanion.insert(
                id: id,
                sourceItemId: sourceItemId,
                sourceItemName: sourceItemName,
                type: type,
                bytes: bytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourceItemBlobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceItemBlobsTable,
      SourceItemBlob,
      $$SourceItemBlobsTableFilterComposer,
      $$SourceItemBlobsTableOrderingComposer,
      $$SourceItemBlobsTableAnnotationComposer,
      $$SourceItemBlobsTableCreateCompanionBuilder,
      $$SourceItemBlobsTableUpdateCompanionBuilder,
      (
        SourceItemBlob,
        BaseReferences<_$AppDatabase, $SourceItemBlobsTable, SourceItemBlob>,
      ),
      SourceItemBlob,
      PrefetchHooks Function()
    >;
typedef $$CardCreationDraftItemsTableCreateCompanionBuilder =
    CardCreationDraftItemsCompanion Function({
      required String id,
      required String folderId,
      required String deckId,
      required String createdAt,
      required String updatedAt,
      Value<String?> lastOpenedSourceId,
      Value<String?> lastOpenedPage,
      Value<int> rowid,
    });
typedef $$CardCreationDraftItemsTableUpdateCompanionBuilder =
    CardCreationDraftItemsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String> deckId,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> lastOpenedSourceId,
      Value<String?> lastOpenedPage,
      Value<int> rowid,
    });

final class $$CardCreationDraftItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CardCreationDraftItemsTable,
          CardCreationDraftItem
        > {
  $$CardCreationDraftItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CardItemsTable, List<CardItem>>
  _cardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardItems,
    aliasName: $_aliasNameGenerator(
      db.cardCreationDraftItems.id,
      db.cardItems.draftId,
    ),
  );

  $$CardItemsTableProcessedTableManager get cardItemsRefs {
    final manager = $$CardItemsTableTableManager(
      $_db,
      $_db.cardItems,
    ).filter((f) => f.draftId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardCreationDraftItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CardCreationDraftItemsTable> {
  $$CardCreationDraftItemsTableFilterComposer({
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

  ColumnFilters<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastOpenedSourceId => $composableBuilder(
    column: $table.lastOpenedSourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastOpenedPage => $composableBuilder(
    column: $table.lastOpenedPage,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cardItemsRefs(
    Expression<bool> Function($$CardItemsTableFilterComposer f) f,
  ) {
    final $$CardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardItems,
      getReferencedColumn: (t) => t.draftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardItemsTableFilterComposer(
            $db: $db,
            $table: $db.cardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardCreationDraftItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardCreationDraftItemsTable> {
  $$CardCreationDraftItemsTableOrderingComposer({
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

  ColumnOrderings<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastOpenedSourceId => $composableBuilder(
    column: $table.lastOpenedSourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastOpenedPage => $composableBuilder(
    column: $table.lastOpenedPage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardCreationDraftItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardCreationDraftItemsTable> {
  $$CardCreationDraftItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folderId =>
      $composableBuilder(column: $table.folderId, builder: (column) => column);

  GeneratedColumn<String> get deckId =>
      $composableBuilder(column: $table.deckId, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastOpenedSourceId => $composableBuilder(
    column: $table.lastOpenedSourceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastOpenedPage => $composableBuilder(
    column: $table.lastOpenedPage,
    builder: (column) => column,
  );

  Expression<T> cardItemsRefs<T extends Object>(
    Expression<T> Function($$CardItemsTableAnnotationComposer a) f,
  ) {
    final $$CardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardItems,
      getReferencedColumn: (t) => t.draftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardCreationDraftItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardCreationDraftItemsTable,
          CardCreationDraftItem,
          $$CardCreationDraftItemsTableFilterComposer,
          $$CardCreationDraftItemsTableOrderingComposer,
          $$CardCreationDraftItemsTableAnnotationComposer,
          $$CardCreationDraftItemsTableCreateCompanionBuilder,
          $$CardCreationDraftItemsTableUpdateCompanionBuilder,
          (CardCreationDraftItem, $$CardCreationDraftItemsTableReferences),
          CardCreationDraftItem,
          PrefetchHooks Function({bool cardItemsRefs})
        > {
  $$CardCreationDraftItemsTableTableManager(
    _$AppDatabase db,
    $CardCreationDraftItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardCreationDraftItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CardCreationDraftItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CardCreationDraftItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folderId = const Value.absent(),
                Value<String> deckId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> lastOpenedSourceId = const Value.absent(),
                Value<String?> lastOpenedPage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardCreationDraftItemsCompanion(
                id: id,
                folderId: folderId,
                deckId: deckId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastOpenedSourceId: lastOpenedSourceId,
                lastOpenedPage: lastOpenedPage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folderId,
                required String deckId,
                required String createdAt,
                required String updatedAt,
                Value<String?> lastOpenedSourceId = const Value.absent(),
                Value<String?> lastOpenedPage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardCreationDraftItemsCompanion.insert(
                id: id,
                folderId: folderId,
                deckId: deckId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastOpenedSourceId: lastOpenedSourceId,
                lastOpenedPage: lastOpenedPage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardCreationDraftItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardItemsRefs) db.cardItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardItemsRefs)
                    await $_getPrefetchedData<
                      CardCreationDraftItem,
                      $CardCreationDraftItemsTable,
                      CardItem
                    >(
                      currentTable: table,
                      referencedTable: $$CardCreationDraftItemsTableReferences
                          ._cardItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CardCreationDraftItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).cardItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.draftId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CardCreationDraftItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardCreationDraftItemsTable,
      CardCreationDraftItem,
      $$CardCreationDraftItemsTableFilterComposer,
      $$CardCreationDraftItemsTableOrderingComposer,
      $$CardCreationDraftItemsTableAnnotationComposer,
      $$CardCreationDraftItemsTableCreateCompanionBuilder,
      $$CardCreationDraftItemsTableUpdateCompanionBuilder,
      (CardCreationDraftItem, $$CardCreationDraftItemsTableReferences),
      CardCreationDraftItem,
      PrefetchHooks Function({bool cardItemsRefs})
    >;
typedef $$CardItemsTableCreateCompanionBuilder =
    CardItemsCompanion Function({
      required String id,
      Value<String?> frontText,
      Value<String?> backText,
      Value<String?> frontImageId,
      Value<String?> backImageId,
      Value<CardOcclusion?> occlusionData,
      Value<DateTime> spacedDue,
      Value<double> spacedStability,
      Value<double> spacedDifficulty,
      Value<int> spacedState,
      Value<int> spacedStep,
      Value<DateTime?> spacedLastReview,
      Value<DateTime> drillDue,
      Value<double> drillStability,
      Value<double> drillDifficulty,
      Value<int> drillState,
      Value<int> drillStep,
      Value<DateTime?> drillLastReview,
      Value<String?> deckId,
      Value<String?> draftId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CardItemsTableUpdateCompanionBuilder =
    CardItemsCompanion Function({
      Value<String> id,
      Value<String?> frontText,
      Value<String?> backText,
      Value<String?> frontImageId,
      Value<String?> backImageId,
      Value<CardOcclusion?> occlusionData,
      Value<DateTime> spacedDue,
      Value<double> spacedStability,
      Value<double> spacedDifficulty,
      Value<int> spacedState,
      Value<int> spacedStep,
      Value<DateTime?> spacedLastReview,
      Value<DateTime> drillDue,
      Value<double> drillStability,
      Value<double> drillDifficulty,
      Value<int> drillState,
      Value<int> drillStep,
      Value<DateTime?> drillLastReview,
      Value<String?> deckId,
      Value<String?> draftId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CardItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CardItemsTable, CardItem> {
  $$CardItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeckItemsTable _deckIdTable(_$AppDatabase db) => db.deckItems
      .createAlias($_aliasNameGenerator(db.cardItems.deckId, db.deckItems.id));

  $$DeckItemsTableProcessedTableManager? get deckId {
    final $_column = $_itemColumn<String>('deck_id');
    if ($_column == null) return null;
    final manager = $$DeckItemsTableTableManager(
      $_db,
      $_db.deckItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CardCreationDraftItemsTable _draftIdTable(_$AppDatabase db) =>
      db.cardCreationDraftItems.createAlias(
        $_aliasNameGenerator(
          db.cardItems.draftId,
          db.cardCreationDraftItems.id,
        ),
      );

  $$CardCreationDraftItemsTableProcessedTableManager? get draftId {
    final $_column = $_itemColumn<String>('draft_id');
    if ($_column == null) return null;
    final manager = $$CardCreationDraftItemsTableTableManager(
      $_db,
      $_db.cardCreationDraftItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_draftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CardItemsTable> {
  $$CardItemsTableFilterComposer({
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

  ColumnFilters<String> get frontText => $composableBuilder(
    column: $table.frontText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backText => $composableBuilder(
    column: $table.backText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frontImageId => $composableBuilder(
    column: $table.frontImageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backImageId => $composableBuilder(
    column: $table.backImageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CardOcclusion?, CardOcclusion, String>
  get occlusionData => $composableBuilder(
    column: $table.occlusionData,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get spacedDue => $composableBuilder(
    column: $table.spacedDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spacedStability => $composableBuilder(
    column: $table.spacedStability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spacedDifficulty => $composableBuilder(
    column: $table.spacedDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spacedState => $composableBuilder(
    column: $table.spacedState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spacedStep => $composableBuilder(
    column: $table.spacedStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get spacedLastReview => $composableBuilder(
    column: $table.spacedLastReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get drillDue => $composableBuilder(
    column: $table.drillDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get drillStability => $composableBuilder(
    column: $table.drillStability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get drillDifficulty => $composableBuilder(
    column: $table.drillDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get drillState => $composableBuilder(
    column: $table.drillState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get drillStep => $composableBuilder(
    column: $table.drillStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get drillLastReview => $composableBuilder(
    column: $table.drillLastReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DeckItemsTableFilterComposer get deckId {
    final $$DeckItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.deckItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckItemsTableFilterComposer(
            $db: $db,
            $table: $db.deckItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardCreationDraftItemsTableFilterComposer get draftId {
    final $$CardCreationDraftItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.draftId,
          referencedTable: $db.cardCreationDraftItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardCreationDraftItemsTableFilterComposer(
                $db: $db,
                $table: $db.cardCreationDraftItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CardItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardItemsTable> {
  $$CardItemsTableOrderingComposer({
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

  ColumnOrderings<String> get frontText => $composableBuilder(
    column: $table.frontText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backText => $composableBuilder(
    column: $table.backText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frontImageId => $composableBuilder(
    column: $table.frontImageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backImageId => $composableBuilder(
    column: $table.backImageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occlusionData => $composableBuilder(
    column: $table.occlusionData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get spacedDue => $composableBuilder(
    column: $table.spacedDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spacedStability => $composableBuilder(
    column: $table.spacedStability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spacedDifficulty => $composableBuilder(
    column: $table.spacedDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spacedState => $composableBuilder(
    column: $table.spacedState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spacedStep => $composableBuilder(
    column: $table.spacedStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get spacedLastReview => $composableBuilder(
    column: $table.spacedLastReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get drillDue => $composableBuilder(
    column: $table.drillDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get drillStability => $composableBuilder(
    column: $table.drillStability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get drillDifficulty => $composableBuilder(
    column: $table.drillDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get drillState => $composableBuilder(
    column: $table.drillState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get drillStep => $composableBuilder(
    column: $table.drillStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get drillLastReview => $composableBuilder(
    column: $table.drillLastReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DeckItemsTableOrderingComposer get deckId {
    final $$DeckItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.deckItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckItemsTableOrderingComposer(
            $db: $db,
            $table: $db.deckItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardCreationDraftItemsTableOrderingComposer get draftId {
    final $$CardCreationDraftItemsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.draftId,
          referencedTable: $db.cardCreationDraftItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardCreationDraftItemsTableOrderingComposer(
                $db: $db,
                $table: $db.cardCreationDraftItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CardItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardItemsTable> {
  $$CardItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get frontText =>
      $composableBuilder(column: $table.frontText, builder: (column) => column);

  GeneratedColumn<String> get backText =>
      $composableBuilder(column: $table.backText, builder: (column) => column);

  GeneratedColumn<String> get frontImageId => $composableBuilder(
    column: $table.frontImageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backImageId => $composableBuilder(
    column: $table.backImageId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CardOcclusion?, String> get occlusionData =>
      $composableBuilder(
        column: $table.occlusionData,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get spacedDue =>
      $composableBuilder(column: $table.spacedDue, builder: (column) => column);

  GeneratedColumn<double> get spacedStability => $composableBuilder(
    column: $table.spacedStability,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spacedDifficulty => $composableBuilder(
    column: $table.spacedDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spacedState => $composableBuilder(
    column: $table.spacedState,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spacedStep => $composableBuilder(
    column: $table.spacedStep,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get spacedLastReview => $composableBuilder(
    column: $table.spacedLastReview,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get drillDue =>
      $composableBuilder(column: $table.drillDue, builder: (column) => column);

  GeneratedColumn<double> get drillStability => $composableBuilder(
    column: $table.drillStability,
    builder: (column) => column,
  );

  GeneratedColumn<double> get drillDifficulty => $composableBuilder(
    column: $table.drillDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get drillState => $composableBuilder(
    column: $table.drillState,
    builder: (column) => column,
  );

  GeneratedColumn<int> get drillStep =>
      $composableBuilder(column: $table.drillStep, builder: (column) => column);

  GeneratedColumn<DateTime> get drillLastReview => $composableBuilder(
    column: $table.drillLastReview,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DeckItemsTableAnnotationComposer get deckId {
    final $$DeckItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.deckItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.deckItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardCreationDraftItemsTableAnnotationComposer get draftId {
    final $$CardCreationDraftItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.draftId,
          referencedTable: $db.cardCreationDraftItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardCreationDraftItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.cardCreationDraftItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CardItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardItemsTable,
          CardItem,
          $$CardItemsTableFilterComposer,
          $$CardItemsTableOrderingComposer,
          $$CardItemsTableAnnotationComposer,
          $$CardItemsTableCreateCompanionBuilder,
          $$CardItemsTableUpdateCompanionBuilder,
          (CardItem, $$CardItemsTableReferences),
          CardItem,
          PrefetchHooks Function({bool deckId, bool draftId})
        > {
  $$CardItemsTableTableManager(_$AppDatabase db, $CardItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> frontText = const Value.absent(),
                Value<String?> backText = const Value.absent(),
                Value<String?> frontImageId = const Value.absent(),
                Value<String?> backImageId = const Value.absent(),
                Value<CardOcclusion?> occlusionData = const Value.absent(),
                Value<DateTime> spacedDue = const Value.absent(),
                Value<double> spacedStability = const Value.absent(),
                Value<double> spacedDifficulty = const Value.absent(),
                Value<int> spacedState = const Value.absent(),
                Value<int> spacedStep = const Value.absent(),
                Value<DateTime?> spacedLastReview = const Value.absent(),
                Value<DateTime> drillDue = const Value.absent(),
                Value<double> drillStability = const Value.absent(),
                Value<double> drillDifficulty = const Value.absent(),
                Value<int> drillState = const Value.absent(),
                Value<int> drillStep = const Value.absent(),
                Value<DateTime?> drillLastReview = const Value.absent(),
                Value<String?> deckId = const Value.absent(),
                Value<String?> draftId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardItemsCompanion(
                id: id,
                frontText: frontText,
                backText: backText,
                frontImageId: frontImageId,
                backImageId: backImageId,
                occlusionData: occlusionData,
                spacedDue: spacedDue,
                spacedStability: spacedStability,
                spacedDifficulty: spacedDifficulty,
                spacedState: spacedState,
                spacedStep: spacedStep,
                spacedLastReview: spacedLastReview,
                drillDue: drillDue,
                drillStability: drillStability,
                drillDifficulty: drillDifficulty,
                drillState: drillState,
                drillStep: drillStep,
                drillLastReview: drillLastReview,
                deckId: deckId,
                draftId: draftId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> frontText = const Value.absent(),
                Value<String?> backText = const Value.absent(),
                Value<String?> frontImageId = const Value.absent(),
                Value<String?> backImageId = const Value.absent(),
                Value<CardOcclusion?> occlusionData = const Value.absent(),
                Value<DateTime> spacedDue = const Value.absent(),
                Value<double> spacedStability = const Value.absent(),
                Value<double> spacedDifficulty = const Value.absent(),
                Value<int> spacedState = const Value.absent(),
                Value<int> spacedStep = const Value.absent(),
                Value<DateTime?> spacedLastReview = const Value.absent(),
                Value<DateTime> drillDue = const Value.absent(),
                Value<double> drillStability = const Value.absent(),
                Value<double> drillDifficulty = const Value.absent(),
                Value<int> drillState = const Value.absent(),
                Value<int> drillStep = const Value.absent(),
                Value<DateTime?> drillLastReview = const Value.absent(),
                Value<String?> deckId = const Value.absent(),
                Value<String?> draftId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardItemsCompanion.insert(
                id: id,
                frontText: frontText,
                backText: backText,
                frontImageId: frontImageId,
                backImageId: backImageId,
                occlusionData: occlusionData,
                spacedDue: spacedDue,
                spacedStability: spacedStability,
                spacedDifficulty: spacedDifficulty,
                spacedState: spacedState,
                spacedStep: spacedStep,
                spacedLastReview: spacedLastReview,
                drillDue: drillDue,
                drillStability: drillStability,
                drillDifficulty: drillDifficulty,
                drillState: drillState,
                drillStep: drillStep,
                drillLastReview: drillLastReview,
                deckId: deckId,
                draftId: draftId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deckId = false, draftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deckId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deckId,
                                referencedTable: $$CardItemsTableReferences
                                    ._deckIdTable(db),
                                referencedColumn: $$CardItemsTableReferences
                                    ._deckIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (draftId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.draftId,
                                referencedTable: $$CardItemsTableReferences
                                    ._draftIdTable(db),
                                referencedColumn: $$CardItemsTableReferences
                                    ._draftIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardItemsTable,
      CardItem,
      $$CardItemsTableFilterComposer,
      $$CardItemsTableOrderingComposer,
      $$CardItemsTableAnnotationComposer,
      $$CardItemsTableCreateCompanionBuilder,
      $$CardItemsTableUpdateCompanionBuilder,
      (CardItem, $$CardItemsTableReferences),
      CardItem,
      PrefetchHooks Function({bool deckId, bool draftId})
    >;
typedef $$StudySessionEventsTableCreateCompanionBuilder =
    StudySessionEventsCompanion Function({
      required String id,
      required String cardId,
      required String deckId,
      required int rating,
      required String reviewedAt,
      required int scheduledDays,
      required StudySessionMode mode,
      Value<int> rowid,
    });
typedef $$StudySessionEventsTableUpdateCompanionBuilder =
    StudySessionEventsCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String> deckId,
      Value<int> rating,
      Value<String> reviewedAt,
      Value<int> scheduledDays,
      Value<StudySessionMode> mode,
      Value<int> rowid,
    });

class $$StudySessionEventsTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionEventsTable> {
  $$StudySessionEventsTableFilterComposer({
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

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StudySessionMode, StudySessionMode, String>
  get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$StudySessionEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionEventsTable> {
  $$StudySessionEventsTableOrderingComposer({
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

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudySessionEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionEventsTable> {
  $$StudySessionEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get deckId =>
      $composableBuilder(column: $table.deckId, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StudySessionMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);
}

class $$StudySessionEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionEventsTable,
          StudySessionEvent,
          $$StudySessionEventsTableFilterComposer,
          $$StudySessionEventsTableOrderingComposer,
          $$StudySessionEventsTableAnnotationComposer,
          $$StudySessionEventsTableCreateCompanionBuilder,
          $$StudySessionEventsTableUpdateCompanionBuilder,
          (
            StudySessionEvent,
            BaseReferences<
              _$AppDatabase,
              $StudySessionEventsTable,
              StudySessionEvent
            >,
          ),
          StudySessionEvent,
          PrefetchHooks Function()
        > {
  $$StudySessionEventsTableTableManager(
    _$AppDatabase db,
    $StudySessionEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> deckId = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<String> reviewedAt = const Value.absent(),
                Value<int> scheduledDays = const Value.absent(),
                Value<StudySessionMode> mode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEventsCompanion(
                id: id,
                cardId: cardId,
                deckId: deckId,
                rating: rating,
                reviewedAt: reviewedAt,
                scheduledDays: scheduledDays,
                mode: mode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                required String deckId,
                required int rating,
                required String reviewedAt,
                required int scheduledDays,
                required StudySessionMode mode,
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEventsCompanion.insert(
                id: id,
                cardId: cardId,
                deckId: deckId,
                rating: rating,
                reviewedAt: reviewedAt,
                scheduledDays: scheduledDays,
                mode: mode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudySessionEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionEventsTable,
      StudySessionEvent,
      $$StudySessionEventsTableFilterComposer,
      $$StudySessionEventsTableOrderingComposer,
      $$StudySessionEventsTableAnnotationComposer,
      $$StudySessionEventsTableCreateCompanionBuilder,
      $$StudySessionEventsTableUpdateCompanionBuilder,
      (
        StudySessionEvent,
        BaseReferences<
          _$AppDatabase,
          $StudySessionEventsTable,
          StudySessionEvent
        >,
      ),
      StudySessionEvent,
      PrefetchHooks Function()
    >;
typedef $$CitationItemsTableCreateCompanionBuilder =
    CitationItemsCompanion Function({
      required String id,
      Value<String?> citedText,
      Value<List<String>?> sourceIds,
      Value<List<int>?> pageNumbers,
      Value<List<ProjectTimeRange>?> timeRanges,
      Value<List<ProjectRect>?> rects,
      Value<int> rowid,
    });
typedef $$CitationItemsTableUpdateCompanionBuilder =
    CitationItemsCompanion Function({
      Value<String> id,
      Value<String?> citedText,
      Value<List<String>?> sourceIds,
      Value<List<int>?> pageNumbers,
      Value<List<ProjectTimeRange>?> timeRanges,
      Value<List<ProjectRect>?> rects,
      Value<int> rowid,
    });

class $$CitationItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CitationItemsTable> {
  $$CitationItemsTableFilterComposer({
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

  ColumnFilters<String> get citedText => $composableBuilder(
    column: $table.citedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get sourceIds => $composableBuilder(
    column: $table.sourceIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>?, List<int>, String>
  get pageNumbers => $composableBuilder(
    column: $table.pageNumbers,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<ProjectTimeRange>?,
    List<ProjectTimeRange>,
    String
  >
  get timeRanges => $composableBuilder(
    column: $table.timeRanges,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<ProjectRect>?, List<ProjectRect>, String>
  get rects => $composableBuilder(
    column: $table.rects,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$CitationItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CitationItemsTable> {
  $$CitationItemsTableOrderingComposer({
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

  ColumnOrderings<String> get citedText => $composableBuilder(
    column: $table.citedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceIds => $composableBuilder(
    column: $table.sourceIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pageNumbers => $composableBuilder(
    column: $table.pageNumbers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeRanges => $composableBuilder(
    column: $table.timeRanges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rects => $composableBuilder(
    column: $table.rects,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitationItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CitationItemsTable> {
  $$CitationItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get citedText =>
      $composableBuilder(column: $table.citedText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get sourceIds =>
      $composableBuilder(column: $table.sourceIds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>?, String> get pageNumbers =>
      $composableBuilder(
        column: $table.pageNumbers,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<ProjectTimeRange>?, String>
  get timeRanges => $composableBuilder(
    column: $table.timeRanges,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<ProjectRect>?, String> get rects =>
      $composableBuilder(column: $table.rects, builder: (column) => column);
}

class $$CitationItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CitationItemsTable,
          CitationItem,
          $$CitationItemsTableFilterComposer,
          $$CitationItemsTableOrderingComposer,
          $$CitationItemsTableAnnotationComposer,
          $$CitationItemsTableCreateCompanionBuilder,
          $$CitationItemsTableUpdateCompanionBuilder,
          (
            CitationItem,
            BaseReferences<_$AppDatabase, $CitationItemsTable, CitationItem>,
          ),
          CitationItem,
          PrefetchHooks Function()
        > {
  $$CitationItemsTableTableManager(_$AppDatabase db, $CitationItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitationItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitationItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitationItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> citedText = const Value.absent(),
                Value<List<String>?> sourceIds = const Value.absent(),
                Value<List<int>?> pageNumbers = const Value.absent(),
                Value<List<ProjectTimeRange>?> timeRanges =
                    const Value.absent(),
                Value<List<ProjectRect>?> rects = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitationItemsCompanion(
                id: id,
                citedText: citedText,
                sourceIds: sourceIds,
                pageNumbers: pageNumbers,
                timeRanges: timeRanges,
                rects: rects,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> citedText = const Value.absent(),
                Value<List<String>?> sourceIds = const Value.absent(),
                Value<List<int>?> pageNumbers = const Value.absent(),
                Value<List<ProjectTimeRange>?> timeRanges =
                    const Value.absent(),
                Value<List<ProjectRect>?> rects = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitationItemsCompanion.insert(
                id: id,
                citedText: citedText,
                sourceIds: sourceIds,
                pageNumbers: pageNumbers,
                timeRanges: timeRanges,
                rects: rects,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitationItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CitationItemsTable,
      CitationItem,
      $$CitationItemsTableFilterComposer,
      $$CitationItemsTableOrderingComposer,
      $$CitationItemsTableAnnotationComposer,
      $$CitationItemsTableCreateCompanionBuilder,
      $$CitationItemsTableUpdateCompanionBuilder,
      (
        CitationItem,
        BaseReferences<_$AppDatabase, $CitationItemsTable, CitationItem>,
      ),
      CitationItem,
      PrefetchHooks Function()
    >;
typedef $$AssetItemsTableCreateCompanionBuilder =
    AssetItemsCompanion Function({
      required String id,
      required Uint8List data,
      Value<String?> name,
      required MediaType type,
      Value<String?> sourceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AssetItemsTableUpdateCompanionBuilder =
    AssetItemsCompanion Function({
      Value<String> id,
      Value<Uint8List> data,
      Value<String?> name,
      Value<MediaType> type,
      Value<String?> sourceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AssetItemsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetItemsTable> {
  $$AssetItemsTableFilterComposer({
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

  ColumnFilters<Uint8List> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MediaType, MediaType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssetItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetItemsTable> {
  $$AssetItemsTableOrderingComposer({
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

  ColumnOrderings<Uint8List> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetItemsTable> {
  $$AssetItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AssetItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetItemsTable,
          AssetItem,
          $$AssetItemsTableFilterComposer,
          $$AssetItemsTableOrderingComposer,
          $$AssetItemsTableAnnotationComposer,
          $$AssetItemsTableCreateCompanionBuilder,
          $$AssetItemsTableUpdateCompanionBuilder,
          (
            AssetItem,
            BaseReferences<_$AppDatabase, $AssetItemsTable, AssetItem>,
          ),
          AssetItem,
          PrefetchHooks Function()
        > {
  $$AssetItemsTableTableManager(_$AppDatabase db, $AssetItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<Uint8List> data = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<MediaType> type = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetItemsCompanion(
                id: id,
                data: data,
                name: name,
                type: type,
                sourceId: sourceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required Uint8List data,
                Value<String?> name = const Value.absent(),
                required MediaType type,
                Value<String?> sourceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetItemsCompanion.insert(
                id: id,
                data: data,
                name: name,
                type: type,
                sourceId: sourceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssetItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetItemsTable,
      AssetItem,
      $$AssetItemsTableFilterComposer,
      $$AssetItemsTableOrderingComposer,
      $$AssetItemsTableAnnotationComposer,
      $$AssetItemsTableCreateCompanionBuilder,
      $$AssetItemsTableUpdateCompanionBuilder,
      (AssetItem, BaseReferences<_$AppDatabase, $AssetItemsTable, AssetItem>),
      AssetItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudyFolderItemsTableTableManager get studyFolderItems =>
      $$StudyFolderItemsTableTableManager(_db, _db.studyFolderItems);
  $$SourceItemsTableTableManager get sourceItems =>
      $$SourceItemsTableTableManager(_db, _db.sourceItems);
  $$DeckItemsTableTableManager get deckItems =>
      $$DeckItemsTableTableManager(_db, _db.deckItems);
  $$SourceItemBlobsTableTableManager get sourceItemBlobs =>
      $$SourceItemBlobsTableTableManager(_db, _db.sourceItemBlobs);
  $$CardCreationDraftItemsTableTableManager get cardCreationDraftItems =>
      $$CardCreationDraftItemsTableTableManager(
        _db,
        _db.cardCreationDraftItems,
      );
  $$CardItemsTableTableManager get cardItems =>
      $$CardItemsTableTableManager(_db, _db.cardItems);
  $$StudySessionEventsTableTableManager get studySessionEvents =>
      $$StudySessionEventsTableTableManager(_db, _db.studySessionEvents);
  $$CitationItemsTableTableManager get citationItems =>
      $$CitationItemsTableTableManager(_db, _db.citationItems);
  $$AssetItemsTableTableManager get assetItems =>
      $$AssetItemsTableTableManager(_db, _db.assetItems);
}
