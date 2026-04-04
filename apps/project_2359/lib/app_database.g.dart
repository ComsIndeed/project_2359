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
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES deck_items (id)',
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
    deckId,
    type,
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
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
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
  CardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
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
  $CardItemsTable createAlias(String alias) {
    return $CardItemsTable(attachedDatabase, alias);
  }
}

class CardItem extends DataClass implements Insertable<CardItem> {
  final String id;
  final String deckId;
  final String type;

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
  const CardItem({
    required this.id,
    required this.deckId,
    required this.type,
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
    map['deck_id'] = Variable<String>(deckId);
    map['type'] = Variable<String>(type);
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

  CardItemsCompanion toCompanion(bool nullToAbsent) {
    return CardItemsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      type: Value(type),
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

  factory CardItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardItem(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      type: serializer.fromJson<String>(json['type']),
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
      'deckId': serializer.toJson<String>(deckId),
      'type': serializer.toJson<String>(type),
      'question': serializer.toJson<String?>(question),
      'optionsListJson': serializer.toJson<String?>(optionsListJson),
      'answer': serializer.toJson<String?>(answer),
      'due': serializer.toJson<String?>(due),
      'fsrsCardJson': serializer.toJson<String?>(fsrsCardJson),
    };
  }

  CardItem copyWith({
    String? id,
    String? deckId,
    String? type,
    Value<String?> question = const Value.absent(),
    Value<String?> optionsListJson = const Value.absent(),
    Value<String?> answer = const Value.absent(),
    Value<String?> due = const Value.absent(),
    Value<String?> fsrsCardJson = const Value.absent(),
  }) => CardItem(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    type: type ?? this.type,
    question: question.present ? question.value : this.question,
    optionsListJson: optionsListJson.present
        ? optionsListJson.value
        : this.optionsListJson,
    answer: answer.present ? answer.value : this.answer,
    due: due.present ? due.value : this.due,
    fsrsCardJson: fsrsCardJson.present ? fsrsCardJson.value : this.fsrsCardJson,
  );
  CardItem copyWithCompanion(CardItemsCompanion data) {
    return CardItem(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      type: data.type.present ? data.type.value : this.type,
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
    return (StringBuffer('CardItem(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('type: $type, ')
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
    deckId,
    type,
    question,
    optionsListJson,
    answer,
    due,
    fsrsCardJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardItem &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.type == this.type &&
          other.question == this.question &&
          other.optionsListJson == this.optionsListJson &&
          other.answer == this.answer &&
          other.due == this.due &&
          other.fsrsCardJson == this.fsrsCardJson);
}

class CardItemsCompanion extends UpdateCompanion<CardItem> {
  final Value<String> id;
  final Value<String> deckId;
  final Value<String> type;
  final Value<String?> question;
  final Value<String?> optionsListJson;
  final Value<String?> answer;
  final Value<String?> due;
  final Value<String?> fsrsCardJson;
  final Value<int> rowid;
  const CardItemsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.type = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.due = const Value.absent(),
    this.fsrsCardJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardItemsCompanion.insert({
    required String id,
    required String deckId,
    required String type,
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.due = const Value.absent(),
    this.fsrsCardJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deckId = Value(deckId),
       type = Value(type);
  static Insertable<CardItem> custom({
    Expression<String>? id,
    Expression<String>? deckId,
    Expression<String>? type,
    Expression<String>? question,
    Expression<String>? optionsListJson,
    Expression<String>? answer,
    Expression<String>? due,
    Expression<String>? fsrsCardJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (type != null) 'type': type,
      if (question != null) 'question': question,
      if (optionsListJson != null) 'options_list_json': optionsListJson,
      if (answer != null) 'answer': answer,
      if (due != null) 'due': due,
      if (fsrsCardJson != null) 'fsrs_card_json': fsrsCardJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? deckId,
    Value<String>? type,
    Value<String?>? question,
    Value<String?>? optionsListJson,
    Value<String?>? answer,
    Value<String?>? due,
    Value<String?>? fsrsCardJson,
    Value<int>? rowid,
  }) {
    return CardItemsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      type: type ?? this.type,
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
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
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
    return (StringBuffer('CardItemsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('type: $type, ')
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
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    deckId,
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
  final String deckId;
  final int rating;
  final String reviewedAt;
  final int scheduledDays;
  const StudySessionEvent({
    required this.id,
    required this.cardId,
    required this.deckId,
    required this.rating,
    required this.reviewedAt,
    required this.scheduledDays,
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
    };
  }

  StudySessionEvent copyWith({
    String? id,
    String? cardId,
    String? deckId,
    int? rating,
    String? reviewedAt,
    int? scheduledDays,
  }) => StudySessionEvent(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    deckId: deckId ?? this.deckId,
    rating: rating ?? this.rating,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    scheduledDays: scheduledDays ?? this.scheduledDays,
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
          ..write('scheduledDays: $scheduledDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, deckId, rating, reviewedAt, scheduledDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionEvent &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.deckId == this.deckId &&
          other.rating == this.rating &&
          other.reviewedAt == this.reviewedAt &&
          other.scheduledDays == this.scheduledDays);
}

class StudySessionEventsCompanion extends UpdateCompanion<StudySessionEvent> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> deckId;
  final Value<int> rating;
  final Value<String> reviewedAt;
  final Value<int> scheduledDays;
  final Value<int> rowid;
  const StudySessionEventsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.deckId = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionEventsCompanion.insert({
    required String id,
    required String cardId,
    required String deckId,
    required int rating,
    required String reviewedAt,
    required int scheduledDays,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       deckId = Value(deckId),
       rating = Value(rating),
       reviewedAt = Value(reviewedAt),
       scheduledDays = Value(scheduledDays);
  static Insertable<StudySessionEvent> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? deckId,
    Expression<int>? rating,
    Expression<String>? reviewedAt,
    Expression<int>? scheduledDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (deckId != null) 'deck_id': deckId,
      if (rating != null) 'rating': rating,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
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
    Value<int>? rowid,
  }) {
    return StudySessionEventsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      deckId: deckId ?? this.deckId,
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
  late final GeneratedColumnWithTypeConverter<List<CitationTimeRange>?, String>
  timeRanges =
      GeneratedColumn<String>(
        'time_ranges',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<CitationTimeRange>?>(
        $CitationItemsTable.$convertertimeRangesn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<CitationRect>?, String>
  rects = GeneratedColumn<String>(
    'rects',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<CitationRect>?>($CitationItemsTable.$converterrectsn);
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
  static TypeConverter<List<CitationTimeRange>, String> $convertertimeRanges =
      const CitationTimeRangeListConverter();
  static TypeConverter<List<CitationTimeRange>?, String?>
  $convertertimeRangesn = NullAwareTypeConverter.wrap($convertertimeRanges);
  static TypeConverter<List<CitationRect>, String> $converterrects =
      const CitationRectListConverter();
  static TypeConverter<List<CitationRect>?, String?> $converterrectsn =
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
  final List<CitationTimeRange>? timeRanges;

  /// One or more bounding boxes (e.g. for multi-line text selections in a PDF).
  final List<CitationRect>? rects;
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
      timeRanges: serializer.fromJson<List<CitationTimeRange>?>(
        json['timeRanges'],
      ),
      rects: serializer.fromJson<List<CitationRect>?>(json['rects']),
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
      'timeRanges': serializer.toJson<List<CitationTimeRange>?>(timeRanges),
      'rects': serializer.toJson<List<CitationRect>?>(rects),
    };
  }

  CitationItem copyWith({
    String? id,
    Value<String?> citedText = const Value.absent(),
    Value<List<String>?> sourceIds = const Value.absent(),
    Value<List<int>?> pageNumbers = const Value.absent(),
    Value<List<CitationTimeRange>?> timeRanges = const Value.absent(),
    Value<List<CitationRect>?> rects = const Value.absent(),
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
  final Value<List<CitationTimeRange>?> timeRanges;
  final Value<List<CitationRect>?> rects;
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
    Value<List<CitationTimeRange>?>? timeRanges,
    Value<List<CitationRect>?>? rects,
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
  late final $CardItemsTable cardItems = $CardItemsTable(this);
  late final $StudySessionEventsTable studySessionEvents =
      $StudySessionEventsTable(this);
  late final $CitationItemsTable citationItems = $CitationItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    studyFolderItems,
    sourceItems,
    deckItems,
    sourceItemBlobs,
    cardItems,
    studySessionEvents,
    citationItems,
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
typedef $$CardItemsTableCreateCompanionBuilder =
    CardItemsCompanion Function({
      required String id,
      required String deckId,
      required String type,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<String?> due,
      Value<String?> fsrsCardJson,
      Value<int> rowid,
    });
typedef $$CardItemsTableUpdateCompanionBuilder =
    CardItemsCompanion Function({
      Value<String> id,
      Value<String> deckId,
      Value<String> type,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<String?> due,
      Value<String?> fsrsCardJson,
      Value<int> rowid,
    });

final class $$CardItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CardItemsTable, CardItem> {
  $$CardItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeckItemsTable _deckIdTable(_$AppDatabase db) => db.deckItems
      .createAlias($_aliasNameGenerator(db.cardItems.deckId, db.deckItems.id));

  $$DeckItemsTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<String>('deck_id')!;

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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
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

  ColumnFilters<String> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fsrsCardJson => $composableBuilder(
    column: $table.fsrsCardJson,
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

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
          PrefetchHooks Function({bool deckId})
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
                Value<String> deckId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<String?> due = const Value.absent(),
                Value<String?> fsrsCardJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardItemsCompanion(
                id: id,
                deckId: deckId,
                type: type,
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
                required String deckId,
                required String type,
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<String?> due = const Value.absent(),
                Value<String?> fsrsCardJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardItemsCompanion.insert(
                id: id,
                deckId: deckId,
                type: type,
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
                  $$CardItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deckId = false}) {
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
      PrefetchHooks Function({bool deckId})
    >;
typedef $$StudySessionEventsTableCreateCompanionBuilder =
    StudySessionEventsCompanion Function({
      required String id,
      required String cardId,
      required String deckId,
      required int rating,
      required String reviewedAt,
      required int scheduledDays,
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
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEventsCompanion(
                id: id,
                cardId: cardId,
                deckId: deckId,
                rating: rating,
                reviewedAt: reviewedAt,
                scheduledDays: scheduledDays,
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
                Value<int> rowid = const Value.absent(),
              }) => StudySessionEventsCompanion.insert(
                id: id,
                cardId: cardId,
                deckId: deckId,
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
typedef $$CitationItemsTableCreateCompanionBuilder =
    CitationItemsCompanion Function({
      required String id,
      Value<String?> citedText,
      Value<List<String>?> sourceIds,
      Value<List<int>?> pageNumbers,
      Value<List<CitationTimeRange>?> timeRanges,
      Value<List<CitationRect>?> rects,
      Value<int> rowid,
    });
typedef $$CitationItemsTableUpdateCompanionBuilder =
    CitationItemsCompanion Function({
      Value<String> id,
      Value<String?> citedText,
      Value<List<String>?> sourceIds,
      Value<List<int>?> pageNumbers,
      Value<List<CitationTimeRange>?> timeRanges,
      Value<List<CitationRect>?> rects,
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
    List<CitationTimeRange>?,
    List<CitationTimeRange>,
    String
  >
  get timeRanges => $composableBuilder(
    column: $table.timeRanges,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<CitationRect>?,
    List<CitationRect>,
    String
  >
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

  GeneratedColumnWithTypeConverter<List<CitationTimeRange>?, String>
  get timeRanges => $composableBuilder(
    column: $table.timeRanges,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<CitationRect>?, String> get rects =>
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
                Value<List<CitationTimeRange>?> timeRanges =
                    const Value.absent(),
                Value<List<CitationRect>?> rects = const Value.absent(),
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
                Value<List<CitationTimeRange>?> timeRanges =
                    const Value.absent(),
                Value<List<CitationRect>?> rects = const Value.absent(),
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
  $$CardItemsTableTableManager get cardItems =>
      $$CardItemsTableTableManager(_db, _db.cardItems);
  $$StudySessionEventsTableTableManager get studySessionEvents =>
      $$StudySessionEventsTableTableManager(_db, _db.studySessionEvents);
  $$CitationItemsTableTableManager get citationItems =>
      $$CitationItemsTableTableManager(_db, _db.citationItems);
}
