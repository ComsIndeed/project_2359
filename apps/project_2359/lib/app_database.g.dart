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
  static const VerificationMeta _materialIdMeta = const VerificationMeta(
    'materialId',
  );
  @override
  late final GeneratedColumn<String> materialId = GeneratedColumn<String>(
    'material_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    materialId,
    type,
    citationJson,
    question,
    optionsListJson,
    answer,
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
    if (data.containsKey('material_id')) {
      context.handle(
        _materialIdMeta,
        materialId.isAcceptableOrUnknown(data['material_id']!, _materialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materialIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
  StudyCardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyCardItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      materialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
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
  $StudyCardItemsTable createAlias(String alias) {
    return $StudyCardItemsTable(attachedDatabase, alias);
  }
}

class StudyCardItem extends DataClass implements Insertable<StudyCardItem> {
  final String id;
  final String materialId;
  final String type;
  final String? citationJson;

  /// Fields are nullable because not all types use the same properties.
  /// - Flashcard: question (front), answer (back)
  /// - MCQ: question, optionsListJson, answer
  /// - Free-Text: question, answer
  /// - Image Occlusion: (not yet implemented)
  final String? question;
  final String? optionsListJson;
  final String? answer;
  const StudyCardItem({
    required this.id,
    required this.materialId,
    required this.type,
    this.citationJson,
    this.question,
    this.optionsListJson,
    this.answer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['material_id'] = Variable<String>(materialId);
    map['type'] = Variable<String>(type);
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

  StudyCardItemsCompanion toCompanion(bool nullToAbsent) {
    return StudyCardItemsCompanion(
      id: Value(id),
      materialId: Value(materialId),
      type: Value(type),
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

  factory StudyCardItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyCardItem(
      id: serializer.fromJson<String>(json['id']),
      materialId: serializer.fromJson<String>(json['materialId']),
      type: serializer.fromJson<String>(json['type']),
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
      'materialId': serializer.toJson<String>(materialId),
      'type': serializer.toJson<String>(type),
      'citationJson': serializer.toJson<String?>(citationJson),
      'question': serializer.toJson<String?>(question),
      'optionsListJson': serializer.toJson<String?>(optionsListJson),
      'answer': serializer.toJson<String?>(answer),
    };
  }

  StudyCardItem copyWith({
    String? id,
    String? materialId,
    String? type,
    Value<String?> citationJson = const Value.absent(),
    Value<String?> question = const Value.absent(),
    Value<String?> optionsListJson = const Value.absent(),
    Value<String?> answer = const Value.absent(),
  }) => StudyCardItem(
    id: id ?? this.id,
    materialId: materialId ?? this.materialId,
    type: type ?? this.type,
    citationJson: citationJson.present ? citationJson.value : this.citationJson,
    question: question.present ? question.value : this.question,
    optionsListJson: optionsListJson.present
        ? optionsListJson.value
        : this.optionsListJson,
    answer: answer.present ? answer.value : this.answer,
  );
  StudyCardItem copyWithCompanion(StudyCardItemsCompanion data) {
    return StudyCardItem(
      id: data.id.present ? data.id.value : this.id,
      materialId: data.materialId.present
          ? data.materialId.value
          : this.materialId,
      type: data.type.present ? data.type.value : this.type,
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
    return (StringBuffer('StudyCardItem(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('type: $type, ')
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
    materialId,
    type,
    citationJson,
    question,
    optionsListJson,
    answer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyCardItem &&
          other.id == this.id &&
          other.materialId == this.materialId &&
          other.type == this.type &&
          other.citationJson == this.citationJson &&
          other.question == this.question &&
          other.optionsListJson == this.optionsListJson &&
          other.answer == this.answer);
}

class StudyCardItemsCompanion extends UpdateCompanion<StudyCardItem> {
  final Value<String> id;
  final Value<String> materialId;
  final Value<String> type;
  final Value<String?> citationJson;
  final Value<String?> question;
  final Value<String?> optionsListJson;
  final Value<String?> answer;
  final Value<int> rowid;
  const StudyCardItemsCompanion({
    this.id = const Value.absent(),
    this.materialId = const Value.absent(),
    this.type = const Value.absent(),
    this.citationJson = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyCardItemsCompanion.insert({
    required String id,
    required String materialId,
    required String type,
    this.citationJson = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsListJson = const Value.absent(),
    this.answer = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       materialId = Value(materialId),
       type = Value(type);
  static Insertable<StudyCardItem> custom({
    Expression<String>? id,
    Expression<String>? materialId,
    Expression<String>? type,
    Expression<String>? citationJson,
    Expression<String>? question,
    Expression<String>? optionsListJson,
    Expression<String>? answer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (materialId != null) 'material_id': materialId,
      if (type != null) 'type': type,
      if (citationJson != null) 'citation_json': citationJson,
      if (question != null) 'question': question,
      if (optionsListJson != null) 'options_list_json': optionsListJson,
      if (answer != null) 'answer': answer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyCardItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? materialId,
    Value<String>? type,
    Value<String?>? citationJson,
    Value<String?>? question,
    Value<String?>? optionsListJson,
    Value<String?>? answer,
    Value<int>? rowid,
  }) {
    return StudyCardItemsCompanion(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      type: type ?? this.type,
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
    if (materialId.present) {
      map['material_id'] = Variable<String>(materialId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
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
    return (StringBuffer('StudyCardItemsCompanion(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('type: $type, ')
          ..write('citationJson: $citationJson, ')
          ..write('question: $question, ')
          ..write('optionsListJson: $optionsListJson, ')
          ..write('answer: $answer, ')
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
              ({sourceItemsRefs = false, studyMaterialItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceItemsRefs) db.sourceItems,
                    if (studyMaterialItemsRefs) db.studyMaterialItems,
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
      required String materialId,
      required String type,
      Value<String?> citationJson,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<int> rowid,
    });
typedef $$StudyCardItemsTableUpdateCompanionBuilder =
    StudyCardItemsCompanion Function({
      Value<String> id,
      Value<String> materialId,
      Value<String> type,
      Value<String?> citationJson,
      Value<String?> question,
      Value<String?> optionsListJson,
      Value<String?> answer,
      Value<int> rowid,
    });

final class $$StudyCardItemsTableReferences
    extends BaseReferences<_$AppDatabase, $StudyCardItemsTable, StudyCardItem> {
  $$StudyCardItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudyMaterialItemsTable _materialIdTable(_$AppDatabase db) =>
      db.studyMaterialItems.createAlias(
        $_aliasNameGenerator(
          db.studyCardItems.materialId,
          db.studyMaterialItems.id,
        ),
      );

  $$StudyMaterialItemsTableProcessedTableManager get materialId {
    final $_column = $_itemColumn<String>('material_id')!;

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
          PrefetchHooks Function({bool materialId})
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
                Value<String> materialId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> citationJson = const Value.absent(),
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyCardItemsCompanion(
                id: id,
                materialId: materialId,
                type: type,
                citationJson: citationJson,
                question: question,
                optionsListJson: optionsListJson,
                answer: answer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String materialId,
                required String type,
                Value<String?> citationJson = const Value.absent(),
                Value<String?> question = const Value.absent(),
                Value<String?> optionsListJson = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyCardItemsCompanion.insert(
                id: id,
                materialId: materialId,
                type: type,
                citationJson: citationJson,
                question: question,
                optionsListJson: optionsListJson,
                answer: answer,
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
          prefetchHooksCallback: ({materialId = false}) {
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
      PrefetchHooks Function({bool materialId})
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
}
