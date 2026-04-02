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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
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
}

class SourceItem extends DataClass implements Insertable<SourceItem> {
  final String id;
  final String? folderId;
  final String label;
  final String? path;
  final String type;
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
    map['type'] = Variable<String>(type);
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
      type: serializer.fromJson<String>(json['type']),
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
      'type': serializer.toJson<String>(type),
      'extractedContent': serializer.toJson<String?>(extractedContent),
      'isPinned': serializer.toJson<bool>(isPinned),
    };
  }

  SourceItem copyWith({
    String? id,
    Value<String?> folderId = const Value.absent(),
    String? label,
    Value<String?> path = const Value.absent(),
    String? type,
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
  final Value<String> type;
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
    required String type,
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
    Value<String>? type,
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
      map['type'] = Variable<String>(type.value);
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
  StudyMaterialItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyMaterialItem(
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
  $StudyMaterialItemsTable createAlias(String alias) {
    return $StudyMaterialItemsTable(attachedDatabase, alias);
  }
}

class StudyMaterialItem extends DataClass
    implements Insertable<StudyMaterialItem> {
  final String id;
  final String folderId;
  final String name;
  final String? description;
  final bool isPinned;
  const StudyMaterialItem({
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

  StudyMaterialItemsCompanion toCompanion(bool nullToAbsent) {
    return StudyMaterialItemsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isPinned: Value(isPinned),
    );
  }

  factory StudyMaterialItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyMaterialItem(
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

  StudyMaterialItem copyWith({
    String? id,
    String? folderId,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? isPinned,
  }) => StudyMaterialItem(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isPinned: isPinned ?? this.isPinned,
  );
  StudyMaterialItem copyWithCompanion(StudyMaterialItemsCompanion data) {
    return StudyMaterialItem(
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
    return (StringBuffer('StudyMaterialItem(')
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
      (other is StudyMaterialItem &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.name == this.name &&
          other.description == this.description &&
          other.isPinned == this.isPinned);
}

class StudyMaterialItemsCompanion extends UpdateCompanion<StudyMaterialItem> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> isPinned;
  final Value<int> rowid;
  const StudyMaterialItemsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyMaterialItemsCompanion.insert({
    required String id,
    required String folderId,
    required String name,
    this.description = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       name = Value(name);
  static Insertable<StudyMaterialItem> custom({
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

  StudyMaterialItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? isPinned,
    Value<int>? rowid,
  }) {
    return StudyMaterialItemsCompanion(
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
    return (StringBuffer('StudyMaterialItemsCompanion(')
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
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
}

class SourceItemBlob extends DataClass implements Insertable<SourceItemBlob> {
  final String id;
  final String sourceItemId;
  final String sourceItemName;
  final String type;
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
    map['type'] = Variable<String>(type);
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
      type: serializer.fromJson<String>(json['type']),
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
      'type': serializer.toJson<String>(type),
      'bytes': serializer.toJson<Uint8List>(bytes),
    };
  }

  SourceItemBlob copyWith({
    String? id,
    String? sourceItemId,
    String? sourceItemName,
    String? type,
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
  final Value<String> type;
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
    required String type,
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
    Value<String>? type,
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
      map['type'] = Variable<String>(type.value);
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

class $StudyCardItemsTable extends StudyCardItems
    with TableInfo<$StudyCardItemsTable, StudyCardItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyCardItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _materialIdMeta = const VerificationMeta(
    'materialId',
  );
  @override
  late final GeneratedColumn<String> materialId = GeneratedColumn<String>(
    'material_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_material_items (id)',
    ),
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
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
  citationIds = GeneratedColumn<String>(
    'citation_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<String>?>($StudyCardItemsTable.$convertercitationIdsn);
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
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<String> due = GeneratedColumn<String>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fsrsCardJsonMeta = const VerificationMeta(
    'fsrsCardJson',
  );
  @override
  late final GeneratedColumn<String> fsrsCardJson = GeneratedColumn<String>(
    'fsrs_card_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    materialId,
    type,
    citationIds,
    question,
    optionsListJson,
    answer,
    due,
    fsrsCardJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_card_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyCardItem> instance, {
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
    if (data.containsKey('material_id')) {
      context.handle(
        _materialIdMeta,
        materialId.isAcceptableOrUnknown(data['material_id']!, _materialIdMeta),
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
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    if (data.containsKey('fsrs_card_json')) {
      context.handle(
        _fsrsCardJsonMeta,
        fsrsCardJson.isAcceptableOrUnknown(
          data['fsrs_card_json']!,
          _fsrsCardJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyCardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyCardItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      materialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      citationIds: $StudyCardItemsTable.$convertercitationIdsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}citation_ids'],
        ),
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
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due'],
      ),
      fsrsCardJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fsrs_card_json'],
      ),
    );
  }

  @override
  $StudyCardItemsTable createAlias(String alias) {
    return $StudyCardItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertercitationIds =
      const StringListConverter();
  static TypeConverter<List<String>?, String?> $convertercitationIdsn =
      NullAwareTypeConverter.wrap($convertercitationIds);
}

class StudyCardItem extends DataClass implements Insertable<StudyCardItem> {
  final String id;
  final String folderId;
  final String? materialId;
  final String type;
  final List<String>? citationIds;

  /// Fields are nullable because not all types use the same properties.
  /// - Flashcard: question (front), answer (back)
  /// - MCQ: question, optionsListJson, answer
  /// - Free-Text: question, answer
  /// - Image Occlusion: (not yet implemented)
  final String? question;
  final String? optionsListJson;
  final String? answer;
  final String? due;
  final String? fsrsCardJson;
  const StudyCardItem({
    required this.id,
    required this.folderId,
    this.materialId,
    required this.type,
    this.citationIds,
    this.question,
    this.optionsListJson,
    this.answer,
    this.due,
    this.fsrsCardJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder_id'] = Variable<String>(folderId);
    if (!nullToAbsent || materialId != null) {
      map['material_id'] = Variable<String>(materialId);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || citationIds != null) {
      map['citation_ids'] = Variable<String>(
        $StudyCardItemsTable.$convertercitationIdsn.toSql(citationIds),
      );
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
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<String>(due);
    }
    if (!nullToAbsent || fsrsCardJson != null) {
      map['fsrs_card_json'] = Variable<String>(fsrsCardJson);
    }
    return map;
  }

  StudyCardItemsCompanion toCompanion(bool nullToAbsent) {
    return StudyCardItemsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      materialId: materialId == null && nullToAbsent
          ? const Value.absent()
          : Value(materialId),
      type: Value(type),
      citationIds: citationIds == null && nullToAbsent
          ? const Value.absent()
          : Value(citationIds),
      question: question == null && nullToAbsent
          ? const Value.absent()
          : Value(question),
      optionsListJson: optionsListJson == null && nullToAbsent
          ? const Value.absent()
          : Value(optionsListJson),
      answer: answer == null && nullToAbsent
          ? const Value.absent()
          : Value(answer),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      fsrsCardJson: fsrsCardJson == null && nullToAbsent
          ? const Value.absent()
          : Value(fsrsCardJson),
    );
  }

  factory StudyCardItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyCardItem(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String>(json['folderId']),
      materialId: serializer.fromJson<String?>(json['materialId']),
      type: serializer.fromJson<String>(json['type']),
      citationIds: serializer.fromJson<List<String>?>(json['citationIds']),
      question: serializer.fromJson<String?>(json['question']),
      optionsListJson: serializer.fromJson<String?>(json['optionsListJson']),
      answer: serializer.fromJson<String?>(json['answer']),
      due: serializer.fromJson<String?>(json['due']),
      fsrsCardJson: serializer.fromJson<String?>(json['fsrsCardJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String>(folderId),
      'materialId': serializer.toJson<String?>(materialId),
      'type': serializer.toJson<String>(type),
      'citationIds': serializer.toJson<List<String>?>(citationIds),
      'question': serializer.toJson<String?>(question),
      'optionsListJson': serializer.toJson<String?>(optionsListJson),
      'answer': serializer.toJson<String?>(answer),
      'due': serializer.toJson<String?>(due),
      'fsrsCardJson': serializer.toJson<String?>(fsrsCardJson),
    };
  }

  StudyCardItem copyWith({
    String? id,
    String? folderId,
    Value<String?> materialId = const Value.absent(),
    String? type,
    Value<List<String>?> citationIds = const Value.absent(),
    Value<String?> question = const Value.absent(),
    Value<String?> optionsListJson = const Value.absent(),
    Value<String?> answer = const Value.absent(),
    Value<String?> due = const Value.absent(),
    Value<String?> fsrsCardJson = const Value.absent(),
  }) => StudyCardItem(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    materialId: materialId.present ? materialId.value : this.materialId,
    type: type ?? this.type,
    citationIds: citationIds.present ? citationIds.value : this.citationIds,
    question: question.present ? question.value : this.question,
    optionsListJson: optionsListJson.present
        ? optionsListJson.value
        : this.optionsListJson,
    answer: answer.present ? answer.value : this.answer,
    due: due.present ? due.value : this.due,
    fsrsCardJson: fsrsCardJson.present ? fsrsCardJson.value : this.fsrsCardJson,
  );
  StudyCardItem copyWithCompanion(StudyCardItemsCompanion data) {
    return StudyCardItem(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      materialId: data.materialId.present
          ? data.materialId.value
          : this.materialId,
      type: data.type.present ? data.type.value : this.type,
      citationIds: data.citationIds.present
          ? data.citationIds.value
          : this.citationIds,
      question: data.question.present ? data.question.value : this.question,
      optionsListJson: data.optionsListJson.present
          ? data.optionsListJson.value
          : this.optionsListJson,
      answer: data.answer.present ? data.answer.value : this.answer,
      due: data.due.present ? data.due.value : this.due,
      fsrsCardJson: data.fsrsCardJson.present
          ? data.fsrsCardJson.value
          : this.fsrsCardJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyCardItem(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('materialId: $materialId, ')
          ..write('type: $type, ')
          ..write('citationIds: $citationIds, ')
          ..write('question: $question, ')
          ..write('optionsListJson: $optionsListJson, ')
          ..write('answer: $answer, ')
          ..write('due: $due, ')
          ..write('fsrsCardJson: $fsrsCardJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    folderId,
    materialId,
    type,
    citationIds,
    question,
    optionsListJson,
    answer,
    due,
    fsrsCardJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyCardItem &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.materialId == this.materialId &&
          other.type == this.type &&
          other.citationIds == this.citationIds &&
          other.question == this.question &&
          other.optionsListJson == this.optionsListJson &&
          other.answer == this.answer &&
          other.due == this.due &&
          other.fsrsCardJson == this.fsrsCardJson);
}

class StudyCardItemsCompanion extends UpdateCompanion<StudyCardItem> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String?> materialId;
  final Value<String> type;
  final Value<List<String>?> citationIds;
  final Value<String?> question;
  final Value<String?> optionsListJson;
  final Value<String?> answer;
  final Value<String?> due;
  final Value<String?> fsrsCardJson;
  final Value<int> rowid;
  const StudyCardItemsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.materialId = const Value.absent(),
    this.type = const Value.absent(),
    this.citationIds = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.due = const Value.absent(),
    this.fsrsCardJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyCardItemsCompanion.insert({
    required String id,
    required String folderId,
    this.materialId = const Value.absent(),
    required String type,
    this.citationIds = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.due = const Value.absent(),
    this.fsrsCardJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       type = Value(type);
  static Insertable<StudyCardItem> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? materialId,
    Expression<String>? type,
    Expression<String>? citationIds,
    Expression<String>? question,
    Expression<String>? optionsListJson,
    Expression<String>? answer,
    Expression<String>? due,
    Expression<String>? fsrsCardJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (materialId != null) 'material_id': materialId,
      if (type != null) 'type': type,
      if (citationIds != null) 'citation_ids': citationIds,
      if (question != null) 'question': question,
      if (optionsListJson != null) 'options_list_json': optionsListJson,
      if (answer != null) 'answer': answer,
      if (due != null) 'due': due,
      if (fsrsCardJson != null) 'fsrs_card_json': fsrsCardJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyCardItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String?>? materialId,
    Value<String>? type,
    Value<List<String>?>? citationIds,
    Value<String?>? question,
    Value<String?>? optionsListJson,
    Value<String?>? answer,
    Value<String?>? due,
    Value<String?>? fsrsCardJson,
    Value<int>? rowid,
  }) {
    return StudyCardItemsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      materialId: materialId ?? this.materialId,
      type: type ?? this.type,
      citationIds: citationIds ?? this.citationIds,
      question: question ?? this.question,
      optionsListJson: optionsListJson ?? this.optionsListJson,
      answer: answer ?? this.answer,
      due: due ?? this.due,
      fsrsCardJson: fsrsCardJson ?? this.fsrsCardJson,
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
    if (materialId.present) {
      map['material_id'] = Variable<String>(materialId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (citationIds.present) {
      map['citation_ids'] = Variable<String>(
        $StudyCardItemsTable.$convertercitationIdsn.toSql(citationIds.value),
      );
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
    if (due.present) {
      map['due'] = Variable<String>(due.value);
    }
    if (fsrsCardJson.present) {
      map['fsrs_card_json'] = Variable<String>(fsrsCardJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyCardItemsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('materialId: $materialId, ')
          ..write('type: $type, ')
          ..write('citationIds: $citationIds, ')
          ..write('question: $question, ')
          ..write('optionsListJson: $optionsListJson, ')
          ..write('answer: $answer, ')
          ..write('due: $due, ')
          ..write('fsrsCardJson: $fsrsCardJson, ')
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
  static const VerificationMeta _materialIdMeta = const VerificationMeta(
    'materialId',
  );
  @override
  late final GeneratedColumn<String> materialId = GeneratedColumn<String>(
    'material_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    materialId,
    rating,
    reviewedAt,
    scheduledDays,
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
    if (data.containsKey('material_id')) {
      context.handle(
        _materialIdMeta,
        materialId.isAcceptableOrUnknown(data['material_id']!, _materialIdMeta),
      );
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
      materialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_id'],
      ),
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
    );
  }

  @override
  $StudySessionEventsTable createAlias(String alias) {
    return $StudySessionEventsTable(attachedDatabase, alias);
  }
}

class StudySessionEvent extends DataClass
    implements Insertable<StudySessionEvent> {
  final String id;
  final String cardId;
  final String? materialId;
  final int rating;
  final String reviewedAt;
  final int scheduledDays;
  const StudySessionEvent({
    required this.id,
    required this.cardId,
    this.materialId,
    required this.rating,
    required this.reviewedAt,
    required this.scheduledDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    if (!nullToAbsent || materialId != null) {
      map['material_id'] = Variable<String>(materialId);
    }
    map['rating'] = Variable<int>(rating);
    map['reviewed_at'] = Variable<String>(reviewedAt);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    return map;
  }

  StudySessionEventsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionEventsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      materialId: materialId == null && nullToAbsent
          ? const Value.absent()
          : Value(materialId),
      rating: Value(rating),
      reviewedAt: Value(reviewedAt),
      scheduledDays: Value(scheduledDays),
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
      materialId: serializer.fromJson<String?>(json['materialId']),
      rating: serializer.fromJson<int>(json['rating']),
      reviewedAt: serializer.fromJson<String>(json['reviewedAt']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'materialId': serializer.toJson<String?>(materialId),
      'rating': serializer.toJson<int>(rating),
      'reviewedAt': serializer.toJson<String>(reviewedAt),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
    };
  }

  StudySessionEvent copyWith({
    String? id,
    String? cardId,
    Value<String?> materialId = const Value.absent(),
    int? rating,
    String? reviewedAt,
    int? scheduledDays,
  }) => StudySessionEvent(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    materialId: materialId.present ? materialId.value : this.materialId,
    rating: rating ?? this.rating,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    scheduledDays: scheduledDays ?? this.scheduledDays,
  );
  StudySessionEvent copyWithCompanion(StudySessionEventsCompanion data) {
    return StudySessionEvent(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      materialId: data.materialId.present
          ? data.materialId.value
          : this.materialId,
      rating: data.rating.present ? data.rating.value : this.rating,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionEvent(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('materialId: $materialId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('scheduledDays: $scheduledDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, materialId, rating, reviewedAt, scheduledDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionEvent &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.materialId == this.materialId &&
          other.rating == this.rating &&
          other.reviewedAt == this.reviewedAt &&
          other.scheduledDays == this.scheduledDays);
}

class StudySessionEventsCompanion extends UpdateCompanion<StudySessionEvent> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String?> materialId;
  final Value<int> rating;
  final Value<String> reviewedAt;
  final Value<int> scheduledDays;
  final Value<int> rowid;
  const StudySessionEventsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.materialId = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionEventsCompanion.insert({
    required String id,
    required String cardId,
    this.materialId = const Value.absent(),
    required int rating,
    required String reviewedAt,
    required int scheduledDays,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       rating = Value(rating),
       reviewedAt = Value(reviewedAt),
       scheduledDays = Value(scheduledDays);
  static Insertable<StudySessionEvent> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? materialId,
    Expression<int>? rating,
    Expression<String>? reviewedAt,
    Expression<int>? scheduledDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (materialId != null) 'material_id': materialId,
      if (rating != null) 'rating': rating,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudySessionEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String?>? materialId,
    Value<int>? rating,
    Value<String>? reviewedAt,
    Value<int>? scheduledDays,
    Value<int>? rowid,
  }) {
    return StudySessionEventsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      materialId: materialId ?? this.materialId,
      rating: rating ?? this.rating,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      scheduledDays: scheduledDays ?? this.scheduledDays,
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
    if (materialId.present) {
      map['material_id'] = Variable<String>(materialId.value);
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
          ..write('materialId: $materialId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardCreationDraftsTable extends CardCreationDrafts
    with TableInfo<$CardCreationDraftsTable, CardCreationDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardCreationDraftsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _lastSourceIdMeta = const VerificationMeta(
    'lastSourceId',
  );
  @override
  late final GeneratedColumn<String> lastSourceId = GeneratedColumn<String>(
    'last_source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_items (id)',
    ),
  );
  static const VerificationMeta _scrollXMeta = const VerificationMeta(
    'scrollX',
  );
  @override
  late final GeneratedColumn<double> scrollX = GeneratedColumn<double>(
    'scroll_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scrollYMeta = const VerificationMeta(
    'scrollY',
  );
  @override
  late final GeneratedColumn<double> scrollY = GeneratedColumn<double>(
    'scroll_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zoomMeta = const VerificationMeta('zoom');
  @override
  late final GeneratedColumn<double> zoom = GeneratedColumn<double>(
    'zoom',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
  static const VerificationMeta _toolbarModeMeta = const VerificationMeta(
    'toolbarMode',
  );
  @override
  late final GeneratedColumn<String> toolbarMode = GeneratedColumn<String>(
    'toolbar_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedTextMeta = const VerificationMeta(
    'selectedText',
  );
  @override
  late final GeneratedColumn<String> selectedText = GeneratedColumn<String>(
    'selected_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedImageBlobIdMeta =
      const VerificationMeta('capturedImageBlobId');
  @override
  late final GeneratedColumn<String> capturedImageBlobId =
      GeneratedColumn<String>(
        'captured_image_blob_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    folderId,
    lastSourceId,
    scrollX,
    scrollY,
    zoom,
    frontText,
    backText,
    toolbarMode,
    selectedText,
    capturedImageBlobId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_creation_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardCreationDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('last_source_id')) {
      context.handle(
        _lastSourceIdMeta,
        lastSourceId.isAcceptableOrUnknown(
          data['last_source_id']!,
          _lastSourceIdMeta,
        ),
      );
    }
    if (data.containsKey('scroll_x')) {
      context.handle(
        _scrollXMeta,
        scrollX.isAcceptableOrUnknown(data['scroll_x']!, _scrollXMeta),
      );
    }
    if (data.containsKey('scroll_y')) {
      context.handle(
        _scrollYMeta,
        scrollY.isAcceptableOrUnknown(data['scroll_y']!, _scrollYMeta),
      );
    }
    if (data.containsKey('zoom')) {
      context.handle(
        _zoomMeta,
        zoom.isAcceptableOrUnknown(data['zoom']!, _zoomMeta),
      );
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
    if (data.containsKey('toolbar_mode')) {
      context.handle(
        _toolbarModeMeta,
        toolbarMode.isAcceptableOrUnknown(
          data['toolbar_mode']!,
          _toolbarModeMeta,
        ),
      );
    }
    if (data.containsKey('selected_text')) {
      context.handle(
        _selectedTextMeta,
        selectedText.isAcceptableOrUnknown(
          data['selected_text']!,
          _selectedTextMeta,
        ),
      );
    }
    if (data.containsKey('captured_image_blob_id')) {
      context.handle(
        _capturedImageBlobIdMeta,
        capturedImageBlobId.isAcceptableOrUnknown(
          data['captured_image_blob_id']!,
          _capturedImageBlobIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {folderId};
  @override
  CardCreationDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardCreationDraft(
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      lastSourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_source_id'],
      ),
      scrollX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_x'],
      ),
      scrollY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_y'],
      ),
      zoom: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}zoom'],
      ),
      frontText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front_text'],
      ),
      backText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back_text'],
      ),
      toolbarMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toolbar_mode'],
      ),
      selectedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_text'],
      ),
      capturedImageBlobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}captured_image_blob_id'],
      ),
    );
  }

  @override
  $CardCreationDraftsTable createAlias(String alias) {
    return $CardCreationDraftsTable(attachedDatabase, alias);
  }
}

class CardCreationDraft extends DataClass
    implements Insertable<CardCreationDraft> {
  final String folderId;
  final String? lastSourceId;
  final double? scrollX;
  final double? scrollY;
  final double? zoom;
  final String? frontText;
  final String? backText;
  final String? toolbarMode;
  final String? selectedText;
  final String? capturedImageBlobId;
  const CardCreationDraft({
    required this.folderId,
    this.lastSourceId,
    this.scrollX,
    this.scrollY,
    this.zoom,
    this.frontText,
    this.backText,
    this.toolbarMode,
    this.selectedText,
    this.capturedImageBlobId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['folder_id'] = Variable<String>(folderId);
    if (!nullToAbsent || lastSourceId != null) {
      map['last_source_id'] = Variable<String>(lastSourceId);
    }
    if (!nullToAbsent || scrollX != null) {
      map['scroll_x'] = Variable<double>(scrollX);
    }
    if (!nullToAbsent || scrollY != null) {
      map['scroll_y'] = Variable<double>(scrollY);
    }
    if (!nullToAbsent || zoom != null) {
      map['zoom'] = Variable<double>(zoom);
    }
    if (!nullToAbsent || frontText != null) {
      map['front_text'] = Variable<String>(frontText);
    }
    if (!nullToAbsent || backText != null) {
      map['back_text'] = Variable<String>(backText);
    }
    if (!nullToAbsent || toolbarMode != null) {
      map['toolbar_mode'] = Variable<String>(toolbarMode);
    }
    if (!nullToAbsent || selectedText != null) {
      map['selected_text'] = Variable<String>(selectedText);
    }
    if (!nullToAbsent || capturedImageBlobId != null) {
      map['captured_image_blob_id'] = Variable<String>(capturedImageBlobId);
    }
    return map;
  }

  CardCreationDraftsCompanion toCompanion(bool nullToAbsent) {
    return CardCreationDraftsCompanion(
      folderId: Value(folderId),
      lastSourceId: lastSourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSourceId),
      scrollX: scrollX == null && nullToAbsent
          ? const Value.absent()
          : Value(scrollX),
      scrollY: scrollY == null && nullToAbsent
          ? const Value.absent()
          : Value(scrollY),
      zoom: zoom == null && nullToAbsent ? const Value.absent() : Value(zoom),
      frontText: frontText == null && nullToAbsent
          ? const Value.absent()
          : Value(frontText),
      backText: backText == null && nullToAbsent
          ? const Value.absent()
          : Value(backText),
      toolbarMode: toolbarMode == null && nullToAbsent
          ? const Value.absent()
          : Value(toolbarMode),
      selectedText: selectedText == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedText),
      capturedImageBlobId: capturedImageBlobId == null && nullToAbsent
          ? const Value.absent()
          : Value(capturedImageBlobId),
    );
  }

  factory CardCreationDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardCreationDraft(
      folderId: serializer.fromJson<String>(json['folderId']),
      lastSourceId: serializer.fromJson<String?>(json['lastSourceId']),
      scrollX: serializer.fromJson<double?>(json['scrollX']),
      scrollY: serializer.fromJson<double?>(json['scrollY']),
      zoom: serializer.fromJson<double?>(json['zoom']),
      frontText: serializer.fromJson<String?>(json['frontText']),
      backText: serializer.fromJson<String?>(json['backText']),
      toolbarMode: serializer.fromJson<String?>(json['toolbarMode']),
      selectedText: serializer.fromJson<String?>(json['selectedText']),
      capturedImageBlobId: serializer.fromJson<String?>(
        json['capturedImageBlobId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'folderId': serializer.toJson<String>(folderId),
      'lastSourceId': serializer.toJson<String?>(lastSourceId),
      'scrollX': serializer.toJson<double?>(scrollX),
      'scrollY': serializer.toJson<double?>(scrollY),
      'zoom': serializer.toJson<double?>(zoom),
      'frontText': serializer.toJson<String?>(frontText),
      'backText': serializer.toJson<String?>(backText),
      'toolbarMode': serializer.toJson<String?>(toolbarMode),
      'selectedText': serializer.toJson<String?>(selectedText),
      'capturedImageBlobId': serializer.toJson<String?>(capturedImageBlobId),
    };
  }

  CardCreationDraft copyWith({
    String? folderId,
    Value<String?> lastSourceId = const Value.absent(),
    Value<double?> scrollX = const Value.absent(),
    Value<double?> scrollY = const Value.absent(),
    Value<double?> zoom = const Value.absent(),
    Value<String?> frontText = const Value.absent(),
    Value<String?> backText = const Value.absent(),
    Value<String?> toolbarMode = const Value.absent(),
    Value<String?> selectedText = const Value.absent(),
    Value<String?> capturedImageBlobId = const Value.absent(),
  }) => CardCreationDraft(
    folderId: folderId ?? this.folderId,
    lastSourceId: lastSourceId.present ? lastSourceId.value : this.lastSourceId,
    scrollX: scrollX.present ? scrollX.value : this.scrollX,
    scrollY: scrollY.present ? scrollY.value : this.scrollY,
    zoom: zoom.present ? zoom.value : this.zoom,
    frontText: frontText.present ? frontText.value : this.frontText,
    backText: backText.present ? backText.value : this.backText,
    toolbarMode: toolbarMode.present ? toolbarMode.value : this.toolbarMode,
    selectedText: selectedText.present ? selectedText.value : this.selectedText,
    capturedImageBlobId: capturedImageBlobId.present
        ? capturedImageBlobId.value
        : this.capturedImageBlobId,
  );
  CardCreationDraft copyWithCompanion(CardCreationDraftsCompanion data) {
    return CardCreationDraft(
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      lastSourceId: data.lastSourceId.present
          ? data.lastSourceId.value
          : this.lastSourceId,
      scrollX: data.scrollX.present ? data.scrollX.value : this.scrollX,
      scrollY: data.scrollY.present ? data.scrollY.value : this.scrollY,
      zoom: data.zoom.present ? data.zoom.value : this.zoom,
      frontText: data.frontText.present ? data.frontText.value : this.frontText,
      backText: data.backText.present ? data.backText.value : this.backText,
      toolbarMode: data.toolbarMode.present
          ? data.toolbarMode.value
          : this.toolbarMode,
      selectedText: data.selectedText.present
          ? data.selectedText.value
          : this.selectedText,
      capturedImageBlobId: data.capturedImageBlobId.present
          ? data.capturedImageBlobId.value
          : this.capturedImageBlobId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardCreationDraft(')
          ..write('folderId: $folderId, ')
          ..write('lastSourceId: $lastSourceId, ')
          ..write('scrollX: $scrollX, ')
          ..write('scrollY: $scrollY, ')
          ..write('zoom: $zoom, ')
          ..write('frontText: $frontText, ')
          ..write('backText: $backText, ')
          ..write('toolbarMode: $toolbarMode, ')
          ..write('selectedText: $selectedText, ')
          ..write('capturedImageBlobId: $capturedImageBlobId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    folderId,
    lastSourceId,
    scrollX,
    scrollY,
    zoom,
    frontText,
    backText,
    toolbarMode,
    selectedText,
    capturedImageBlobId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardCreationDraft &&
          other.folderId == this.folderId &&
          other.lastSourceId == this.lastSourceId &&
          other.scrollX == this.scrollX &&
          other.scrollY == this.scrollY &&
          other.zoom == this.zoom &&
          other.frontText == this.frontText &&
          other.backText == this.backText &&
          other.toolbarMode == this.toolbarMode &&
          other.selectedText == this.selectedText &&
          other.capturedImageBlobId == this.capturedImageBlobId);
}

class CardCreationDraftsCompanion extends UpdateCompanion<CardCreationDraft> {
  final Value<String> folderId;
  final Value<String?> lastSourceId;
  final Value<double?> scrollX;
  final Value<double?> scrollY;
  final Value<double?> zoom;
  final Value<String?> frontText;
  final Value<String?> backText;
  final Value<String?> toolbarMode;
  final Value<String?> selectedText;
  final Value<String?> capturedImageBlobId;
  final Value<int> rowid;
  const CardCreationDraftsCompanion({
    this.folderId = const Value.absent(),
    this.lastSourceId = const Value.absent(),
    this.scrollX = const Value.absent(),
    this.scrollY = const Value.absent(),
    this.zoom = const Value.absent(),
    this.frontText = const Value.absent(),
    this.backText = const Value.absent(),
    this.toolbarMode = const Value.absent(),
    this.selectedText = const Value.absent(),
    this.capturedImageBlobId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardCreationDraftsCompanion.insert({
    required String folderId,
    this.lastSourceId = const Value.absent(),
    this.scrollX = const Value.absent(),
    this.scrollY = const Value.absent(),
    this.zoom = const Value.absent(),
    this.frontText = const Value.absent(),
    this.backText = const Value.absent(),
    this.toolbarMode = const Value.absent(),
    this.selectedText = const Value.absent(),
    this.capturedImageBlobId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : folderId = Value(folderId);
  static Insertable<CardCreationDraft> custom({
    Expression<String>? folderId,
    Expression<String>? lastSourceId,
    Expression<double>? scrollX,
    Expression<double>? scrollY,
    Expression<double>? zoom,
    Expression<String>? frontText,
    Expression<String>? backText,
    Expression<String>? toolbarMode,
    Expression<String>? selectedText,
    Expression<String>? capturedImageBlobId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (folderId != null) 'folder_id': folderId,
      if (lastSourceId != null) 'last_source_id': lastSourceId,
      if (scrollX != null) 'scroll_x': scrollX,
      if (scrollY != null) 'scroll_y': scrollY,
      if (zoom != null) 'zoom': zoom,
      if (frontText != null) 'front_text': frontText,
      if (backText != null) 'back_text': backText,
      if (toolbarMode != null) 'toolbar_mode': toolbarMode,
      if (selectedText != null) 'selected_text': selectedText,
      if (capturedImageBlobId != null)
        'captured_image_blob_id': capturedImageBlobId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardCreationDraftsCompanion copyWith({
    Value<String>? folderId,
    Value<String?>? lastSourceId,
    Value<double?>? scrollX,
    Value<double?>? scrollY,
    Value<double?>? zoom,
    Value<String?>? frontText,
    Value<String?>? backText,
    Value<String?>? toolbarMode,
    Value<String?>? selectedText,
    Value<String?>? capturedImageBlobId,
    Value<int>? rowid,
  }) {
    return CardCreationDraftsCompanion(
      folderId: folderId ?? this.folderId,
      lastSourceId: lastSourceId ?? this.lastSourceId,
      scrollX: scrollX ?? this.scrollX,
      scrollY: scrollY ?? this.scrollY,
      zoom: zoom ?? this.zoom,
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      toolbarMode: toolbarMode ?? this.toolbarMode,
      selectedText: selectedText ?? this.selectedText,
      capturedImageBlobId: capturedImageBlobId ?? this.capturedImageBlobId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (lastSourceId.present) {
      map['last_source_id'] = Variable<String>(lastSourceId.value);
    }
    if (scrollX.present) {
      map['scroll_x'] = Variable<double>(scrollX.value);
    }
    if (scrollY.present) {
      map['scroll_y'] = Variable<double>(scrollY.value);
    }
    if (zoom.present) {
      map['zoom'] = Variable<double>(zoom.value);
    }
    if (frontText.present) {
      map['front_text'] = Variable<String>(frontText.value);
    }
    if (backText.present) {
      map['back_text'] = Variable<String>(backText.value);
    }
    if (toolbarMode.present) {
      map['toolbar_mode'] = Variable<String>(toolbarMode.value);
    }
    if (selectedText.present) {
      map['selected_text'] = Variable<String>(selectedText.value);
    }
    if (capturedImageBlobId.present) {
      map['captured_image_blob_id'] = Variable<String>(
        capturedImageBlobId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardCreationDraftsCompanion(')
          ..write('folderId: $folderId, ')
          ..write('lastSourceId: $lastSourceId, ')
          ..write('scrollX: $scrollX, ')
          ..write('scrollY: $scrollY, ')
          ..write('zoom: $zoom, ')
          ..write('frontText: $frontText, ')
          ..write('backText: $backText, ')
          ..write('toolbarMode: $toolbarMode, ')
          ..write('selectedText: $selectedText, ')
          ..write('capturedImageBlobId: $capturedImageBlobId, ')
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
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_items (id)',
    ),
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
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Citation, String> citation =
      GeneratedColumn<String>(
        'citation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Citation>($CitationItemsTable.$convertercitation);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    type,
    pageNumber,
    citation,
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
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
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
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      ),
      citation: $CitationItemsTable.$convertercitation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}citation'],
        )!,
      ),
    );
  }

  @override
  $CitationItemsTable createAlias(String alias) {
    return $CitationItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<Citation, String> $convertercitation =
      const CitationConverter();
}

class CitationItem extends DataClass implements Insertable<CitationItem> {
  final String id;
  final String sourceId;
  final String type;
  final int? pageNumber;
  final Citation citation;
  const CitationItem({
    required this.id,
    required this.sourceId,
    required this.type,
    this.pageNumber,
    required this.citation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || pageNumber != null) {
      map['page_number'] = Variable<int>(pageNumber);
    }
    {
      map['citation'] = Variable<String>(
        $CitationItemsTable.$convertercitation.toSql(citation),
      );
    }
    return map;
  }

  CitationItemsCompanion toCompanion(bool nullToAbsent) {
    return CitationItemsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      type: Value(type),
      pageNumber: pageNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumber),
      citation: Value(citation),
    );
  }

  factory CitationItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitationItem(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      type: serializer.fromJson<String>(json['type']),
      pageNumber: serializer.fromJson<int?>(json['pageNumber']),
      citation: serializer.fromJson<Citation>(json['citation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'type': serializer.toJson<String>(type),
      'pageNumber': serializer.toJson<int?>(pageNumber),
      'citation': serializer.toJson<Citation>(citation),
    };
  }

  CitationItem copyWith({
    String? id,
    String? sourceId,
    String? type,
    Value<int?> pageNumber = const Value.absent(),
    Citation? citation,
  }) => CitationItem(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    type: type ?? this.type,
    pageNumber: pageNumber.present ? pageNumber.value : this.pageNumber,
    citation: citation ?? this.citation,
  );
  CitationItem copyWithCompanion(CitationItemsCompanion data) {
    return CitationItem(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      type: data.type.present ? data.type.value : this.type,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      citation: data.citation.present ? data.citation.value : this.citation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitationItem(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('type: $type, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('citation: $citation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceId, type, pageNumber, citation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitationItem &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.type == this.type &&
          other.pageNumber == this.pageNumber &&
          other.citation == this.citation);
}

class CitationItemsCompanion extends UpdateCompanion<CitationItem> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> type;
  final Value<int?> pageNumber;
  final Value<Citation> citation;
  final Value<int> rowid;
  const CitationItemsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.type = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.citation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitationItemsCompanion.insert({
    required String id,
    required String sourceId,
    required String type,
    this.pageNumber = const Value.absent(),
    required Citation citation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       type = Value(type),
       citation = Value(citation);
  static Insertable<CitationItem> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? type,
    Expression<int>? pageNumber,
    Expression<String>? citation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (type != null) 'type': type,
      if (pageNumber != null) 'page_number': pageNumber,
      if (citation != null) 'citation': citation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitationItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? type,
    Value<int?>? pageNumber,
    Value<Citation>? citation,
    Value<int>? rowid,
  }) {
    return CitationItemsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      type: type ?? this.type,
      pageNumber: pageNumber ?? this.pageNumber,
      citation: citation ?? this.citation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (citation.present) {
      map['citation'] = Variable<String>(
        $CitationItemsTable.$convertercitation.toSql(citation.value),
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
          ..write('sourceId: $sourceId, ')
          ..write('type: $type, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('citation: $citation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitationBlobsTable extends CitationBlobs
    with TableInfo<$CitationBlobsTable, CitationBlob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitationBlobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _citationIdMeta = const VerificationMeta(
    'citationId',
  );
  @override
  late final GeneratedColumn<String> citationId = GeneratedColumn<String>(
    'citation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES citation_items (id)',
    ),
  );
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
  List<GeneratedColumn> get $columns => [id, citationId, bytes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citation_blobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitationBlob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('citation_id')) {
      context.handle(
        _citationIdMeta,
        citationId.isAcceptableOrUnknown(data['citation_id']!, _citationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_citationIdMeta);
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
  CitationBlob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitationBlob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      citationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}citation_id'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      )!,
    );
  }

  @override
  $CitationBlobsTable createAlias(String alias) {
    return $CitationBlobsTable(attachedDatabase, alias);
  }
}

class CitationBlob extends DataClass implements Insertable<CitationBlob> {
  final String id;
  final String citationId;
  final Uint8List bytes;
  const CitationBlob({
    required this.id,
    required this.citationId,
    required this.bytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['citation_id'] = Variable<String>(citationId);
    map['bytes'] = Variable<Uint8List>(bytes);
    return map;
  }

  CitationBlobsCompanion toCompanion(bool nullToAbsent) {
    return CitationBlobsCompanion(
      id: Value(id),
      citationId: Value(citationId),
      bytes: Value(bytes),
    );
  }

  factory CitationBlob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitationBlob(
      id: serializer.fromJson<String>(json['id']),
      citationId: serializer.fromJson<String>(json['citationId']),
      bytes: serializer.fromJson<Uint8List>(json['bytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'citationId': serializer.toJson<String>(citationId),
      'bytes': serializer.toJson<Uint8List>(bytes),
    };
  }

  CitationBlob copyWith({String? id, String? citationId, Uint8List? bytes}) =>
      CitationBlob(
        id: id ?? this.id,
        citationId: citationId ?? this.citationId,
        bytes: bytes ?? this.bytes,
      );
  CitationBlob copyWithCompanion(CitationBlobsCompanion data) {
    return CitationBlob(
      id: data.id.present ? data.id.value : this.id,
      citationId: data.citationId.present
          ? data.citationId.value
          : this.citationId,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitationBlob(')
          ..write('id: $id, ')
          ..write('citationId: $citationId, ')
          ..write('bytes: $bytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, citationId, $driftBlobEquality.hash(bytes));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitationBlob &&
          other.id == this.id &&
          other.citationId == this.citationId &&
          $driftBlobEquality.equals(other.bytes, this.bytes));
}

class CitationBlobsCompanion extends UpdateCompanion<CitationBlob> {
  final Value<String> id;
  final Value<String> citationId;
  final Value<Uint8List> bytes;
  final Value<int> rowid;
  const CitationBlobsCompanion({
    this.id = const Value.absent(),
    this.citationId = const Value.absent(),
    this.bytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitationBlobsCompanion.insert({
    required String id,
    required String citationId,
    required Uint8List bytes,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       citationId = Value(citationId),
       bytes = Value(bytes);
  static Insertable<CitationBlob> custom({
    Expression<String>? id,
    Expression<String>? citationId,
    Expression<Uint8List>? bytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (citationId != null) 'citation_id': citationId,
      if (bytes != null) 'bytes': bytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitationBlobsCompanion copyWith({
    Value<String>? id,
    Value<String>? citationId,
    Value<Uint8List>? bytes,
    Value<int>? rowid,
  }) {
    return CitationBlobsCompanion(
      id: id ?? this.id,
      citationId: citationId ?? this.citationId,
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
    if (citationId.present) {
      map['citation_id'] = Variable<String>(citationId.value);
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
    return (StringBuffer('CitationBlobsCompanion(')
          ..write('id: $id, ')
          ..write('citationId: $citationId, ')
          ..write('bytes: $bytes, ')
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
  late final $StudyMaterialItemsTable studyMaterialItems =
      $StudyMaterialItemsTable(this);
  late final $SourceItemBlobsTable sourceItemBlobs = $SourceItemBlobsTable(
    this,
  );
  late final $StudyCardItemsTable studyCardItems = $StudyCardItemsTable(this);
  late final $StudySessionEventsTable studySessionEvents =
      $StudySessionEventsTable(this);
  late final $CardCreationDraftsTable cardCreationDrafts =
      $CardCreationDraftsTable(this);
  late final $CitationItemsTable citationItems = $CitationItemsTable(this);
  late final $CitationBlobsTable citationBlobs = $CitationBlobsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    studyFolderItems,
    sourceItems,
    studyMaterialItems,
    sourceItemBlobs,
    studyCardItems,
    studySessionEvents,
    cardCreationDrafts,
    citationItems,
    citationBlobs,
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

  static MultiTypedResultKey<$StudyMaterialItemsTable, List<StudyMaterialItem>>
  _studyMaterialItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studyMaterialItems,
        aliasName: $_aliasNameGenerator(
          db.studyFolderItems.id,
          db.studyMaterialItems.folderId,
        ),
      );

  $$StudyMaterialItemsTableProcessedTableManager get studyMaterialItemsRefs {
    final manager = $$StudyMaterialItemsTableTableManager(
      $_db,
      $_db.studyMaterialItems,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studyMaterialItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudyCardItemsTable, List<StudyCardItem>>
  _studyCardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyCardItems,
    aliasName: $_aliasNameGenerator(
      db.studyFolderItems.id,
      db.studyCardItems.folderId,
    ),
  );

  $$StudyCardItemsTableProcessedTableManager get studyCardItemsRefs {
    final manager = $$StudyCardItemsTableTableManager(
      $_db,
      $_db.studyCardItems,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyCardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardCreationDraftsTable, List<CardCreationDraft>>
  _cardCreationDraftsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cardCreationDrafts,
        aliasName: $_aliasNameGenerator(
          db.studyFolderItems.id,
          db.cardCreationDrafts.folderId,
        ),
      );

  $$CardCreationDraftsTableProcessedTableManager get cardCreationDraftsRefs {
    final manager = $$CardCreationDraftsTableTableManager(
      $_db,
      $_db.cardCreationDrafts,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cardCreationDraftsRefsTable($_db),
    );
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

  Expression<bool> studyMaterialItemsRefs(
    Expression<bool> Function($$StudyMaterialItemsTableFilterComposer f) f,
  ) {
    final $$StudyMaterialItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyMaterialItems,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyMaterialItemsTableFilterComposer(
            $db: $db,
            $table: $db.studyMaterialItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyCardItemsRefs(
    Expression<bool> Function($$StudyCardItemsTableFilterComposer f) f,
  ) {
    final $$StudyCardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyCardItems,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyCardItemsTableFilterComposer(
            $db: $db,
            $table: $db.studyCardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardCreationDraftsRefs(
    Expression<bool> Function($$CardCreationDraftsTableFilterComposer f) f,
  ) {
    final $$CardCreationDraftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardCreationDrafts,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardCreationDraftsTableFilterComposer(
            $db: $db,
            $table: $db.cardCreationDrafts,
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

  Expression<T> studyMaterialItemsRefs<T extends Object>(
    Expression<T> Function($$StudyMaterialItemsTableAnnotationComposer a) f,
  ) {
    final $$StudyMaterialItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studyMaterialItems,
          getReferencedColumn: (t) => t.folderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudyMaterialItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.studyMaterialItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> studyCardItemsRefs<T extends Object>(
    Expression<T> Function($$StudyCardItemsTableAnnotationComposer a) f,
  ) {
    final $$StudyCardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyCardItems,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyCardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyCardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardCreationDraftsRefs<T extends Object>(
    Expression<T> Function($$CardCreationDraftsTableAnnotationComposer a) f,
  ) {
    final $$CardCreationDraftsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cardCreationDrafts,
          getReferencedColumn: (t) => t.folderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardCreationDraftsTableAnnotationComposer(
                $db: $db,
                $table: $db.cardCreationDrafts,
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
          PrefetchHooks Function({
            bool sourceItemsRefs,
            bool studyMaterialItemsRefs,
            bool studyCardItemsRefs,
            bool cardCreationDraftsRefs,
          })
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
              ({
                sourceItemsRefs = false,
                studyMaterialItemsRefs = false,
                studyCardItemsRefs = false,
                cardCreationDraftsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceItemsRefs) db.sourceItems,
                    if (studyMaterialItemsRefs) db.studyMaterialItems,
                    if (studyCardItemsRefs) db.studyCardItems,
                    if (cardCreationDraftsRefs) db.cardCreationDrafts,
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
                      if (studyMaterialItemsRefs)
                        await $_getPrefetchedData<
                          StudyFolderItem,
                          $StudyFolderItemsTable,
                          StudyMaterialItem
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderItemsTableReferences
                              ._studyMaterialItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyMaterialItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studyCardItemsRefs)
                        await $_getPrefetchedData<
                          StudyFolderItem,
                          $StudyFolderItemsTable,
                          StudyCardItem
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderItemsTableReferences
                              ._studyCardItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyCardItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardCreationDraftsRefs)
                        await $_getPrefetchedData<
                          StudyFolderItem,
                          $StudyFolderItemsTable,
                          CardCreationDraft
                        >(
                          currentTable: table,
                          referencedTable: $$StudyFolderItemsTableReferences
                              ._cardCreationDraftsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyFolderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardCreationDraftsRefs,
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
      PrefetchHooks Function({
        bool sourceItemsRefs,
        bool studyMaterialItemsRefs,
        bool studyCardItemsRefs,
        bool cardCreationDraftsRefs,
      })
    >;
typedef $$SourceItemsTableCreateCompanionBuilder =
    SourceItemsCompanion Function({
      required String id,
      Value<String?> folderId,
      required String label,
      Value<String?> path,
      required String type,
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
      Value<String> type,
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

  static MultiTypedResultKey<$CardCreationDraftsTable, List<CardCreationDraft>>
  _cardCreationDraftsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cardCreationDrafts,
        aliasName: $_aliasNameGenerator(
          db.sourceItems.id,
          db.cardCreationDrafts.lastSourceId,
        ),
      );

  $$CardCreationDraftsTableProcessedTableManager get cardCreationDraftsRefs {
    final manager = $$CardCreationDraftsTableTableManager(
      $_db,
      $_db.cardCreationDrafts,
    ).filter((f) => f.lastSourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cardCreationDraftsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CitationItemsTable, List<CitationItem>>
  _citationItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.citationItems,
    aliasName: $_aliasNameGenerator(
      db.sourceItems.id,
      db.citationItems.sourceId,
    ),
  );

  $$CitationItemsTableProcessedTableManager get citationItemsRefs {
    final manager = $$CitationItemsTableTableManager(
      $_db,
      $_db.citationItems,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_citationItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
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

  Expression<bool> cardCreationDraftsRefs(
    Expression<bool> Function($$CardCreationDraftsTableFilterComposer f) f,
  ) {
    final $$CardCreationDraftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardCreationDrafts,
      getReferencedColumn: (t) => t.lastSourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardCreationDraftsTableFilterComposer(
            $db: $db,
            $table: $db.cardCreationDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> citationItemsRefs(
    Expression<bool> Function($$CitationItemsTableFilterComposer f) f,
  ) {
    final $$CitationItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citationItems,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitationItemsTableFilterComposer(
            $db: $db,
            $table: $db.citationItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  GeneratedColumn<String> get type =>
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

  Expression<T> cardCreationDraftsRefs<T extends Object>(
    Expression<T> Function($$CardCreationDraftsTableAnnotationComposer a) f,
  ) {
    final $$CardCreationDraftsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cardCreationDrafts,
          getReferencedColumn: (t) => t.lastSourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardCreationDraftsTableAnnotationComposer(
                $db: $db,
                $table: $db.cardCreationDrafts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> citationItemsRefs<T extends Object>(
    Expression<T> Function($$CitationItemsTableAnnotationComposer a) f,
  ) {
    final $$CitationItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citationItems,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitationItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.citationItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({
            bool folderId,
            bool cardCreationDraftsRefs,
            bool citationItemsRefs,
          })
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
                Value<String> type = const Value.absent(),
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
                required String type,
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
          prefetchHooksCallback:
              ({
                folderId = false,
                cardCreationDraftsRefs = false,
                citationItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cardCreationDraftsRefs) db.cardCreationDrafts,
                    if (citationItemsRefs) db.citationItems,
                  ],
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
                                    referencedTable:
                                        $$SourceItemsTableReferences
                                            ._folderIdTable(db),
                                    referencedColumn:
                                        $$SourceItemsTableReferences
                                            ._folderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cardCreationDraftsRefs)
                        await $_getPrefetchedData<
                          SourceItem,
                          $SourceItemsTable,
                          CardCreationDraft
                        >(
                          currentTable: table,
                          referencedTable: $$SourceItemsTableReferences
                              ._cardCreationDraftsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourceItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardCreationDraftsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lastSourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (citationItemsRefs)
                        await $_getPrefetchedData<
                          SourceItem,
                          $SourceItemsTable,
                          CitationItem
                        >(
                          currentTable: table,
                          referencedTable: $$SourceItemsTableReferences
                              ._citationItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourceItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).citationItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
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
      PrefetchHooks Function({
        bool folderId,
        bool cardCreationDraftsRefs,
        bool citationItemsRefs,
      })
    >;
typedef $$StudyMaterialItemsTableCreateCompanionBuilder =
    StudyMaterialItemsCompanion Function({
      required String id,
      required String folderId,
      required String name,
      Value<String?> description,
      Value<bool> isPinned,
      Value<int> rowid,
    });
typedef $$StudyMaterialItemsTableUpdateCompanionBuilder =
    StudyMaterialItemsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String> name,
      Value<String?> description,
      Value<bool> isPinned,
      Value<int> rowid,
    });

final class $$StudyMaterialItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StudyMaterialItemsTable,
          StudyMaterialItem
        > {
  $$StudyMaterialItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyFolderItemsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderItems.createAlias(
        $_aliasNameGenerator(
          db.studyMaterialItems.folderId,
          db.studyFolderItems.id,
        ),
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

  static MultiTypedResultKey<$StudyCardItemsTable, List<StudyCardItem>>
  _studyCardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyCardItems,
    aliasName: $_aliasNameGenerator(
      db.studyMaterialItems.id,
      db.studyCardItems.materialId,
    ),
  );

  $$StudyCardItemsTableProcessedTableManager get studyCardItemsRefs {
    final manager = $$StudyCardItemsTableTableManager(
      $_db,
      $_db.studyCardItems,
    ).filter((f) => f.materialId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyCardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> studyCardItemsRefs(
    Expression<bool> Function($$StudyCardItemsTableFilterComposer f) f,
  ) {
    final $$StudyCardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyCardItems,
      getReferencedColumn: (t) => t.materialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyCardItemsTableFilterComposer(
            $db: $db,
            $table: $db.studyCardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> studyCardItemsRefs<T extends Object>(
    Expression<T> Function($$StudyCardItemsTableAnnotationComposer a) f,
  ) {
    final $$StudyCardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyCardItems,
      getReferencedColumn: (t) => t.materialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyCardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyCardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (StudyMaterialItem, $$StudyMaterialItemsTableReferences),
          StudyMaterialItem,
          PrefetchHooks Function({bool folderId, bool studyCardItemsRefs})
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
                Value<String> folderId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyMaterialItemsCompanion(
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
              }) => StudyMaterialItemsCompanion.insert(
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
                  $$StudyMaterialItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({folderId = false, studyCardItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studyCardItemsRefs) db.studyCardItems,
                  ],
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
                                    referencedTable:
                                        $$StudyMaterialItemsTableReferences
                                            ._folderIdTable(db),
                                    referencedColumn:
                                        $$StudyMaterialItemsTableReferences
                                            ._folderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studyCardItemsRefs)
                        await $_getPrefetchedData<
                          StudyMaterialItem,
                          $StudyMaterialItemsTable,
                          StudyCardItem
                        >(
                          currentTable: table,
                          referencedTable: $$StudyMaterialItemsTableReferences
                              ._studyCardItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyMaterialItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyCardItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.materialId == item.id,
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
      (StudyMaterialItem, $$StudyMaterialItemsTableReferences),
      StudyMaterialItem,
      PrefetchHooks Function({bool folderId, bool studyCardItemsRefs})
    >;
typedef $$SourceItemBlobsTableCreateCompanionBuilder =
    SourceItemBlobsCompanion Function({
      required String id,
      required String sourceItemId,
      required String sourceItemName,
      required String type,
      required Uint8List bytes,
      Value<int> rowid,
    });
typedef $$SourceItemBlobsTableUpdateCompanionBuilder =
    SourceItemBlobsCompanion Function({
      Value<String> id,
      Value<String> sourceItemId,
      Value<String> sourceItemName,
      Value<String> type,
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
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

  GeneratedColumn<String> get type =>
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
                Value<String> type = const Value.absent(),
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
                required String type,
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
typedef $$StudyCardItemsTableCreateCompanionBuilder =
    StudyCardItemsCompanion Function({
      required String id,
      required String folderId,
      Value<String?> materialId,
      required String type,
      Value<List<String>?> citationIds,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<String?> due,
      Value<String?> fsrsCardJson,
      Value<int> rowid,
    });
typedef $$StudyCardItemsTableUpdateCompanionBuilder =
    StudyCardItemsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String?> materialId,
      Value<String> type,
      Value<List<String>?> citationIds,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<String?> due,
      Value<String?> fsrsCardJson,
      Value<int> rowid,
    });

final class $$StudyCardItemsTableReferences
    extends BaseReferences<_$AppDatabase, $StudyCardItemsTable, StudyCardItem> {
  $$StudyCardItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyFolderItemsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderItems.createAlias(
        $_aliasNameGenerator(
          db.studyCardItems.folderId,
          db.studyFolderItems.id,
        ),
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

  static $StudyMaterialItemsTable _materialIdTable(_$AppDatabase db) =>
      db.studyMaterialItems.createAlias(
        $_aliasNameGenerator(
          db.studyCardItems.materialId,
          db.studyMaterialItems.id,
        ),
      );

  $$StudyMaterialItemsTableProcessedTableManager? get materialId {
    final $_column = $_itemColumn<String>('material_id');
    if ($_column == null) return null;
    final manager = $$StudyMaterialItemsTableTableManager(
      $_db,
      $_db.studyMaterialItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyCardItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyCardItemsTable> {
  $$StudyCardItemsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get citationIds => $composableBuilder(
    column: $table.citationIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnFilters<String> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fsrsCardJson => $composableBuilder(
    column: $table.fsrsCardJson,
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

  $$StudyMaterialItemsTableFilterComposer get materialId {
    final $$StudyMaterialItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.studyMaterialItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyMaterialItemsTableFilterComposer(
            $db: $db,
            $table: $db.studyMaterialItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyCardItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyCardItemsTable> {
  $$StudyCardItemsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citationIds => $composableBuilder(
    column: $table.citationIds,
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

  ColumnOrderings<String> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fsrsCardJson => $composableBuilder(
    column: $table.fsrsCardJson,
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

  $$StudyMaterialItemsTableOrderingComposer get materialId {
    final $$StudyMaterialItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.studyMaterialItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyMaterialItemsTableOrderingComposer(
            $db: $db,
            $table: $db.studyMaterialItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyCardItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyCardItemsTable> {
  $$StudyCardItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get citationIds =>
      $composableBuilder(
        column: $table.citationIds,
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

  GeneratedColumn<String> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<String> get fsrsCardJson => $composableBuilder(
    column: $table.fsrsCardJson,
    builder: (column) => column,
  );

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

  $$StudyMaterialItemsTableAnnotationComposer get materialId {
    final $$StudyMaterialItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.materialId,
          referencedTable: $db.studyMaterialItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudyMaterialItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.studyMaterialItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$StudyCardItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyCardItemsTable,
          StudyCardItem,
          $$StudyCardItemsTableFilterComposer,
          $$StudyCardItemsTableOrderingComposer,
          $$StudyCardItemsTableAnnotationComposer,
          $$StudyCardItemsTableCreateCompanionBuilder,
          $$StudyCardItemsTableUpdateCompanionBuilder,
          (StudyCardItem, $$StudyCardItemsTableReferences),
          StudyCardItem,
          PrefetchHooks Function({bool folderId, bool materialId})
        > {
  $$StudyCardItemsTableTableManager(
    _$AppDatabase db,
    $StudyCardItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyCardItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyCardItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyCardItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folderId = const Value.absent(),
                Value<String?> materialId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<List<String>?> citationIds = const Value.absent(),
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<String?> due = const Value.absent(),
                Value<String?> fsrsCardJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyCardItemsCompanion(
                id: id,
                folderId: folderId,
                materialId: materialId,
                type: type,
                citationIds: citationIds,
                question: question,
                optionsListJson: optionsListJson,
                answer: answer,
                due: due,
                fsrsCardJson: fsrsCardJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folderId,
                Value<String?> materialId = const Value.absent(),
                required String type,
                Value<List<String>?> citationIds = const Value.absent(),
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<String?> due = const Value.absent(),
                Value<String?> fsrsCardJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyCardItemsCompanion.insert(
                id: id,
                folderId: folderId,
                materialId: materialId,
                type: type,
                citationIds: citationIds,
                question: question,
                optionsListJson: optionsListJson,
                answer: answer,
                due: due,
                fsrsCardJson: fsrsCardJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyCardItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false, materialId = false}) {
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
                                referencedTable: $$StudyCardItemsTableReferences
                                    ._folderIdTable(db),
                                referencedColumn:
                                    $$StudyCardItemsTableReferences
                                        ._folderIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (materialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.materialId,
                                referencedTable: $$StudyCardItemsTableReferences
                                    ._materialIdTable(db),
                                referencedColumn:
                                    $$StudyCardItemsTableReferences
                                        ._materialIdTable(db)
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

typedef $$StudyCardItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyCardItemsTable,
      StudyCardItem,
      $$StudyCardItemsTableFilterComposer,
      $$StudyCardItemsTableOrderingComposer,
      $$StudyCardItemsTableAnnotationComposer,
      $$StudyCardItemsTableCreateCompanionBuilder,
      $$StudyCardItemsTableUpdateCompanionBuilder,
      (StudyCardItem, $$StudyCardItemsTableReferences),
      StudyCardItem,
      PrefetchHooks Function({bool folderId, bool materialId})
    >;
typedef $$StudySessionEventsTableCreateCompanionBuilder =
    StudySessionEventsCompanion Function({
      required String id,
      required String cardId,
      Value<String?> materialId,
      required int rating,
      required String reviewedAt,
      required int scheduledDays,
      Value<int> rowid,
    });
typedef $$StudySessionEventsTableUpdateCompanionBuilder =
    StudySessionEventsCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String?> materialId,
      Value<int> rating,
      Value<String> reviewedAt,
      Value<int> scheduledDays,
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

  ColumnFilters<String> get materialId => $composableBuilder(
    column: $table.materialId,
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

  ColumnOrderings<String> get materialId => $composableBuilder(
    column: $table.materialId,
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

  GeneratedColumn<String> get materialId => $composableBuilder(
    column: $table.materialId,
    builder: (column) => column,
  );

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
                Value<String?> materialId = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<String> reviewedAt = const Value.absent(),
                Value<int> scheduledDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEventsCompanion(
                id: id,
                cardId: cardId,
                materialId: materialId,
                rating: rating,
                reviewedAt: reviewedAt,
                scheduledDays: scheduledDays,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                Value<String?> materialId = const Value.absent(),
                required int rating,
                required String reviewedAt,
                required int scheduledDays,
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEventsCompanion.insert(
                id: id,
                cardId: cardId,
                materialId: materialId,
                rating: rating,
                reviewedAt: reviewedAt,
                scheduledDays: scheduledDays,
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
typedef $$CardCreationDraftsTableCreateCompanionBuilder =
    CardCreationDraftsCompanion Function({
      required String folderId,
      Value<String?> lastSourceId,
      Value<double?> scrollX,
      Value<double?> scrollY,
      Value<double?> zoom,
      Value<String?> frontText,
      Value<String?> backText,
      Value<String?> toolbarMode,
      Value<String?> selectedText,
      Value<String?> capturedImageBlobId,
      Value<int> rowid,
    });
typedef $$CardCreationDraftsTableUpdateCompanionBuilder =
    CardCreationDraftsCompanion Function({
      Value<String> folderId,
      Value<String?> lastSourceId,
      Value<double?> scrollX,
      Value<double?> scrollY,
      Value<double?> zoom,
      Value<String?> frontText,
      Value<String?> backText,
      Value<String?> toolbarMode,
      Value<String?> selectedText,
      Value<String?> capturedImageBlobId,
      Value<int> rowid,
    });

final class $$CardCreationDraftsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CardCreationDraftsTable,
          CardCreationDraft
        > {
  $$CardCreationDraftsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyFolderItemsTable _folderIdTable(_$AppDatabase db) =>
      db.studyFolderItems.createAlias(
        $_aliasNameGenerator(
          db.cardCreationDrafts.folderId,
          db.studyFolderItems.id,
        ),
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

  static $SourceItemsTable _lastSourceIdTable(_$AppDatabase db) =>
      db.sourceItems.createAlias(
        $_aliasNameGenerator(
          db.cardCreationDrafts.lastSourceId,
          db.sourceItems.id,
        ),
      );

  $$SourceItemsTableProcessedTableManager? get lastSourceId {
    final $_column = $_itemColumn<String>('last_source_id');
    if ($_column == null) return null;
    final manager = $$SourceItemsTableTableManager(
      $_db,
      $_db.sourceItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lastSourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardCreationDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $CardCreationDraftsTable> {
  $$CardCreationDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get scrollX => $composableBuilder(
    column: $table.scrollX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scrollY => $composableBuilder(
    column: $table.scrollY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get zoom => $composableBuilder(
    column: $table.zoom,
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

  ColumnFilters<String> get toolbarMode => $composableBuilder(
    column: $table.toolbarMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedText => $composableBuilder(
    column: $table.selectedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capturedImageBlobId => $composableBuilder(
    column: $table.capturedImageBlobId,
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

  $$SourceItemsTableFilterComposer get lastSourceId {
    final $$SourceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastSourceId,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$CardCreationDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardCreationDraftsTable> {
  $$CardCreationDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get scrollX => $composableBuilder(
    column: $table.scrollX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scrollY => $composableBuilder(
    column: $table.scrollY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get zoom => $composableBuilder(
    column: $table.zoom,
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

  ColumnOrderings<String> get toolbarMode => $composableBuilder(
    column: $table.toolbarMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedText => $composableBuilder(
    column: $table.selectedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capturedImageBlobId => $composableBuilder(
    column: $table.capturedImageBlobId,
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

  $$SourceItemsTableOrderingComposer get lastSourceId {
    final $$SourceItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastSourceId,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceItemsTableOrderingComposer(
            $db: $db,
            $table: $db.sourceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardCreationDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardCreationDraftsTable> {
  $$CardCreationDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get scrollX =>
      $composableBuilder(column: $table.scrollX, builder: (column) => column);

  GeneratedColumn<double> get scrollY =>
      $composableBuilder(column: $table.scrollY, builder: (column) => column);

  GeneratedColumn<double> get zoom =>
      $composableBuilder(column: $table.zoom, builder: (column) => column);

  GeneratedColumn<String> get frontText =>
      $composableBuilder(column: $table.frontText, builder: (column) => column);

  GeneratedColumn<String> get backText =>
      $composableBuilder(column: $table.backText, builder: (column) => column);

  GeneratedColumn<String> get toolbarMode => $composableBuilder(
    column: $table.toolbarMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedText => $composableBuilder(
    column: $table.selectedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get capturedImageBlobId => $composableBuilder(
    column: $table.capturedImageBlobId,
    builder: (column) => column,
  );

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

  $$SourceItemsTableAnnotationComposer get lastSourceId {
    final $$SourceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastSourceId,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$CardCreationDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardCreationDraftsTable,
          CardCreationDraft,
          $$CardCreationDraftsTableFilterComposer,
          $$CardCreationDraftsTableOrderingComposer,
          $$CardCreationDraftsTableAnnotationComposer,
          $$CardCreationDraftsTableCreateCompanionBuilder,
          $$CardCreationDraftsTableUpdateCompanionBuilder,
          (CardCreationDraft, $$CardCreationDraftsTableReferences),
          CardCreationDraft,
          PrefetchHooks Function({bool folderId, bool lastSourceId})
        > {
  $$CardCreationDraftsTableTableManager(
    _$AppDatabase db,
    $CardCreationDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardCreationDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardCreationDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardCreationDraftsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> folderId = const Value.absent(),
                Value<String?> lastSourceId = const Value.absent(),
                Value<double?> scrollX = const Value.absent(),
                Value<double?> scrollY = const Value.absent(),
                Value<double?> zoom = const Value.absent(),
                Value<String?> frontText = const Value.absent(),
                Value<String?> backText = const Value.absent(),
                Value<String?> toolbarMode = const Value.absent(),
                Value<String?> selectedText = const Value.absent(),
                Value<String?> capturedImageBlobId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardCreationDraftsCompanion(
                folderId: folderId,
                lastSourceId: lastSourceId,
                scrollX: scrollX,
                scrollY: scrollY,
                zoom: zoom,
                frontText: frontText,
                backText: backText,
                toolbarMode: toolbarMode,
                selectedText: selectedText,
                capturedImageBlobId: capturedImageBlobId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String folderId,
                Value<String?> lastSourceId = const Value.absent(),
                Value<double?> scrollX = const Value.absent(),
                Value<double?> scrollY = const Value.absent(),
                Value<double?> zoom = const Value.absent(),
                Value<String?> frontText = const Value.absent(),
                Value<String?> backText = const Value.absent(),
                Value<String?> toolbarMode = const Value.absent(),
                Value<String?> selectedText = const Value.absent(),
                Value<String?> capturedImageBlobId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardCreationDraftsCompanion.insert(
                folderId: folderId,
                lastSourceId: lastSourceId,
                scrollX: scrollX,
                scrollY: scrollY,
                zoom: zoom,
                frontText: frontText,
                backText: backText,
                toolbarMode: toolbarMode,
                selectedText: selectedText,
                capturedImageBlobId: capturedImageBlobId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardCreationDraftsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false, lastSourceId = false}) {
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
                                referencedTable:
                                    $$CardCreationDraftsTableReferences
                                        ._folderIdTable(db),
                                referencedColumn:
                                    $$CardCreationDraftsTableReferences
                                        ._folderIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (lastSourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lastSourceId,
                                referencedTable:
                                    $$CardCreationDraftsTableReferences
                                        ._lastSourceIdTable(db),
                                referencedColumn:
                                    $$CardCreationDraftsTableReferences
                                        ._lastSourceIdTable(db)
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

typedef $$CardCreationDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardCreationDraftsTable,
      CardCreationDraft,
      $$CardCreationDraftsTableFilterComposer,
      $$CardCreationDraftsTableOrderingComposer,
      $$CardCreationDraftsTableAnnotationComposer,
      $$CardCreationDraftsTableCreateCompanionBuilder,
      $$CardCreationDraftsTableUpdateCompanionBuilder,
      (CardCreationDraft, $$CardCreationDraftsTableReferences),
      CardCreationDraft,
      PrefetchHooks Function({bool folderId, bool lastSourceId})
    >;
typedef $$CitationItemsTableCreateCompanionBuilder =
    CitationItemsCompanion Function({
      required String id,
      required String sourceId,
      required String type,
      Value<int?> pageNumber,
      required Citation citation,
      Value<int> rowid,
    });
typedef $$CitationItemsTableUpdateCompanionBuilder =
    CitationItemsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> type,
      Value<int?> pageNumber,
      Value<Citation> citation,
      Value<int> rowid,
    });

final class $$CitationItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CitationItemsTable, CitationItem> {
  $$CitationItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourceItemsTable _sourceIdTable(_$AppDatabase db) =>
      db.sourceItems.createAlias(
        $_aliasNameGenerator(db.citationItems.sourceId, db.sourceItems.id),
      );

  $$SourceItemsTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourceItemsTableTableManager(
      $_db,
      $_db.sourceItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CitationBlobsTable, List<CitationBlob>>
  _citationBlobsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.citationBlobs,
    aliasName: $_aliasNameGenerator(
      db.citationItems.id,
      db.citationBlobs.citationId,
    ),
  );

  $$CitationBlobsTableProcessedTableManager get citationBlobsRefs {
    final manager = $$CitationBlobsTableTableManager(
      $_db,
      $_db.citationBlobs,
    ).filter((f) => f.citationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_citationBlobsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Citation, Citation, String> get citation =>
      $composableBuilder(
        column: $table.citation,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$SourceItemsTableFilterComposer get sourceId {
    final $$SourceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  Expression<bool> citationBlobsRefs(
    Expression<bool> Function($$CitationBlobsTableFilterComposer f) f,
  ) {
    final $$CitationBlobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citationBlobs,
      getReferencedColumn: (t) => t.citationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitationBlobsTableFilterComposer(
            $db: $db,
            $table: $db.citationBlobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citation => $composableBuilder(
    column: $table.citation,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourceItemsTableOrderingComposer get sourceId {
    final $$SourceItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceItemsTableOrderingComposer(
            $db: $db,
            $table: $db.sourceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Citation, String> get citation =>
      $composableBuilder(column: $table.citation, builder: (column) => column);

  $$SourceItemsTableAnnotationComposer get sourceId {
    final $$SourceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sourceItems,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  Expression<T> citationBlobsRefs<T extends Object>(
    Expression<T> Function($$CitationBlobsTableAnnotationComposer a) f,
  ) {
    final $$CitationBlobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.citationBlobs,
      getReferencedColumn: (t) => t.citationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitationBlobsTableAnnotationComposer(
            $db: $db,
            $table: $db.citationBlobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (CitationItem, $$CitationItemsTableReferences),
          CitationItem,
          PrefetchHooks Function({bool sourceId, bool citationBlobsRefs})
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
                Value<String> sourceId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<Citation> citation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitationItemsCompanion(
                id: id,
                sourceId: sourceId,
                type: type,
                pageNumber: pageNumber,
                citation: citation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String type,
                Value<int?> pageNumber = const Value.absent(),
                required Citation citation,
                Value<int> rowid = const Value.absent(),
              }) => CitationItemsCompanion.insert(
                id: id,
                sourceId: sourceId,
                type: type,
                pageNumber: pageNumber,
                citation: citation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CitationItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceId = false, citationBlobsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (citationBlobsRefs) db.citationBlobs,
                  ],
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
                        if (sourceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceId,
                                    referencedTable:
                                        $$CitationItemsTableReferences
                                            ._sourceIdTable(db),
                                    referencedColumn:
                                        $$CitationItemsTableReferences
                                            ._sourceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (citationBlobsRefs)
                        await $_getPrefetchedData<
                          CitationItem,
                          $CitationItemsTable,
                          CitationBlob
                        >(
                          currentTable: table,
                          referencedTable: $$CitationItemsTableReferences
                              ._citationBlobsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CitationItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).citationBlobsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.citationId == item.id,
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
      (CitationItem, $$CitationItemsTableReferences),
      CitationItem,
      PrefetchHooks Function({bool sourceId, bool citationBlobsRefs})
    >;
typedef $$CitationBlobsTableCreateCompanionBuilder =
    CitationBlobsCompanion Function({
      required String id,
      required String citationId,
      required Uint8List bytes,
      Value<int> rowid,
    });
typedef $$CitationBlobsTableUpdateCompanionBuilder =
    CitationBlobsCompanion Function({
      Value<String> id,
      Value<String> citationId,
      Value<Uint8List> bytes,
      Value<int> rowid,
    });

final class $$CitationBlobsTableReferences
    extends BaseReferences<_$AppDatabase, $CitationBlobsTable, CitationBlob> {
  $$CitationBlobsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CitationItemsTable _citationIdTable(_$AppDatabase db) =>
      db.citationItems.createAlias(
        $_aliasNameGenerator(db.citationBlobs.citationId, db.citationItems.id),
      );

  $$CitationItemsTableProcessedTableManager get citationId {
    final $_column = $_itemColumn<String>('citation_id')!;

    final manager = $$CitationItemsTableTableManager(
      $_db,
      $_db.citationItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_citationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CitationBlobsTableFilterComposer
    extends Composer<_$AppDatabase, $CitationBlobsTable> {
  $$CitationBlobsTableFilterComposer({
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

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  $$CitationItemsTableFilterComposer get citationId {
    final $$CitationItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.citationId,
      referencedTable: $db.citationItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitationItemsTableFilterComposer(
            $db: $db,
            $table: $db.citationItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitationBlobsTableOrderingComposer
    extends Composer<_$AppDatabase, $CitationBlobsTable> {
  $$CitationBlobsTableOrderingComposer({
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

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CitationItemsTableOrderingComposer get citationId {
    final $$CitationItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.citationId,
      referencedTable: $db.citationItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitationItemsTableOrderingComposer(
            $db: $db,
            $table: $db.citationItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitationBlobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CitationBlobsTable> {
  $$CitationBlobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);

  $$CitationItemsTableAnnotationComposer get citationId {
    final $$CitationItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.citationId,
      referencedTable: $db.citationItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitationItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.citationItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitationBlobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CitationBlobsTable,
          CitationBlob,
          $$CitationBlobsTableFilterComposer,
          $$CitationBlobsTableOrderingComposer,
          $$CitationBlobsTableAnnotationComposer,
          $$CitationBlobsTableCreateCompanionBuilder,
          $$CitationBlobsTableUpdateCompanionBuilder,
          (CitationBlob, $$CitationBlobsTableReferences),
          CitationBlob,
          PrefetchHooks Function({bool citationId})
        > {
  $$CitationBlobsTableTableManager(_$AppDatabase db, $CitationBlobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitationBlobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitationBlobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitationBlobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> citationId = const Value.absent(),
                Value<Uint8List> bytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitationBlobsCompanion(
                id: id,
                citationId: citationId,
                bytes: bytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String citationId,
                required Uint8List bytes,
                Value<int> rowid = const Value.absent(),
              }) => CitationBlobsCompanion.insert(
                id: id,
                citationId: citationId,
                bytes: bytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CitationBlobsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({citationId = false}) {
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
                    if (citationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.citationId,
                                referencedTable: $$CitationBlobsTableReferences
                                    ._citationIdTable(db),
                                referencedColumn: $$CitationBlobsTableReferences
                                    ._citationIdTable(db)
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

typedef $$CitationBlobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CitationBlobsTable,
      CitationBlob,
      $$CitationBlobsTableFilterComposer,
      $$CitationBlobsTableOrderingComposer,
      $$CitationBlobsTableAnnotationComposer,
      $$CitationBlobsTableCreateCompanionBuilder,
      $$CitationBlobsTableUpdateCompanionBuilder,
      (CitationBlob, $$CitationBlobsTableReferences),
      CitationBlob,
      PrefetchHooks Function({bool citationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudyFolderItemsTableTableManager get studyFolderItems =>
      $$StudyFolderItemsTableTableManager(_db, _db.studyFolderItems);
  $$SourceItemsTableTableManager get sourceItems =>
      $$SourceItemsTableTableManager(_db, _db.sourceItems);
  $$StudyMaterialItemsTableTableManager get studyMaterialItems =>
      $$StudyMaterialItemsTableTableManager(_db, _db.studyMaterialItems);
  $$SourceItemBlobsTableTableManager get sourceItemBlobs =>
      $$SourceItemBlobsTableTableManager(_db, _db.sourceItemBlobs);
  $$StudyCardItemsTableTableManager get studyCardItems =>
      $$StudyCardItemsTableTableManager(_db, _db.studyCardItems);
  $$StudySessionEventsTableTableManager get studySessionEvents =>
      $$StudySessionEventsTableTableManager(_db, _db.studySessionEvents);
  $$CardCreationDraftsTableTableManager get cardCreationDrafts =>
      $$CardCreationDraftsTableTableManager(_db, _db.cardCreationDrafts);
  $$CitationItemsTableTableManager get citationItems =>
      $$CitationItemsTableTableManager(_db, _db.citationItems);
  $$CitationBlobsTableTableManager get citationBlobs =>
      $$CitationBlobsTableTableManager(_db, _db.citationBlobs);
}
