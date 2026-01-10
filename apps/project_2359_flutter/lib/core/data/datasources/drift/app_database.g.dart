// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SourcesTable extends Sources with TableInfo<$SourcesTable, SourceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SourceType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SourceType>($SourcesTable.$convertertype);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAccessedAtMeta = const VerificationMeta(
    'lastAccessedAt',
  );
  @override
  late final GeneratedColumn<int> lastAccessedAt = GeneratedColumn<int>(
    'last_accessed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($SourcesTable.$convertertags);
  static const VerificationMeta _isIndexedMeta = const VerificationMeta(
    'isIndexed',
  );
  @override
  late final GeneratedColumn<bool> isIndexed = GeneratedColumn<bool>(
    'is_indexed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_indexed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    type,
    createdAt,
    lastAccessedAt,
    filePath,
    url,
    content,
    sizeBytes,
    durationSeconds,
    thumbnailPath,
    tags,
    isIndexed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
        _lastAccessedAtMeta,
        lastAccessedAt.isAcceptableOrUnknown(
          data['last_accessed_at']!,
          _lastAccessedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastAccessedAtMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('is_indexed')) {
      context.handle(
        _isIndexedMeta,
        isIndexed.isAcceptableOrUnknown(data['is_indexed']!, _isIndexedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: $SourcesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      lastAccessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_accessed_at'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      tags: $SourcesTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      isIndexed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_indexed'],
      )!,
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }

  static TypeConverter<SourceType, int> $convertertype =
      const SourceTypeConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class SourceEntry extends DataClass implements Insertable<SourceEntry> {
  final String id;
  final String title;
  final SourceType type;
  final int createdAt;
  final int lastAccessedAt;
  final String? filePath;
  final String? url;
  final String? content;
  final int? sizeBytes;
  final int? durationSeconds;
  final String? thumbnailPath;
  final List<String> tags;
  final bool isIndexed;
  const SourceEntry({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.lastAccessedAt,
    this.filePath,
    this.url,
    this.content,
    this.sizeBytes,
    this.durationSeconds,
    this.thumbnailPath,
    required this.tags,
    required this.isIndexed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    {
      map['type'] = Variable<int>($SourcesTable.$convertertype.toSql(type));
    }
    map['created_at'] = Variable<int>(createdAt);
    map['last_accessed_at'] = Variable<int>(lastAccessedAt);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    {
      map['tags'] = Variable<String>($SourcesTable.$convertertags.toSql(tags));
    }
    map['is_indexed'] = Variable<bool>(isIndexed);
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      createdAt: Value(createdAt),
      lastAccessedAt: Value(lastAccessedAt),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      tags: Value(tags),
      isIndexed: Value(isIndexed),
    );
  }

  factory SourceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<SourceType>(json['type']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastAccessedAt: serializer.fromJson<int>(json['lastAccessedAt']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      url: serializer.fromJson<String?>(json['url']),
      content: serializer.fromJson<String?>(json['content']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      isIndexed: serializer.fromJson<bool>(json['isIndexed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<SourceType>(type),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastAccessedAt': serializer.toJson<int>(lastAccessedAt),
      'filePath': serializer.toJson<String?>(filePath),
      'url': serializer.toJson<String?>(url),
      'content': serializer.toJson<String?>(content),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'tags': serializer.toJson<List<String>>(tags),
      'isIndexed': serializer.toJson<bool>(isIndexed),
    };
  }

  SourceEntry copyWith({
    String? id,
    String? title,
    SourceType? type,
    int? createdAt,
    int? lastAccessedAt,
    Value<String?> filePath = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<int?> sizeBytes = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    List<String>? tags,
    bool? isIndexed,
  }) => SourceEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    filePath: filePath.present ? filePath.value : this.filePath,
    url: url.present ? url.value : this.url,
    content: content.present ? content.value : this.content,
    sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    tags: tags ?? this.tags,
    isIndexed: isIndexed ?? this.isIndexed,
  );
  SourceEntry copyWithCompanion(SourcesCompanion data) {
    return SourceEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      url: data.url.present ? data.url.value : this.url,
      content: data.content.present ? data.content.value : this.content,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      tags: data.tags.present ? data.tags.value : this.tags,
      isIndexed: data.isIndexed.present ? data.isIndexed.value : this.isIndexed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('filePath: $filePath, ')
          ..write('url: $url, ')
          ..write('content: $content, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('tags: $tags, ')
          ..write('isIndexed: $isIndexed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    type,
    createdAt,
    lastAccessedAt,
    filePath,
    url,
    content,
    sizeBytes,
    durationSeconds,
    thumbnailPath,
    tags,
    isIndexed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.lastAccessedAt == this.lastAccessedAt &&
          other.filePath == this.filePath &&
          other.url == this.url &&
          other.content == this.content &&
          other.sizeBytes == this.sizeBytes &&
          other.durationSeconds == this.durationSeconds &&
          other.thumbnailPath == this.thumbnailPath &&
          other.tags == this.tags &&
          other.isIndexed == this.isIndexed);
}

class SourcesCompanion extends UpdateCompanion<SourceEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<SourceType> type;
  final Value<int> createdAt;
  final Value<int> lastAccessedAt;
  final Value<String?> filePath;
  final Value<String?> url;
  final Value<String?> content;
  final Value<int?> sizeBytes;
  final Value<int?> durationSeconds;
  final Value<String?> thumbnailPath;
  final Value<List<String>> tags;
  final Value<bool> isIndexed;
  final Value<int> rowid;
  const SourcesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.filePath = const Value.absent(),
    this.url = const Value.absent(),
    this.content = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.tags = const Value.absent(),
    this.isIndexed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourcesCompanion.insert({
    required String id,
    required String title,
    required SourceType type,
    required int createdAt,
    required int lastAccessedAt,
    this.filePath = const Value.absent(),
    this.url = const Value.absent(),
    this.content = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    required List<String> tags,
    this.isIndexed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       type = Value(type),
       createdAt = Value(createdAt),
       lastAccessedAt = Value(lastAccessedAt),
       tags = Value(tags);
  static Insertable<SourceEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? type,
    Expression<int>? createdAt,
    Expression<int>? lastAccessedAt,
    Expression<String>? filePath,
    Expression<String>? url,
    Expression<String>? content,
    Expression<int>? sizeBytes,
    Expression<int>? durationSeconds,
    Expression<String>? thumbnailPath,
    Expression<String>? tags,
    Expression<bool>? isIndexed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (filePath != null) 'file_path': filePath,
      if (url != null) 'url': url,
      if (content != null) 'content': content,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (tags != null) 'tags': tags,
      if (isIndexed != null) 'is_indexed': isIndexed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<SourceType>? type,
    Value<int>? createdAt,
    Value<int>? lastAccessedAt,
    Value<String?>? filePath,
    Value<String?>? url,
    Value<String?>? content,
    Value<int?>? sizeBytes,
    Value<int?>? durationSeconds,
    Value<String?>? thumbnailPath,
    Value<List<String>>? tags,
    Value<bool>? isIndexed,
    Value<int>? rowid,
  }) {
    return SourcesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      filePath: filePath ?? this.filePath,
      url: url ?? this.url,
      content: content ?? this.content,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      tags: tags ?? this.tags,
      isIndexed: isIndexed ?? this.isIndexed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $SourcesTable.$convertertype.toSql(type.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<int>(lastAccessedAt.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $SourcesTable.$convertertags.toSql(tags.value),
      );
    }
    if (isIndexed.present) {
      map['is_indexed'] = Variable<bool>(isIndexed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('filePath: $filePath, ')
          ..write('url: $url, ')
          ..write('content: $content, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('tags: $tags, ')
          ..write('isIndexed: $isIndexed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FlashcardsTable extends Flashcards
    with TableInfo<$FlashcardsTable, FlashcardEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardsTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _frontMeta = const VerificationMeta('front');
  @override
  late final GeneratedColumn<String> front = GeneratedColumn<String>(
    'front',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backMeta = const VerificationMeta('back');
  @override
  late final GeneratedColumn<String> back = GeneratedColumn<String>(
    'back',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frontImagePathMeta = const VerificationMeta(
    'frontImagePath',
  );
  @override
  late final GeneratedColumn<String> frontImagePath = GeneratedColumn<String>(
    'front_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backImagePathMeta = const VerificationMeta(
    'backImagePath',
  );
  @override
  late final GeneratedColumn<String> backImagePath = GeneratedColumn<String>(
    'back_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceIdMeta = const VerificationMeta(
    'sourceReferenceId',
  );
  @override
  late final GeneratedColumn<String> sourceReferenceId =
      GeneratedColumn<String>(
        'source_reference_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($FlashcardsTable.$convertertags);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fsrsDataMeta = const VerificationMeta(
    'fsrsData',
  );
  @override
  late final GeneratedColumn<String> fsrsData = GeneratedColumn<String>(
    'fsrs_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    front,
    back,
    frontImagePath,
    backImagePath,
    sourceReferenceId,
    tags,
    createdAt,
    updatedAt,
    fsrsData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcards';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlashcardEntry> instance, {
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
    if (data.containsKey('front')) {
      context.handle(
        _frontMeta,
        front.isAcceptableOrUnknown(data['front']!, _frontMeta),
      );
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
        _backMeta,
        back.isAcceptableOrUnknown(data['back']!, _backMeta),
      );
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('front_image_path')) {
      context.handle(
        _frontImagePathMeta,
        frontImagePath.isAcceptableOrUnknown(
          data['front_image_path']!,
          _frontImagePathMeta,
        ),
      );
    }
    if (data.containsKey('back_image_path')) {
      context.handle(
        _backImagePathMeta,
        backImagePath.isAcceptableOrUnknown(
          data['back_image_path']!,
          _backImagePathMeta,
        ),
      );
    }
    if (data.containsKey('source_reference_id')) {
      context.handle(
        _sourceReferenceIdMeta,
        sourceReferenceId.isAcceptableOrUnknown(
          data['source_reference_id']!,
          _sourceReferenceIdMeta,
        ),
      );
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
    if (data.containsKey('fsrs_data')) {
      context.handle(
        _fsrsDataMeta,
        fsrsData.isAcceptableOrUnknown(data['fsrs_data']!, _fsrsDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashcardEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      front: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front'],
      )!,
      back: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back'],
      )!,
      frontImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front_image_path'],
      ),
      backImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back_image_path'],
      ),
      sourceReferenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference_id'],
      ),
      tags: $FlashcardsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      fsrsData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fsrs_data'],
      )!,
    );
  }

  @override
  $FlashcardsTable createAlias(String alias) {
    return $FlashcardsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class FlashcardEntry extends DataClass implements Insertable<FlashcardEntry> {
  final String id;
  final String sourceId;
  final String front;
  final String back;
  final String? frontImagePath;
  final String? backImagePath;
  final String? sourceReferenceId;
  final List<String> tags;
  final int createdAt;
  final int updatedAt;
  final String fsrsData;
  const FlashcardEntry({
    required this.id,
    required this.sourceId,
    required this.front,
    required this.back,
    this.frontImagePath,
    this.backImagePath,
    this.sourceReferenceId,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.fsrsData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['front'] = Variable<String>(front);
    map['back'] = Variable<String>(back);
    if (!nullToAbsent || frontImagePath != null) {
      map['front_image_path'] = Variable<String>(frontImagePath);
    }
    if (!nullToAbsent || backImagePath != null) {
      map['back_image_path'] = Variable<String>(backImagePath);
    }
    if (!nullToAbsent || sourceReferenceId != null) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId);
    }
    {
      map['tags'] = Variable<String>(
        $FlashcardsTable.$convertertags.toSql(tags),
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['fsrs_data'] = Variable<String>(fsrsData);
    return map;
  }

  FlashcardsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      front: Value(front),
      back: Value(back),
      frontImagePath: frontImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(frontImagePath),
      backImagePath: backImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(backImagePath),
      sourceReferenceId: sourceReferenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReferenceId),
      tags: Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fsrsData: Value(fsrsData),
    );
  }

  factory FlashcardEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      frontImagePath: serializer.fromJson<String?>(json['frontImagePath']),
      backImagePath: serializer.fromJson<String?>(json['backImagePath']),
      sourceReferenceId: serializer.fromJson<String?>(
        json['sourceReferenceId'],
      ),
      tags: serializer.fromJson<List<String>>(json['tags']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      fsrsData: serializer.fromJson<String>(json['fsrsData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'frontImagePath': serializer.toJson<String?>(frontImagePath),
      'backImagePath': serializer.toJson<String?>(backImagePath),
      'sourceReferenceId': serializer.toJson<String?>(sourceReferenceId),
      'tags': serializer.toJson<List<String>>(tags),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'fsrsData': serializer.toJson<String>(fsrsData),
    };
  }

  FlashcardEntry copyWith({
    String? id,
    String? sourceId,
    String? front,
    String? back,
    Value<String?> frontImagePath = const Value.absent(),
    Value<String?> backImagePath = const Value.absent(),
    Value<String?> sourceReferenceId = const Value.absent(),
    List<String>? tags,
    int? createdAt,
    int? updatedAt,
    String? fsrsData,
  }) => FlashcardEntry(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    front: front ?? this.front,
    back: back ?? this.back,
    frontImagePath: frontImagePath.present
        ? frontImagePath.value
        : this.frontImagePath,
    backImagePath: backImagePath.present
        ? backImagePath.value
        : this.backImagePath,
    sourceReferenceId: sourceReferenceId.present
        ? sourceReferenceId.value
        : this.sourceReferenceId,
    tags: tags ?? this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fsrsData: fsrsData ?? this.fsrsData,
  );
  FlashcardEntry copyWithCompanion(FlashcardsCompanion data) {
    return FlashcardEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      front: data.front.present ? data.front.value : this.front,
      back: data.back.present ? data.back.value : this.back,
      frontImagePath: data.frontImagePath.present
          ? data.frontImagePath.value
          : this.frontImagePath,
      backImagePath: data.backImagePath.present
          ? data.backImagePath.value
          : this.backImagePath,
      sourceReferenceId: data.sourceReferenceId.present
          ? data.sourceReferenceId.value
          : this.sourceReferenceId,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fsrsData: data.fsrsData.present ? data.fsrsData.value : this.fsrsData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardEntry(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('frontImagePath: $frontImagePath, ')
          ..write('backImagePath: $backImagePath, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    front,
    back,
    frontImagePath,
    backImagePath,
    sourceReferenceId,
    tags,
    createdAt,
    updatedAt,
    fsrsData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardEntry &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.front == this.front &&
          other.back == this.back &&
          other.frontImagePath == this.frontImagePath &&
          other.backImagePath == this.backImagePath &&
          other.sourceReferenceId == this.sourceReferenceId &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fsrsData == this.fsrsData);
}

class FlashcardsCompanion extends UpdateCompanion<FlashcardEntry> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> front;
  final Value<String> back;
  final Value<String?> frontImagePath;
  final Value<String?> backImagePath;
  final Value<String?> sourceReferenceId;
  final Value<List<String>> tags;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> fsrsData;
  final Value<int> rowid;
  const FlashcardsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.front = const Value.absent(),
    this.back = const Value.absent(),
    this.frontImagePath = const Value.absent(),
    this.backImagePath = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlashcardsCompanion.insert({
    required String id,
    required String sourceId,
    required String front,
    required String back,
    this.frontImagePath = const Value.absent(),
    this.backImagePath = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    required List<String> tags,
    required int createdAt,
    required int updatedAt,
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       front = Value(front),
       back = Value(back),
       tags = Value(tags),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FlashcardEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? front,
    Expression<String>? back,
    Expression<String>? frontImagePath,
    Expression<String>? backImagePath,
    Expression<String>? sourceReferenceId,
    Expression<String>? tags,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? fsrsData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (frontImagePath != null) 'front_image_path': frontImagePath,
      if (backImagePath != null) 'back_image_path': backImagePath,
      if (sourceReferenceId != null) 'source_reference_id': sourceReferenceId,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fsrsData != null) 'fsrs_data': fsrsData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlashcardsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? front,
    Value<String>? back,
    Value<String?>? frontImagePath,
    Value<String?>? backImagePath,
    Value<String?>? sourceReferenceId,
    Value<List<String>>? tags,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? fsrsData,
    Value<int>? rowid,
  }) {
    return FlashcardsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      front: front ?? this.front,
      back: back ?? this.back,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      sourceReferenceId: sourceReferenceId ?? this.sourceReferenceId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fsrsData: fsrsData ?? this.fsrsData,
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
    if (front.present) {
      map['front'] = Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = Variable<String>(back.value);
    }
    if (frontImagePath.present) {
      map['front_image_path'] = Variable<String>(frontImagePath.value);
    }
    if (backImagePath.present) {
      map['back_image_path'] = Variable<String>(backImagePath.value);
    }
    if (sourceReferenceId.present) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $FlashcardsTable.$convertertags.toSql(tags.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (fsrsData.present) {
      map['fsrs_data'] = Variable<String>(fsrsData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('frontImagePath: $frontImagePath, ')
          ..write('backImagePath: $backImagePath, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizQuestionsTable extends QuizQuestions
    with TableInfo<$QuizQuestionsTable, QuizQuestionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizQuestionsTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> options =
      GeneratedColumn<String>(
        'options',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($QuizQuestionsTable.$converteroptions);
  static const VerificationMeta _correctOptionIndexMeta =
      const VerificationMeta('correctOptionIndex');
  @override
  late final GeneratedColumn<int> correctOptionIndex = GeneratedColumn<int>(
    'correct_option_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceIdMeta = const VerificationMeta(
    'sourceReferenceId',
  );
  @override
  late final GeneratedColumn<String> sourceReferenceId =
      GeneratedColumn<String>(
        'source_reference_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($QuizQuestionsTable.$convertertags);
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fsrsDataMeta = const VerificationMeta(
    'fsrsData',
  );
  @override
  late final GeneratedColumn<String> fsrsData = GeneratedColumn<String>(
    'fsrs_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    question,
    options,
    correctOptionIndex,
    explanation,
    imagePath,
    sourceReferenceId,
    tags,
    difficulty,
    createdAt,
    updatedAt,
    fsrsData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizQuestionEntry> instance, {
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
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('correct_option_index')) {
      context.handle(
        _correctOptionIndexMeta,
        correctOptionIndex.isAcceptableOrUnknown(
          data['correct_option_index']!,
          _correctOptionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctOptionIndexMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('source_reference_id')) {
      context.handle(
        _sourceReferenceIdMeta,
        sourceReferenceId.isAcceptableOrUnknown(
          data['source_reference_id']!,
          _sourceReferenceIdMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
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
    if (data.containsKey('fsrs_data')) {
      context.handle(
        _fsrsDataMeta,
        fsrsData.isAcceptableOrUnknown(data['fsrs_data']!, _fsrsDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizQuestionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizQuestionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      options: $QuizQuestionsTable.$converteroptions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}options'],
        )!,
      ),
      correctOptionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_option_index'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      sourceReferenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference_id'],
      ),
      tags: $QuizQuestionsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      fsrsData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fsrs_data'],
      )!,
    );
  }

  @override
  $QuizQuestionsTable createAlias(String alias) {
    return $QuizQuestionsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converteroptions =
      const StringListConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class QuizQuestionEntry extends DataClass
    implements Insertable<QuizQuestionEntry> {
  final String id;
  final String sourceId;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;
  final String? imagePath;
  final String? sourceReferenceId;
  final List<String> tags;
  final int difficulty;
  final int createdAt;
  final int updatedAt;
  final String fsrsData;
  const QuizQuestionEntry({
    required this.id,
    required this.sourceId,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
    this.imagePath,
    this.sourceReferenceId,
    required this.tags,
    required this.difficulty,
    required this.createdAt,
    required this.updatedAt,
    required this.fsrsData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['question'] = Variable<String>(question);
    {
      map['options'] = Variable<String>(
        $QuizQuestionsTable.$converteroptions.toSql(options),
      );
    }
    map['correct_option_index'] = Variable<int>(correctOptionIndex);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || sourceReferenceId != null) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId);
    }
    {
      map['tags'] = Variable<String>(
        $QuizQuestionsTable.$convertertags.toSql(tags),
      );
    }
    map['difficulty'] = Variable<int>(difficulty);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['fsrs_data'] = Variable<String>(fsrsData);
    return map;
  }

  QuizQuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuizQuestionsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      question: Value(question),
      options: Value(options),
      correctOptionIndex: Value(correctOptionIndex),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      sourceReferenceId: sourceReferenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReferenceId),
      tags: Value(tags),
      difficulty: Value(difficulty),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fsrsData: Value(fsrsData),
    );
  }

  factory QuizQuestionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizQuestionEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      question: serializer.fromJson<String>(json['question']),
      options: serializer.fromJson<List<String>>(json['options']),
      correctOptionIndex: serializer.fromJson<int>(json['correctOptionIndex']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      sourceReferenceId: serializer.fromJson<String?>(
        json['sourceReferenceId'],
      ),
      tags: serializer.fromJson<List<String>>(json['tags']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      fsrsData: serializer.fromJson<String>(json['fsrsData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'question': serializer.toJson<String>(question),
      'options': serializer.toJson<List<String>>(options),
      'correctOptionIndex': serializer.toJson<int>(correctOptionIndex),
      'explanation': serializer.toJson<String?>(explanation),
      'imagePath': serializer.toJson<String?>(imagePath),
      'sourceReferenceId': serializer.toJson<String?>(sourceReferenceId),
      'tags': serializer.toJson<List<String>>(tags),
      'difficulty': serializer.toJson<int>(difficulty),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'fsrsData': serializer.toJson<String>(fsrsData),
    };
  }

  QuizQuestionEntry copyWith({
    String? id,
    String? sourceId,
    String? question,
    List<String>? options,
    int? correctOptionIndex,
    Value<String?> explanation = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> sourceReferenceId = const Value.absent(),
    List<String>? tags,
    int? difficulty,
    int? createdAt,
    int? updatedAt,
    String? fsrsData,
  }) => QuizQuestionEntry(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    question: question ?? this.question,
    options: options ?? this.options,
    correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
    explanation: explanation.present ? explanation.value : this.explanation,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    sourceReferenceId: sourceReferenceId.present
        ? sourceReferenceId.value
        : this.sourceReferenceId,
    tags: tags ?? this.tags,
    difficulty: difficulty ?? this.difficulty,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fsrsData: fsrsData ?? this.fsrsData,
  );
  QuizQuestionEntry copyWithCompanion(QuizQuestionsCompanion data) {
    return QuizQuestionEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      question: data.question.present ? data.question.value : this.question,
      options: data.options.present ? data.options.value : this.options,
      correctOptionIndex: data.correctOptionIndex.present
          ? data.correctOptionIndex.value
          : this.correctOptionIndex,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      sourceReferenceId: data.sourceReferenceId.present
          ? data.sourceReferenceId.value
          : this.sourceReferenceId,
      tags: data.tags.present ? data.tags.value : this.tags,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fsrsData: data.fsrsData.present ? data.fsrsData.value : this.fsrsData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionEntry(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctOptionIndex: $correctOptionIndex, ')
          ..write('explanation: $explanation, ')
          ..write('imagePath: $imagePath, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    question,
    options,
    correctOptionIndex,
    explanation,
    imagePath,
    sourceReferenceId,
    tags,
    difficulty,
    createdAt,
    updatedAt,
    fsrsData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizQuestionEntry &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.question == this.question &&
          other.options == this.options &&
          other.correctOptionIndex == this.correctOptionIndex &&
          other.explanation == this.explanation &&
          other.imagePath == this.imagePath &&
          other.sourceReferenceId == this.sourceReferenceId &&
          other.tags == this.tags &&
          other.difficulty == this.difficulty &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fsrsData == this.fsrsData);
}

class QuizQuestionsCompanion extends UpdateCompanion<QuizQuestionEntry> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> question;
  final Value<List<String>> options;
  final Value<int> correctOptionIndex;
  final Value<String?> explanation;
  final Value<String?> imagePath;
  final Value<String?> sourceReferenceId;
  final Value<List<String>> tags;
  final Value<int> difficulty;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> fsrsData;
  final Value<int> rowid;
  const QuizQuestionsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.question = const Value.absent(),
    this.options = const Value.absent(),
    this.correctOptionIndex = const Value.absent(),
    this.explanation = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    this.tags = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizQuestionsCompanion.insert({
    required String id,
    required String sourceId,
    required String question,
    required List<String> options,
    required int correctOptionIndex,
    this.explanation = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    required List<String> tags,
    this.difficulty = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       question = Value(question),
       options = Value(options),
       correctOptionIndex = Value(correctOptionIndex),
       tags = Value(tags),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<QuizQuestionEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? question,
    Expression<String>? options,
    Expression<int>? correctOptionIndex,
    Expression<String>? explanation,
    Expression<String>? imagePath,
    Expression<String>? sourceReferenceId,
    Expression<String>? tags,
    Expression<int>? difficulty,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? fsrsData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (question != null) 'question': question,
      if (options != null) 'options': options,
      if (correctOptionIndex != null)
        'correct_option_index': correctOptionIndex,
      if (explanation != null) 'explanation': explanation,
      if (imagePath != null) 'image_path': imagePath,
      if (sourceReferenceId != null) 'source_reference_id': sourceReferenceId,
      if (tags != null) 'tags': tags,
      if (difficulty != null) 'difficulty': difficulty,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fsrsData != null) 'fsrs_data': fsrsData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? question,
    Value<List<String>>? options,
    Value<int>? correctOptionIndex,
    Value<String?>? explanation,
    Value<String?>? imagePath,
    Value<String?>? sourceReferenceId,
    Value<List<String>>? tags,
    Value<int>? difficulty,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? fsrsData,
    Value<int>? rowid,
  }) {
    return QuizQuestionsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      explanation: explanation ?? this.explanation,
      imagePath: imagePath ?? this.imagePath,
      sourceReferenceId: sourceReferenceId ?? this.sourceReferenceId,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fsrsData: fsrsData ?? this.fsrsData,
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
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(
        $QuizQuestionsTable.$converteroptions.toSql(options.value),
      );
    }
    if (correctOptionIndex.present) {
      map['correct_option_index'] = Variable<int>(correctOptionIndex.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (sourceReferenceId.present) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $QuizQuestionsTable.$convertertags.toSql(tags.value),
      );
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (fsrsData.present) {
      map['fsrs_data'] = Variable<String>(fsrsData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctOptionIndex: $correctOptionIndex, ')
          ..write('explanation: $explanation, ')
          ..write('imagePath: $imagePath, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdentificationQuestionsTable extends IdentificationQuestions
    with TableInfo<$IdentificationQuestionsTable, IdentificationQuestionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdentificationQuestionsTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelAnswerMeta = const VerificationMeta(
    'modelAnswer',
  );
  @override
  late final GeneratedColumn<String> modelAnswer = GeneratedColumn<String>(
    'model_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> hints =
      GeneratedColumn<String>(
        'hints',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $IdentificationQuestionsTable.$converterhints,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> keywords =
      GeneratedColumn<String>(
        'keywords',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $IdentificationQuestionsTable.$converterkeywords,
      );
  static const VerificationMeta _sourceReferenceIdMeta = const VerificationMeta(
    'sourceReferenceId',
  );
  @override
  late final GeneratedColumn<String> sourceReferenceId =
      GeneratedColumn<String>(
        'source_reference_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $IdentificationQuestionsTable.$convertertags,
      );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fsrsDataMeta = const VerificationMeta(
    'fsrsData',
  );
  @override
  late final GeneratedColumn<String> fsrsData = GeneratedColumn<String>(
    'fsrs_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    question,
    modelAnswer,
    hints,
    keywords,
    sourceReferenceId,
    tags,
    difficulty,
    createdAt,
    updatedAt,
    fsrsData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'identification_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdentificationQuestionEntry> instance, {
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
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('model_answer')) {
      context.handle(
        _modelAnswerMeta,
        modelAnswer.isAcceptableOrUnknown(
          data['model_answer']!,
          _modelAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelAnswerMeta);
    }
    if (data.containsKey('source_reference_id')) {
      context.handle(
        _sourceReferenceIdMeta,
        sourceReferenceId.isAcceptableOrUnknown(
          data['source_reference_id']!,
          _sourceReferenceIdMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
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
    if (data.containsKey('fsrs_data')) {
      context.handle(
        _fsrsDataMeta,
        fsrsData.isAcceptableOrUnknown(data['fsrs_data']!, _fsrsDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IdentificationQuestionEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdentificationQuestionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      modelAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_answer'],
      )!,
      hints: $IdentificationQuestionsTable.$converterhints.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}hints'],
        )!,
      ),
      keywords: $IdentificationQuestionsTable.$converterkeywords.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}keywords'],
        )!,
      ),
      sourceReferenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference_id'],
      ),
      tags: $IdentificationQuestionsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      fsrsData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fsrs_data'],
      )!,
    );
  }

  @override
  $IdentificationQuestionsTable createAlias(String alias) {
    return $IdentificationQuestionsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterhints =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterkeywords =
      const StringListConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class IdentificationQuestionEntry extends DataClass
    implements Insertable<IdentificationQuestionEntry> {
  final String id;
  final String sourceId;
  final String question;
  final String modelAnswer;
  final List<String> hints;
  final List<String> keywords;
  final String? sourceReferenceId;
  final List<String> tags;
  final int difficulty;
  final int createdAt;
  final int updatedAt;
  final String fsrsData;
  const IdentificationQuestionEntry({
    required this.id,
    required this.sourceId,
    required this.question,
    required this.modelAnswer,
    required this.hints,
    required this.keywords,
    this.sourceReferenceId,
    required this.tags,
    required this.difficulty,
    required this.createdAt,
    required this.updatedAt,
    required this.fsrsData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['question'] = Variable<String>(question);
    map['model_answer'] = Variable<String>(modelAnswer);
    {
      map['hints'] = Variable<String>(
        $IdentificationQuestionsTable.$converterhints.toSql(hints),
      );
    }
    {
      map['keywords'] = Variable<String>(
        $IdentificationQuestionsTable.$converterkeywords.toSql(keywords),
      );
    }
    if (!nullToAbsent || sourceReferenceId != null) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId);
    }
    {
      map['tags'] = Variable<String>(
        $IdentificationQuestionsTable.$convertertags.toSql(tags),
      );
    }
    map['difficulty'] = Variable<int>(difficulty);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['fsrs_data'] = Variable<String>(fsrsData);
    return map;
  }

  IdentificationQuestionsCompanion toCompanion(bool nullToAbsent) {
    return IdentificationQuestionsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      question: Value(question),
      modelAnswer: Value(modelAnswer),
      hints: Value(hints),
      keywords: Value(keywords),
      sourceReferenceId: sourceReferenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReferenceId),
      tags: Value(tags),
      difficulty: Value(difficulty),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fsrsData: Value(fsrsData),
    );
  }

  factory IdentificationQuestionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdentificationQuestionEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      question: serializer.fromJson<String>(json['question']),
      modelAnswer: serializer.fromJson<String>(json['modelAnswer']),
      hints: serializer.fromJson<List<String>>(json['hints']),
      keywords: serializer.fromJson<List<String>>(json['keywords']),
      sourceReferenceId: serializer.fromJson<String?>(
        json['sourceReferenceId'],
      ),
      tags: serializer.fromJson<List<String>>(json['tags']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      fsrsData: serializer.fromJson<String>(json['fsrsData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'question': serializer.toJson<String>(question),
      'modelAnswer': serializer.toJson<String>(modelAnswer),
      'hints': serializer.toJson<List<String>>(hints),
      'keywords': serializer.toJson<List<String>>(keywords),
      'sourceReferenceId': serializer.toJson<String?>(sourceReferenceId),
      'tags': serializer.toJson<List<String>>(tags),
      'difficulty': serializer.toJson<int>(difficulty),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'fsrsData': serializer.toJson<String>(fsrsData),
    };
  }

  IdentificationQuestionEntry copyWith({
    String? id,
    String? sourceId,
    String? question,
    String? modelAnswer,
    List<String>? hints,
    List<String>? keywords,
    Value<String?> sourceReferenceId = const Value.absent(),
    List<String>? tags,
    int? difficulty,
    int? createdAt,
    int? updatedAt,
    String? fsrsData,
  }) => IdentificationQuestionEntry(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    question: question ?? this.question,
    modelAnswer: modelAnswer ?? this.modelAnswer,
    hints: hints ?? this.hints,
    keywords: keywords ?? this.keywords,
    sourceReferenceId: sourceReferenceId.present
        ? sourceReferenceId.value
        : this.sourceReferenceId,
    tags: tags ?? this.tags,
    difficulty: difficulty ?? this.difficulty,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fsrsData: fsrsData ?? this.fsrsData,
  );
  IdentificationQuestionEntry copyWithCompanion(
    IdentificationQuestionsCompanion data,
  ) {
    return IdentificationQuestionEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      question: data.question.present ? data.question.value : this.question,
      modelAnswer: data.modelAnswer.present
          ? data.modelAnswer.value
          : this.modelAnswer,
      hints: data.hints.present ? data.hints.value : this.hints,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      sourceReferenceId: data.sourceReferenceId.present
          ? data.sourceReferenceId.value
          : this.sourceReferenceId,
      tags: data.tags.present ? data.tags.value : this.tags,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fsrsData: data.fsrsData.present ? data.fsrsData.value : this.fsrsData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdentificationQuestionEntry(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('question: $question, ')
          ..write('modelAnswer: $modelAnswer, ')
          ..write('hints: $hints, ')
          ..write('keywords: $keywords, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    question,
    modelAnswer,
    hints,
    keywords,
    sourceReferenceId,
    tags,
    difficulty,
    createdAt,
    updatedAt,
    fsrsData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdentificationQuestionEntry &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.question == this.question &&
          other.modelAnswer == this.modelAnswer &&
          other.hints == this.hints &&
          other.keywords == this.keywords &&
          other.sourceReferenceId == this.sourceReferenceId &&
          other.tags == this.tags &&
          other.difficulty == this.difficulty &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fsrsData == this.fsrsData);
}

class IdentificationQuestionsCompanion
    extends UpdateCompanion<IdentificationQuestionEntry> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> question;
  final Value<String> modelAnswer;
  final Value<List<String>> hints;
  final Value<List<String>> keywords;
  final Value<String?> sourceReferenceId;
  final Value<List<String>> tags;
  final Value<int> difficulty;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> fsrsData;
  final Value<int> rowid;
  const IdentificationQuestionsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.question = const Value.absent(),
    this.modelAnswer = const Value.absent(),
    this.hints = const Value.absent(),
    this.keywords = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    this.tags = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdentificationQuestionsCompanion.insert({
    required String id,
    required String sourceId,
    required String question,
    required String modelAnswer,
    required List<String> hints,
    required List<String> keywords,
    this.sourceReferenceId = const Value.absent(),
    required List<String> tags,
    this.difficulty = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       question = Value(question),
       modelAnswer = Value(modelAnswer),
       hints = Value(hints),
       keywords = Value(keywords),
       tags = Value(tags),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<IdentificationQuestionEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? question,
    Expression<String>? modelAnswer,
    Expression<String>? hints,
    Expression<String>? keywords,
    Expression<String>? sourceReferenceId,
    Expression<String>? tags,
    Expression<int>? difficulty,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? fsrsData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (question != null) 'question': question,
      if (modelAnswer != null) 'model_answer': modelAnswer,
      if (hints != null) 'hints': hints,
      if (keywords != null) 'keywords': keywords,
      if (sourceReferenceId != null) 'source_reference_id': sourceReferenceId,
      if (tags != null) 'tags': tags,
      if (difficulty != null) 'difficulty': difficulty,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fsrsData != null) 'fsrs_data': fsrsData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdentificationQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? question,
    Value<String>? modelAnswer,
    Value<List<String>>? hints,
    Value<List<String>>? keywords,
    Value<String?>? sourceReferenceId,
    Value<List<String>>? tags,
    Value<int>? difficulty,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? fsrsData,
    Value<int>? rowid,
  }) {
    return IdentificationQuestionsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      question: question ?? this.question,
      modelAnswer: modelAnswer ?? this.modelAnswer,
      hints: hints ?? this.hints,
      keywords: keywords ?? this.keywords,
      sourceReferenceId: sourceReferenceId ?? this.sourceReferenceId,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fsrsData: fsrsData ?? this.fsrsData,
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
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (modelAnswer.present) {
      map['model_answer'] = Variable<String>(modelAnswer.value);
    }
    if (hints.present) {
      map['hints'] = Variable<String>(
        $IdentificationQuestionsTable.$converterhints.toSql(hints.value),
      );
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(
        $IdentificationQuestionsTable.$converterkeywords.toSql(keywords.value),
      );
    }
    if (sourceReferenceId.present) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $IdentificationQuestionsTable.$convertertags.toSql(tags.value),
      );
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (fsrsData.present) {
      map['fsrs_data'] = Variable<String>(fsrsData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdentificationQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('question: $question, ')
          ..write('modelAnswer: $modelAnswer, ')
          ..write('hints: $hints, ')
          ..write('keywords: $keywords, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImageOcclusionsTable extends ImageOcclusions
    with TableInfo<$ImageOcclusionsTable, ImageOcclusionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImageOcclusionsTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionsMeta = const VerificationMeta(
    'regions',
  );
  @override
  late final GeneratedColumn<String> regions = GeneratedColumn<String>(
    'regions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceReferenceIdMeta = const VerificationMeta(
    'sourceReferenceId',
  );
  @override
  late final GeneratedColumn<String> sourceReferenceId =
      GeneratedColumn<String>(
        'source_reference_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($ImageOcclusionsTable.$convertertags);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fsrsDataMeta = const VerificationMeta(
    'fsrsData',
  );
  @override
  late final GeneratedColumn<String> fsrsData = GeneratedColumn<String>(
    'fsrs_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    title,
    imagePath,
    regions,
    sourceReferenceId,
    tags,
    createdAt,
    updatedAt,
    fsrsData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'image_occlusions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImageOcclusionEntry> instance, {
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('regions')) {
      context.handle(
        _regionsMeta,
        regions.isAcceptableOrUnknown(data['regions']!, _regionsMeta),
      );
    }
    if (data.containsKey('source_reference_id')) {
      context.handle(
        _sourceReferenceIdMeta,
        sourceReferenceId.isAcceptableOrUnknown(
          data['source_reference_id']!,
          _sourceReferenceIdMeta,
        ),
      );
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
    if (data.containsKey('fsrs_data')) {
      context.handle(
        _fsrsDataMeta,
        fsrsData.isAcceptableOrUnknown(data['fsrs_data']!, _fsrsDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImageOcclusionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImageOcclusionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      regions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regions'],
      )!,
      sourceReferenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference_id'],
      ),
      tags: $ImageOcclusionsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      fsrsData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fsrs_data'],
      )!,
    );
  }

  @override
  $ImageOcclusionsTable createAlias(String alias) {
    return $ImageOcclusionsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class ImageOcclusionEntry extends DataClass
    implements Insertable<ImageOcclusionEntry> {
  final String id;
  final String sourceId;
  final String title;
  final String imagePath;
  final String regions;
  final String? sourceReferenceId;
  final List<String> tags;
  final int createdAt;
  final int updatedAt;
  final String fsrsData;
  const ImageOcclusionEntry({
    required this.id,
    required this.sourceId,
    required this.title,
    required this.imagePath,
    required this.regions,
    this.sourceReferenceId,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.fsrsData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['title'] = Variable<String>(title);
    map['image_path'] = Variable<String>(imagePath);
    map['regions'] = Variable<String>(regions);
    if (!nullToAbsent || sourceReferenceId != null) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId);
    }
    {
      map['tags'] = Variable<String>(
        $ImageOcclusionsTable.$convertertags.toSql(tags),
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['fsrs_data'] = Variable<String>(fsrsData);
    return map;
  }

  ImageOcclusionsCompanion toCompanion(bool nullToAbsent) {
    return ImageOcclusionsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      title: Value(title),
      imagePath: Value(imagePath),
      regions: Value(regions),
      sourceReferenceId: sourceReferenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReferenceId),
      tags: Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fsrsData: Value(fsrsData),
    );
  }

  factory ImageOcclusionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImageOcclusionEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      title: serializer.fromJson<String>(json['title']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      regions: serializer.fromJson<String>(json['regions']),
      sourceReferenceId: serializer.fromJson<String?>(
        json['sourceReferenceId'],
      ),
      tags: serializer.fromJson<List<String>>(json['tags']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      fsrsData: serializer.fromJson<String>(json['fsrsData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'title': serializer.toJson<String>(title),
      'imagePath': serializer.toJson<String>(imagePath),
      'regions': serializer.toJson<String>(regions),
      'sourceReferenceId': serializer.toJson<String?>(sourceReferenceId),
      'tags': serializer.toJson<List<String>>(tags),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'fsrsData': serializer.toJson<String>(fsrsData),
    };
  }

  ImageOcclusionEntry copyWith({
    String? id,
    String? sourceId,
    String? title,
    String? imagePath,
    String? regions,
    Value<String?> sourceReferenceId = const Value.absent(),
    List<String>? tags,
    int? createdAt,
    int? updatedAt,
    String? fsrsData,
  }) => ImageOcclusionEntry(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    title: title ?? this.title,
    imagePath: imagePath ?? this.imagePath,
    regions: regions ?? this.regions,
    sourceReferenceId: sourceReferenceId.present
        ? sourceReferenceId.value
        : this.sourceReferenceId,
    tags: tags ?? this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fsrsData: fsrsData ?? this.fsrsData,
  );
  ImageOcclusionEntry copyWithCompanion(ImageOcclusionsCompanion data) {
    return ImageOcclusionEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      title: data.title.present ? data.title.value : this.title,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      regions: data.regions.present ? data.regions.value : this.regions,
      sourceReferenceId: data.sourceReferenceId.present
          ? data.sourceReferenceId.value
          : this.sourceReferenceId,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fsrsData: data.fsrsData.present ? data.fsrsData.value : this.fsrsData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImageOcclusionEntry(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('imagePath: $imagePath, ')
          ..write('regions: $regions, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    title,
    imagePath,
    regions,
    sourceReferenceId,
    tags,
    createdAt,
    updatedAt,
    fsrsData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImageOcclusionEntry &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.title == this.title &&
          other.imagePath == this.imagePath &&
          other.regions == this.regions &&
          other.sourceReferenceId == this.sourceReferenceId &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fsrsData == this.fsrsData);
}

class ImageOcclusionsCompanion extends UpdateCompanion<ImageOcclusionEntry> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> title;
  final Value<String> imagePath;
  final Value<String> regions;
  final Value<String?> sourceReferenceId;
  final Value<List<String>> tags;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> fsrsData;
  final Value<int> rowid;
  const ImageOcclusionsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.title = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.regions = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImageOcclusionsCompanion.insert({
    required String id,
    required String sourceId,
    required String title,
    required String imagePath,
    this.regions = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    required List<String> tags,
    required int createdAt,
    required int updatedAt,
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       title = Value(title),
       imagePath = Value(imagePath),
       tags = Value(tags),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ImageOcclusionEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? title,
    Expression<String>? imagePath,
    Expression<String>? regions,
    Expression<String>? sourceReferenceId,
    Expression<String>? tags,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? fsrsData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (title != null) 'title': title,
      if (imagePath != null) 'image_path': imagePath,
      if (regions != null) 'regions': regions,
      if (sourceReferenceId != null) 'source_reference_id': sourceReferenceId,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fsrsData != null) 'fsrs_data': fsrsData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImageOcclusionsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? title,
    Value<String>? imagePath,
    Value<String>? regions,
    Value<String?>? sourceReferenceId,
    Value<List<String>>? tags,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? fsrsData,
    Value<int>? rowid,
  }) {
    return ImageOcclusionsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      regions: regions ?? this.regions,
      sourceReferenceId: sourceReferenceId ?? this.sourceReferenceId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fsrsData: fsrsData ?? this.fsrsData,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (regions.present) {
      map['regions'] = Variable<String>(regions.value);
    }
    if (sourceReferenceId.present) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $ImageOcclusionsTable.$convertertags.toSql(tags.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (fsrsData.present) {
      map['fsrs_data'] = Variable<String>(fsrsData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImageOcclusionsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('imagePath: $imagePath, ')
          ..write('regions: $regions, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MatchingSetsTable extends MatchingSets
    with TableInfo<$MatchingSetsTable, MatchingSetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchingSetsTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES sources (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pairsMeta = const VerificationMeta('pairs');
  @override
  late final GeneratedColumn<String> pairs = GeneratedColumn<String>(
    'pairs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceReferenceIdMeta = const VerificationMeta(
    'sourceReferenceId',
  );
  @override
  late final GeneratedColumn<String> sourceReferenceId =
      GeneratedColumn<String>(
        'source_reference_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($MatchingSetsTable.$convertertags);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fsrsDataMeta = const VerificationMeta(
    'fsrsData',
  );
  @override
  late final GeneratedColumn<String> fsrsData = GeneratedColumn<String>(
    'fsrs_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    title,
    instructions,
    pairs,
    sourceReferenceId,
    tags,
    createdAt,
    updatedAt,
    fsrsData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matching_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchingSetEntry> instance, {
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('pairs')) {
      context.handle(
        _pairsMeta,
        pairs.isAcceptableOrUnknown(data['pairs']!, _pairsMeta),
      );
    }
    if (data.containsKey('source_reference_id')) {
      context.handle(
        _sourceReferenceIdMeta,
        sourceReferenceId.isAcceptableOrUnknown(
          data['source_reference_id']!,
          _sourceReferenceIdMeta,
        ),
      );
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
    if (data.containsKey('fsrs_data')) {
      context.handle(
        _fsrsDataMeta,
        fsrsData.isAcceptableOrUnknown(data['fsrs_data']!, _fsrsDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchingSetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchingSetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      pairs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pairs'],
      )!,
      sourceReferenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference_id'],
      ),
      tags: $MatchingSetsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      fsrsData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fsrs_data'],
      )!,
    );
  }

  @override
  $MatchingSetsTable createAlias(String alias) {
    return $MatchingSetsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class MatchingSetEntry extends DataClass
    implements Insertable<MatchingSetEntry> {
  final String id;
  final String sourceId;
  final String title;
  final String? instructions;
  final String pairs;
  final String? sourceReferenceId;
  final List<String> tags;
  final int createdAt;
  final int updatedAt;
  final String fsrsData;
  const MatchingSetEntry({
    required this.id,
    required this.sourceId,
    required this.title,
    this.instructions,
    required this.pairs,
    this.sourceReferenceId,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.fsrsData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['pairs'] = Variable<String>(pairs);
    if (!nullToAbsent || sourceReferenceId != null) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId);
    }
    {
      map['tags'] = Variable<String>(
        $MatchingSetsTable.$convertertags.toSql(tags),
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['fsrs_data'] = Variable<String>(fsrsData);
    return map;
  }

  MatchingSetsCompanion toCompanion(bool nullToAbsent) {
    return MatchingSetsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      title: Value(title),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      pairs: Value(pairs),
      sourceReferenceId: sourceReferenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReferenceId),
      tags: Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fsrsData: Value(fsrsData),
    );
  }

  factory MatchingSetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchingSetEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      title: serializer.fromJson<String>(json['title']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      pairs: serializer.fromJson<String>(json['pairs']),
      sourceReferenceId: serializer.fromJson<String?>(
        json['sourceReferenceId'],
      ),
      tags: serializer.fromJson<List<String>>(json['tags']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      fsrsData: serializer.fromJson<String>(json['fsrsData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'title': serializer.toJson<String>(title),
      'instructions': serializer.toJson<String?>(instructions),
      'pairs': serializer.toJson<String>(pairs),
      'sourceReferenceId': serializer.toJson<String?>(sourceReferenceId),
      'tags': serializer.toJson<List<String>>(tags),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'fsrsData': serializer.toJson<String>(fsrsData),
    };
  }

  MatchingSetEntry copyWith({
    String? id,
    String? sourceId,
    String? title,
    Value<String?> instructions = const Value.absent(),
    String? pairs,
    Value<String?> sourceReferenceId = const Value.absent(),
    List<String>? tags,
    int? createdAt,
    int? updatedAt,
    String? fsrsData,
  }) => MatchingSetEntry(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    title: title ?? this.title,
    instructions: instructions.present ? instructions.value : this.instructions,
    pairs: pairs ?? this.pairs,
    sourceReferenceId: sourceReferenceId.present
        ? sourceReferenceId.value
        : this.sourceReferenceId,
    tags: tags ?? this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fsrsData: fsrsData ?? this.fsrsData,
  );
  MatchingSetEntry copyWithCompanion(MatchingSetsCompanion data) {
    return MatchingSetEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      title: data.title.present ? data.title.value : this.title,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      pairs: data.pairs.present ? data.pairs.value : this.pairs,
      sourceReferenceId: data.sourceReferenceId.present
          ? data.sourceReferenceId.value
          : this.sourceReferenceId,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fsrsData: data.fsrsData.present ? data.fsrsData.value : this.fsrsData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchingSetEntry(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('instructions: $instructions, ')
          ..write('pairs: $pairs, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    title,
    instructions,
    pairs,
    sourceReferenceId,
    tags,
    createdAt,
    updatedAt,
    fsrsData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchingSetEntry &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.title == this.title &&
          other.instructions == this.instructions &&
          other.pairs == this.pairs &&
          other.sourceReferenceId == this.sourceReferenceId &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fsrsData == this.fsrsData);
}

class MatchingSetsCompanion extends UpdateCompanion<MatchingSetEntry> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> title;
  final Value<String?> instructions;
  final Value<String> pairs;
  final Value<String?> sourceReferenceId;
  final Value<List<String>> tags;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> fsrsData;
  final Value<int> rowid;
  const MatchingSetsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.title = const Value.absent(),
    this.instructions = const Value.absent(),
    this.pairs = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MatchingSetsCompanion.insert({
    required String id,
    required String sourceId,
    required String title,
    this.instructions = const Value.absent(),
    this.pairs = const Value.absent(),
    this.sourceReferenceId = const Value.absent(),
    required List<String> tags,
    required int createdAt,
    required int updatedAt,
    this.fsrsData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       title = Value(title),
       tags = Value(tags),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MatchingSetEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? title,
    Expression<String>? instructions,
    Expression<String>? pairs,
    Expression<String>? sourceReferenceId,
    Expression<String>? tags,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? fsrsData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (title != null) 'title': title,
      if (instructions != null) 'instructions': instructions,
      if (pairs != null) 'pairs': pairs,
      if (sourceReferenceId != null) 'source_reference_id': sourceReferenceId,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fsrsData != null) 'fsrs_data': fsrsData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MatchingSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? title,
    Value<String?>? instructions,
    Value<String>? pairs,
    Value<String?>? sourceReferenceId,
    Value<List<String>>? tags,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? fsrsData,
    Value<int>? rowid,
  }) {
    return MatchingSetsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      instructions: instructions ?? this.instructions,
      pairs: pairs ?? this.pairs,
      sourceReferenceId: sourceReferenceId ?? this.sourceReferenceId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fsrsData: fsrsData ?? this.fsrsData,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (pairs.present) {
      map['pairs'] = Variable<String>(pairs.value);
    }
    if (sourceReferenceId.present) {
      map['source_reference_id'] = Variable<String>(sourceReferenceId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $MatchingSetsTable.$convertertags.toSql(tags.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (fsrsData.present) {
      map['fsrs_data'] = Variable<String>(fsrsData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchingSetsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('instructions: $instructions, ')
          ..write('pairs: $pairs, ')
          ..write('sourceReferenceId: $sourceReferenceId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fsrsData: $fsrsData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceReferencesTable extends SourceReferences
    with TableInfo<$SourceReferencesTable, SourceReferenceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceReferencesTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES sources (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReferenceType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ReferenceType>($SourceReferencesTable.$convertertype);
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
  static const VerificationMeta _startOffsetMeta = const VerificationMeta(
    'startOffset',
  );
  @override
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
    'start_offset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endOffsetMeta = const VerificationMeta(
    'endOffset',
  );
  @override
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
    'end_offset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _matchedTextMeta = const VerificationMeta(
    'matchedText',
  );
  @override
  late final GeneratedColumn<String> matchedText = GeneratedColumn<String>(
    'matched_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimestampMeta = const VerificationMeta(
    'startTimestamp',
  );
  @override
  late final GeneratedColumn<double> startTimestamp = GeneratedColumn<double>(
    'start_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimestampMeta = const VerificationMeta(
    'endTimestamp',
  );
  @override
  late final GeneratedColumn<double> endTimestamp = GeneratedColumn<double>(
    'end_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionXMeta = const VerificationMeta(
    'regionX',
  );
  @override
  late final GeneratedColumn<double> regionX = GeneratedColumn<double>(
    'region_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionYMeta = const VerificationMeta(
    'regionY',
  );
  @override
  late final GeneratedColumn<double> regionY = GeneratedColumn<double>(
    'region_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionWidthMeta = const VerificationMeta(
    'regionWidth',
  );
  @override
  late final GeneratedColumn<double> regionWidth = GeneratedColumn<double>(
    'region_width',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionHeightMeta = const VerificationMeta(
    'regionHeight',
  );
  @override
  late final GeneratedColumn<double> regionHeight = GeneratedColumn<double>(
    'region_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anchorMeta = const VerificationMeta('anchor');
  @override
  late final GeneratedColumn<String> anchor = GeneratedColumn<String>(
    'anchor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    type,
    pageNumber,
    startOffset,
    endOffset,
    matchedText,
    startTimestamp,
    endTimestamp,
    regionX,
    regionY,
    regionWidth,
    regionHeight,
    anchor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_references';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceReferenceEntry> instance, {
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
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('start_offset')) {
      context.handle(
        _startOffsetMeta,
        startOffset.isAcceptableOrUnknown(
          data['start_offset']!,
          _startOffsetMeta,
        ),
      );
    }
    if (data.containsKey('end_offset')) {
      context.handle(
        _endOffsetMeta,
        endOffset.isAcceptableOrUnknown(data['end_offset']!, _endOffsetMeta),
      );
    }
    if (data.containsKey('matched_text')) {
      context.handle(
        _matchedTextMeta,
        matchedText.isAcceptableOrUnknown(
          data['matched_text']!,
          _matchedTextMeta,
        ),
      );
    }
    if (data.containsKey('start_timestamp')) {
      context.handle(
        _startTimestampMeta,
        startTimestamp.isAcceptableOrUnknown(
          data['start_timestamp']!,
          _startTimestampMeta,
        ),
      );
    }
    if (data.containsKey('end_timestamp')) {
      context.handle(
        _endTimestampMeta,
        endTimestamp.isAcceptableOrUnknown(
          data['end_timestamp']!,
          _endTimestampMeta,
        ),
      );
    }
    if (data.containsKey('region_x')) {
      context.handle(
        _regionXMeta,
        regionX.isAcceptableOrUnknown(data['region_x']!, _regionXMeta),
      );
    }
    if (data.containsKey('region_y')) {
      context.handle(
        _regionYMeta,
        regionY.isAcceptableOrUnknown(data['region_y']!, _regionYMeta),
      );
    }
    if (data.containsKey('region_width')) {
      context.handle(
        _regionWidthMeta,
        regionWidth.isAcceptableOrUnknown(
          data['region_width']!,
          _regionWidthMeta,
        ),
      );
    }
    if (data.containsKey('region_height')) {
      context.handle(
        _regionHeightMeta,
        regionHeight.isAcceptableOrUnknown(
          data['region_height']!,
          _regionHeightMeta,
        ),
      );
    }
    if (data.containsKey('anchor')) {
      context.handle(
        _anchorMeta,
        anchor.isAcceptableOrUnknown(data['anchor']!, _anchorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceReferenceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceReferenceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      type: $SourceReferencesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      ),
      startOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_offset'],
      ),
      endOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_offset'],
      ),
      matchedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matched_text'],
      ),
      startTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_timestamp'],
      ),
      endTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_timestamp'],
      ),
      regionX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}region_x'],
      ),
      regionY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}region_y'],
      ),
      regionWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}region_width'],
      ),
      regionHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}region_height'],
      ),
      anchor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor'],
      ),
    );
  }

  @override
  $SourceReferencesTable createAlias(String alias) {
    return $SourceReferencesTable(attachedDatabase, alias);
  }

  static TypeConverter<ReferenceType, int> $convertertype =
      const ReferenceTypeConverter();
}

class SourceReferenceEntry extends DataClass
    implements Insertable<SourceReferenceEntry> {
  final String id;
  final String sourceId;
  final ReferenceType type;
  final int? pageNumber;
  final int? startOffset;
  final int? endOffset;
  final String? matchedText;
  final double? startTimestamp;
  final double? endTimestamp;
  final double? regionX;
  final double? regionY;
  final double? regionWidth;
  final double? regionHeight;
  final String? anchor;
  const SourceReferenceEntry({
    required this.id,
    required this.sourceId,
    required this.type,
    this.pageNumber,
    this.startOffset,
    this.endOffset,
    this.matchedText,
    this.startTimestamp,
    this.endTimestamp,
    this.regionX,
    this.regionY,
    this.regionWidth,
    this.regionHeight,
    this.anchor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    {
      map['type'] = Variable<int>(
        $SourceReferencesTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || pageNumber != null) {
      map['page_number'] = Variable<int>(pageNumber);
    }
    if (!nullToAbsent || startOffset != null) {
      map['start_offset'] = Variable<int>(startOffset);
    }
    if (!nullToAbsent || endOffset != null) {
      map['end_offset'] = Variable<int>(endOffset);
    }
    if (!nullToAbsent || matchedText != null) {
      map['matched_text'] = Variable<String>(matchedText);
    }
    if (!nullToAbsent || startTimestamp != null) {
      map['start_timestamp'] = Variable<double>(startTimestamp);
    }
    if (!nullToAbsent || endTimestamp != null) {
      map['end_timestamp'] = Variable<double>(endTimestamp);
    }
    if (!nullToAbsent || regionX != null) {
      map['region_x'] = Variable<double>(regionX);
    }
    if (!nullToAbsent || regionY != null) {
      map['region_y'] = Variable<double>(regionY);
    }
    if (!nullToAbsent || regionWidth != null) {
      map['region_width'] = Variable<double>(regionWidth);
    }
    if (!nullToAbsent || regionHeight != null) {
      map['region_height'] = Variable<double>(regionHeight);
    }
    if (!nullToAbsent || anchor != null) {
      map['anchor'] = Variable<String>(anchor);
    }
    return map;
  }

  SourceReferencesCompanion toCompanion(bool nullToAbsent) {
    return SourceReferencesCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      type: Value(type),
      pageNumber: pageNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumber),
      startOffset: startOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(startOffset),
      endOffset: endOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(endOffset),
      matchedText: matchedText == null && nullToAbsent
          ? const Value.absent()
          : Value(matchedText),
      startTimestamp: startTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(startTimestamp),
      endTimestamp: endTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(endTimestamp),
      regionX: regionX == null && nullToAbsent
          ? const Value.absent()
          : Value(regionX),
      regionY: regionY == null && nullToAbsent
          ? const Value.absent()
          : Value(regionY),
      regionWidth: regionWidth == null && nullToAbsent
          ? const Value.absent()
          : Value(regionWidth),
      regionHeight: regionHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(regionHeight),
      anchor: anchor == null && nullToAbsent
          ? const Value.absent()
          : Value(anchor),
    );
  }

  factory SourceReferenceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceReferenceEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      type: serializer.fromJson<ReferenceType>(json['type']),
      pageNumber: serializer.fromJson<int?>(json['pageNumber']),
      startOffset: serializer.fromJson<int?>(json['startOffset']),
      endOffset: serializer.fromJson<int?>(json['endOffset']),
      matchedText: serializer.fromJson<String?>(json['matchedText']),
      startTimestamp: serializer.fromJson<double?>(json['startTimestamp']),
      endTimestamp: serializer.fromJson<double?>(json['endTimestamp']),
      regionX: serializer.fromJson<double?>(json['regionX']),
      regionY: serializer.fromJson<double?>(json['regionY']),
      regionWidth: serializer.fromJson<double?>(json['regionWidth']),
      regionHeight: serializer.fromJson<double?>(json['regionHeight']),
      anchor: serializer.fromJson<String?>(json['anchor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'type': serializer.toJson<ReferenceType>(type),
      'pageNumber': serializer.toJson<int?>(pageNumber),
      'startOffset': serializer.toJson<int?>(startOffset),
      'endOffset': serializer.toJson<int?>(endOffset),
      'matchedText': serializer.toJson<String?>(matchedText),
      'startTimestamp': serializer.toJson<double?>(startTimestamp),
      'endTimestamp': serializer.toJson<double?>(endTimestamp),
      'regionX': serializer.toJson<double?>(regionX),
      'regionY': serializer.toJson<double?>(regionY),
      'regionWidth': serializer.toJson<double?>(regionWidth),
      'regionHeight': serializer.toJson<double?>(regionHeight),
      'anchor': serializer.toJson<String?>(anchor),
    };
  }

  SourceReferenceEntry copyWith({
    String? id,
    String? sourceId,
    ReferenceType? type,
    Value<int?> pageNumber = const Value.absent(),
    Value<int?> startOffset = const Value.absent(),
    Value<int?> endOffset = const Value.absent(),
    Value<String?> matchedText = const Value.absent(),
    Value<double?> startTimestamp = const Value.absent(),
    Value<double?> endTimestamp = const Value.absent(),
    Value<double?> regionX = const Value.absent(),
    Value<double?> regionY = const Value.absent(),
    Value<double?> regionWidth = const Value.absent(),
    Value<double?> regionHeight = const Value.absent(),
    Value<String?> anchor = const Value.absent(),
  }) => SourceReferenceEntry(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    type: type ?? this.type,
    pageNumber: pageNumber.present ? pageNumber.value : this.pageNumber,
    startOffset: startOffset.present ? startOffset.value : this.startOffset,
    endOffset: endOffset.present ? endOffset.value : this.endOffset,
    matchedText: matchedText.present ? matchedText.value : this.matchedText,
    startTimestamp: startTimestamp.present
        ? startTimestamp.value
        : this.startTimestamp,
    endTimestamp: endTimestamp.present ? endTimestamp.value : this.endTimestamp,
    regionX: regionX.present ? regionX.value : this.regionX,
    regionY: regionY.present ? regionY.value : this.regionY,
    regionWidth: regionWidth.present ? regionWidth.value : this.regionWidth,
    regionHeight: regionHeight.present ? regionHeight.value : this.regionHeight,
    anchor: anchor.present ? anchor.value : this.anchor,
  );
  SourceReferenceEntry copyWithCompanion(SourceReferencesCompanion data) {
    return SourceReferenceEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      type: data.type.present ? data.type.value : this.type,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      startOffset: data.startOffset.present
          ? data.startOffset.value
          : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      matchedText: data.matchedText.present
          ? data.matchedText.value
          : this.matchedText,
      startTimestamp: data.startTimestamp.present
          ? data.startTimestamp.value
          : this.startTimestamp,
      endTimestamp: data.endTimestamp.present
          ? data.endTimestamp.value
          : this.endTimestamp,
      regionX: data.regionX.present ? data.regionX.value : this.regionX,
      regionY: data.regionY.present ? data.regionY.value : this.regionY,
      regionWidth: data.regionWidth.present
          ? data.regionWidth.value
          : this.regionWidth,
      regionHeight: data.regionHeight.present
          ? data.regionHeight.value
          : this.regionHeight,
      anchor: data.anchor.present ? data.anchor.value : this.anchor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceReferenceEntry(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('type: $type, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('matchedText: $matchedText, ')
          ..write('startTimestamp: $startTimestamp, ')
          ..write('endTimestamp: $endTimestamp, ')
          ..write('regionX: $regionX, ')
          ..write('regionY: $regionY, ')
          ..write('regionWidth: $regionWidth, ')
          ..write('regionHeight: $regionHeight, ')
          ..write('anchor: $anchor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    type,
    pageNumber,
    startOffset,
    endOffset,
    matchedText,
    startTimestamp,
    endTimestamp,
    regionX,
    regionY,
    regionWidth,
    regionHeight,
    anchor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceReferenceEntry &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.type == this.type &&
          other.pageNumber == this.pageNumber &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.matchedText == this.matchedText &&
          other.startTimestamp == this.startTimestamp &&
          other.endTimestamp == this.endTimestamp &&
          other.regionX == this.regionX &&
          other.regionY == this.regionY &&
          other.regionWidth == this.regionWidth &&
          other.regionHeight == this.regionHeight &&
          other.anchor == this.anchor);
}

class SourceReferencesCompanion extends UpdateCompanion<SourceReferenceEntry> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<ReferenceType> type;
  final Value<int?> pageNumber;
  final Value<int?> startOffset;
  final Value<int?> endOffset;
  final Value<String?> matchedText;
  final Value<double?> startTimestamp;
  final Value<double?> endTimestamp;
  final Value<double?> regionX;
  final Value<double?> regionY;
  final Value<double?> regionWidth;
  final Value<double?> regionHeight;
  final Value<String?> anchor;
  final Value<int> rowid;
  const SourceReferencesCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.type = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.matchedText = const Value.absent(),
    this.startTimestamp = const Value.absent(),
    this.endTimestamp = const Value.absent(),
    this.regionX = const Value.absent(),
    this.regionY = const Value.absent(),
    this.regionWidth = const Value.absent(),
    this.regionHeight = const Value.absent(),
    this.anchor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceReferencesCompanion.insert({
    required String id,
    required String sourceId,
    required ReferenceType type,
    this.pageNumber = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.matchedText = const Value.absent(),
    this.startTimestamp = const Value.absent(),
    this.endTimestamp = const Value.absent(),
    this.regionX = const Value.absent(),
    this.regionY = const Value.absent(),
    this.regionWidth = const Value.absent(),
    this.regionHeight = const Value.absent(),
    this.anchor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       type = Value(type);
  static Insertable<SourceReferenceEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<int>? type,
    Expression<int>? pageNumber,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<String>? matchedText,
    Expression<double>? startTimestamp,
    Expression<double>? endTimestamp,
    Expression<double>? regionX,
    Expression<double>? regionY,
    Expression<double>? regionWidth,
    Expression<double>? regionHeight,
    Expression<String>? anchor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (type != null) 'type': type,
      if (pageNumber != null) 'page_number': pageNumber,
      if (startOffset != null) 'start_offset': startOffset,
      if (endOffset != null) 'end_offset': endOffset,
      if (matchedText != null) 'matched_text': matchedText,
      if (startTimestamp != null) 'start_timestamp': startTimestamp,
      if (endTimestamp != null) 'end_timestamp': endTimestamp,
      if (regionX != null) 'region_x': regionX,
      if (regionY != null) 'region_y': regionY,
      if (regionWidth != null) 'region_width': regionWidth,
      if (regionHeight != null) 'region_height': regionHeight,
      if (anchor != null) 'anchor': anchor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceReferencesCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<ReferenceType>? type,
    Value<int?>? pageNumber,
    Value<int?>? startOffset,
    Value<int?>? endOffset,
    Value<String?>? matchedText,
    Value<double?>? startTimestamp,
    Value<double?>? endTimestamp,
    Value<double?>? regionX,
    Value<double?>? regionY,
    Value<double?>? regionWidth,
    Value<double?>? regionHeight,
    Value<String?>? anchor,
    Value<int>? rowid,
  }) {
    return SourceReferencesCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      type: type ?? this.type,
      pageNumber: pageNumber ?? this.pageNumber,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      matchedText: matchedText ?? this.matchedText,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      regionX: regionX ?? this.regionX,
      regionY: regionY ?? this.regionY,
      regionWidth: regionWidth ?? this.regionWidth,
      regionHeight: regionHeight ?? this.regionHeight,
      anchor: anchor ?? this.anchor,
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
      map['type'] = Variable<int>(
        $SourceReferencesTable.$convertertype.toSql(type.value),
      );
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (startOffset.present) {
      map['start_offset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['end_offset'] = Variable<int>(endOffset.value);
    }
    if (matchedText.present) {
      map['matched_text'] = Variable<String>(matchedText.value);
    }
    if (startTimestamp.present) {
      map['start_timestamp'] = Variable<double>(startTimestamp.value);
    }
    if (endTimestamp.present) {
      map['end_timestamp'] = Variable<double>(endTimestamp.value);
    }
    if (regionX.present) {
      map['region_x'] = Variable<double>(regionX.value);
    }
    if (regionY.present) {
      map['region_y'] = Variable<double>(regionY.value);
    }
    if (regionWidth.present) {
      map['region_width'] = Variable<double>(regionWidth.value);
    }
    if (regionHeight.present) {
      map['region_height'] = Variable<double>(regionHeight.value);
    }
    if (anchor.present) {
      map['anchor'] = Variable<String>(anchor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceReferencesCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('type: $type, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('matchedText: $matchedText, ')
          ..write('startTimestamp: $startTimestamp, ')
          ..write('endTimestamp: $endTimestamp, ')
          ..write('regionX: $regionX, ')
          ..write('regionY: $regionY, ')
          ..write('regionWidth: $regionWidth, ')
          ..write('regionHeight: $regionHeight, ')
          ..write('anchor: $anchor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
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
  static const VerificationMeta _reviewDateTimeMeta = const VerificationMeta(
    'reviewDateTime',
  );
  @override
  late final GeneratedColumn<int> reviewDateTime = GeneratedColumn<int>(
    'review_date_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _elapsedDaysMeta = const VerificationMeta(
    'elapsedDays',
  );
  @override
  late final GeneratedColumn<int> elapsedDays = GeneratedColumn<int>(
    'elapsed_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardType,
    cardId,
    reviewDateTime,
    rating,
    scheduledDays,
    elapsedDays,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_cardTypeMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('review_date_time')) {
      context.handle(
        _reviewDateTimeMeta,
        reviewDateTime.isAcceptableOrUnknown(
          data['review_date_time']!,
          _reviewDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewDateTimeMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
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
    if (data.containsKey('elapsed_days')) {
      context.handle(
        _elapsedDaysMeta,
        elapsedDays.isAcceptableOrUnknown(
          data['elapsed_days']!,
          _elapsedDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedDaysMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      reviewDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_date_time'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      scheduledDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_days'],
      )!,
      elapsedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_days'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLogEntry extends DataClass implements Insertable<ReviewLogEntry> {
  final String id;
  final String cardType;
  final String cardId;
  final int reviewDateTime;
  final int rating;
  final int scheduledDays;
  final int elapsedDays;
  final int state;
  const ReviewLogEntry({
    required this.id,
    required this.cardType,
    required this.cardId,
    required this.reviewDateTime,
    required this.rating,
    required this.scheduledDays,
    required this.elapsedDays,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_type'] = Variable<String>(cardType);
    map['card_id'] = Variable<String>(cardId);
    map['review_date_time'] = Variable<int>(reviewDateTime);
    map['rating'] = Variable<int>(rating);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    map['elapsed_days'] = Variable<int>(elapsedDays);
    map['state'] = Variable<int>(state);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      cardType: Value(cardType),
      cardId: Value(cardId),
      reviewDateTime: Value(reviewDateTime),
      rating: Value(rating),
      scheduledDays: Value(scheduledDays),
      elapsedDays: Value(elapsedDays),
      state: Value(state),
    );
  }

  factory ReviewLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLogEntry(
      id: serializer.fromJson<String>(json['id']),
      cardType: serializer.fromJson<String>(json['cardType']),
      cardId: serializer.fromJson<String>(json['cardId']),
      reviewDateTime: serializer.fromJson<int>(json['reviewDateTime']),
      rating: serializer.fromJson<int>(json['rating']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      elapsedDays: serializer.fromJson<int>(json['elapsedDays']),
      state: serializer.fromJson<int>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardType': serializer.toJson<String>(cardType),
      'cardId': serializer.toJson<String>(cardId),
      'reviewDateTime': serializer.toJson<int>(reviewDateTime),
      'rating': serializer.toJson<int>(rating),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'elapsedDays': serializer.toJson<int>(elapsedDays),
      'state': serializer.toJson<int>(state),
    };
  }

  ReviewLogEntry copyWith({
    String? id,
    String? cardType,
    String? cardId,
    int? reviewDateTime,
    int? rating,
    int? scheduledDays,
    int? elapsedDays,
    int? state,
  }) => ReviewLogEntry(
    id: id ?? this.id,
    cardType: cardType ?? this.cardType,
    cardId: cardId ?? this.cardId,
    reviewDateTime: reviewDateTime ?? this.reviewDateTime,
    rating: rating ?? this.rating,
    scheduledDays: scheduledDays ?? this.scheduledDays,
    elapsedDays: elapsedDays ?? this.elapsedDays,
    state: state ?? this.state,
  );
  ReviewLogEntry copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLogEntry(
      id: data.id.present ? data.id.value : this.id,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      reviewDateTime: data.reviewDateTime.present
          ? data.reviewDateTime.value
          : this.reviewDateTime,
      rating: data.rating.present ? data.rating.value : this.rating,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      elapsedDays: data.elapsedDays.present
          ? data.elapsedDays.value
          : this.elapsedDays,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogEntry(')
          ..write('id: $id, ')
          ..write('cardType: $cardType, ')
          ..write('cardId: $cardId, ')
          ..write('reviewDateTime: $reviewDateTime, ')
          ..write('rating: $rating, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardType,
    cardId,
    reviewDateTime,
    rating,
    scheduledDays,
    elapsedDays,
    state,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLogEntry &&
          other.id == this.id &&
          other.cardType == this.cardType &&
          other.cardId == this.cardId &&
          other.reviewDateTime == this.reviewDateTime &&
          other.rating == this.rating &&
          other.scheduledDays == this.scheduledDays &&
          other.elapsedDays == this.elapsedDays &&
          other.state == this.state);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLogEntry> {
  final Value<String> id;
  final Value<String> cardType;
  final Value<String> cardId;
  final Value<int> reviewDateTime;
  final Value<int> rating;
  final Value<int> scheduledDays;
  final Value<int> elapsedDays;
  final Value<int> state;
  final Value<int> rowid;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.cardType = const Value.absent(),
    this.cardId = const Value.absent(),
    this.reviewDateTime = const Value.absent(),
    this.rating = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.elapsedDays = const Value.absent(),
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    required String id,
    required String cardType,
    required String cardId,
    required int reviewDateTime,
    required int rating,
    required int scheduledDays,
    required int elapsedDays,
    required int state,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardType = Value(cardType),
       cardId = Value(cardId),
       reviewDateTime = Value(reviewDateTime),
       rating = Value(rating),
       scheduledDays = Value(scheduledDays),
       elapsedDays = Value(elapsedDays),
       state = Value(state);
  static Insertable<ReviewLogEntry> custom({
    Expression<String>? id,
    Expression<String>? cardType,
    Expression<String>? cardId,
    Expression<int>? reviewDateTime,
    Expression<int>? rating,
    Expression<int>? scheduledDays,
    Expression<int>? elapsedDays,
    Expression<int>? state,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardType != null) 'card_type': cardType,
      if (cardId != null) 'card_id': cardId,
      if (reviewDateTime != null) 'review_date_time': reviewDateTime,
      if (rating != null) 'rating': rating,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (state != null) 'state': state,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? cardType,
    Value<String>? cardId,
    Value<int>? reviewDateTime,
    Value<int>? rating,
    Value<int>? scheduledDays,
    Value<int>? elapsedDays,
    Value<int>? state,
    Value<int>? rowid,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      cardType: cardType ?? this.cardType,
      cardId: cardId ?? this.cardId,
      reviewDateTime: reviewDateTime ?? this.reviewDateTime,
      rating: rating ?? this.rating,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      state: state ?? this.state,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (reviewDateTime.present) {
      map['review_date_time'] = Variable<int>(reviewDateTime.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<int>(scheduledDays.value);
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = Variable<int>(elapsedDays.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardType: $cardType, ')
          ..write('cardId: $cardId, ')
          ..write('reviewDateTime: $reviewDateTime, ')
          ..write('rating: $rating, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('state: $state, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _majorMeta = const VerificationMeta('major');
  @override
  late final GeneratedColumn<String> major = GeneratedColumn<String>(
    'major',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearLevelMeta = const VerificationMeta(
    'yearLevel',
  );
  @override
  late final GeneratedColumn<String> yearLevel = GeneratedColumn<String>(
    'year_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalStudyMinutesMeta = const VerificationMeta(
    'totalStudyMinutes',
  );
  @override
  late final GeneratedColumn<int> totalStudyMinutes = GeneratedColumn<int>(
    'total_study_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCardsReviewedMeta =
      const VerificationMeta('totalCardsReviewed');
  @override
  late final GeneratedColumn<int> totalCardsReviewed = GeneratedColumn<int>(
    'total_cards_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalQuizzesTakenMeta = const VerificationMeta(
    'totalQuizzesTaken',
  );
  @override
  late final GeneratedColumn<int> totalQuizzesTaken = GeneratedColumn<int>(
    'total_quizzes_taken',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _averageScoreMeta = const VerificationMeta(
    'averageScore',
  );
  @override
  late final GeneratedColumn<double> averageScore = GeneratedColumn<double>(
    'average_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creditsMeta = const VerificationMeta(
    'credits',
  );
  @override
  late final GeneratedColumn<int> credits = GeneratedColumn<int>(
    'credits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastActiveAtMeta = const VerificationMeta(
    'lastActiveAt',
  );
  @override
  late final GeneratedColumn<int> lastActiveAt = GeneratedColumn<int>(
    'last_active_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    avatarUrl,
    institution,
    major,
    yearLevel,
    totalStudyMinutes,
    totalCardsReviewed,
    totalQuizzesTaken,
    averageScore,
    credits,
    createdAt,
    lastActiveAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntry> instance, {
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    }
    if (data.containsKey('major')) {
      context.handle(
        _majorMeta,
        major.isAcceptableOrUnknown(data['major']!, _majorMeta),
      );
    }
    if (data.containsKey('year_level')) {
      context.handle(
        _yearLevelMeta,
        yearLevel.isAcceptableOrUnknown(data['year_level']!, _yearLevelMeta),
      );
    }
    if (data.containsKey('total_study_minutes')) {
      context.handle(
        _totalStudyMinutesMeta,
        totalStudyMinutes.isAcceptableOrUnknown(
          data['total_study_minutes']!,
          _totalStudyMinutesMeta,
        ),
      );
    }
    if (data.containsKey('total_cards_reviewed')) {
      context.handle(
        _totalCardsReviewedMeta,
        totalCardsReviewed.isAcceptableOrUnknown(
          data['total_cards_reviewed']!,
          _totalCardsReviewedMeta,
        ),
      );
    }
    if (data.containsKey('total_quizzes_taken')) {
      context.handle(
        _totalQuizzesTakenMeta,
        totalQuizzesTaken.isAcceptableOrUnknown(
          data['total_quizzes_taken']!,
          _totalQuizzesTakenMeta,
        ),
      );
    }
    if (data.containsKey('average_score')) {
      context.handle(
        _averageScoreMeta,
        averageScore.isAcceptableOrUnknown(
          data['average_score']!,
          _averageScoreMeta,
        ),
      );
    }
    if (data.containsKey('credits')) {
      context.handle(
        _creditsMeta,
        credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_active_at')) {
      context.handle(
        _lastActiveAtMeta,
        lastActiveAt.isAcceptableOrUnknown(
          data['last_active_at']!,
          _lastActiveAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastActiveAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
      major: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}major'],
      ),
      yearLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_level'],
      ),
      totalStudyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_study_minutes'],
      )!,
      totalCardsReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cards_reviewed'],
      )!,
      totalQuizzesTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_quizzes_taken'],
      )!,
      averageScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_score'],
      )!,
      credits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credits'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      lastActiveAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_active_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserEntry extends DataClass implements Insertable<UserEntry> {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;
  final String? institution;
  final String? major;
  final String? yearLevel;
  final int totalStudyMinutes;
  final int totalCardsReviewed;
  final int totalQuizzesTaken;
  final double averageScore;
  final int credits;
  final int createdAt;
  final int lastActiveAt;
  const UserEntry({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.institution,
    this.major,
    this.yearLevel,
    required this.totalStudyMinutes,
    required this.totalCardsReviewed,
    required this.totalQuizzesTaken,
    required this.averageScore,
    required this.credits,
    required this.createdAt,
    required this.lastActiveAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || major != null) {
      map['major'] = Variable<String>(major);
    }
    if (!nullToAbsent || yearLevel != null) {
      map['year_level'] = Variable<String>(yearLevel);
    }
    map['total_study_minutes'] = Variable<int>(totalStudyMinutes);
    map['total_cards_reviewed'] = Variable<int>(totalCardsReviewed);
    map['total_quizzes_taken'] = Variable<int>(totalQuizzesTaken);
    map['average_score'] = Variable<double>(averageScore);
    map['credits'] = Variable<int>(credits);
    map['created_at'] = Variable<int>(createdAt);
    map['last_active_at'] = Variable<int>(lastActiveAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      major: major == null && nullToAbsent
          ? const Value.absent()
          : Value(major),
      yearLevel: yearLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(yearLevel),
      totalStudyMinutes: Value(totalStudyMinutes),
      totalCardsReviewed: Value(totalCardsReviewed),
      totalQuizzesTaken: Value(totalQuizzesTaken),
      averageScore: Value(averageScore),
      credits: Value(credits),
      createdAt: Value(createdAt),
      lastActiveAt: Value(lastActiveAt),
    );
  }

  factory UserEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      institution: serializer.fromJson<String?>(json['institution']),
      major: serializer.fromJson<String?>(json['major']),
      yearLevel: serializer.fromJson<String?>(json['yearLevel']),
      totalStudyMinutes: serializer.fromJson<int>(json['totalStudyMinutes']),
      totalCardsReviewed: serializer.fromJson<int>(json['totalCardsReviewed']),
      totalQuizzesTaken: serializer.fromJson<int>(json['totalQuizzesTaken']),
      averageScore: serializer.fromJson<double>(json['averageScore']),
      credits: serializer.fromJson<int>(json['credits']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastActiveAt: serializer.fromJson<int>(json['lastActiveAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'institution': serializer.toJson<String?>(institution),
      'major': serializer.toJson<String?>(major),
      'yearLevel': serializer.toJson<String?>(yearLevel),
      'totalStudyMinutes': serializer.toJson<int>(totalStudyMinutes),
      'totalCardsReviewed': serializer.toJson<int>(totalCardsReviewed),
      'totalQuizzesTaken': serializer.toJson<int>(totalQuizzesTaken),
      'averageScore': serializer.toJson<double>(averageScore),
      'credits': serializer.toJson<int>(credits),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastActiveAt': serializer.toJson<int>(lastActiveAt),
    };
  }

  UserEntry copyWith({
    String? id,
    String? name,
    Value<String?> email = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> institution = const Value.absent(),
    Value<String?> major = const Value.absent(),
    Value<String?> yearLevel = const Value.absent(),
    int? totalStudyMinutes,
    int? totalCardsReviewed,
    int? totalQuizzesTaken,
    double? averageScore,
    int? credits,
    int? createdAt,
    int? lastActiveAt,
  }) => UserEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email.present ? email.value : this.email,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    institution: institution.present ? institution.value : this.institution,
    major: major.present ? major.value : this.major,
    yearLevel: yearLevel.present ? yearLevel.value : this.yearLevel,
    totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
    totalCardsReviewed: totalCardsReviewed ?? this.totalCardsReviewed,
    totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
    averageScore: averageScore ?? this.averageScore,
    credits: credits ?? this.credits,
    createdAt: createdAt ?? this.createdAt,
    lastActiveAt: lastActiveAt ?? this.lastActiveAt,
  );
  UserEntry copyWithCompanion(UsersCompanion data) {
    return UserEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
      major: data.major.present ? data.major.value : this.major,
      yearLevel: data.yearLevel.present ? data.yearLevel.value : this.yearLevel,
      totalStudyMinutes: data.totalStudyMinutes.present
          ? data.totalStudyMinutes.value
          : this.totalStudyMinutes,
      totalCardsReviewed: data.totalCardsReviewed.present
          ? data.totalCardsReviewed.value
          : this.totalCardsReviewed,
      totalQuizzesTaken: data.totalQuizzesTaken.present
          ? data.totalQuizzesTaken.value
          : this.totalQuizzesTaken,
      averageScore: data.averageScore.present
          ? data.averageScore.value
          : this.averageScore,
      credits: data.credits.present ? data.credits.value : this.credits,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastActiveAt: data.lastActiveAt.present
          ? data.lastActiveAt.value
          : this.lastActiveAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('institution: $institution, ')
          ..write('major: $major, ')
          ..write('yearLevel: $yearLevel, ')
          ..write('totalStudyMinutes: $totalStudyMinutes, ')
          ..write('totalCardsReviewed: $totalCardsReviewed, ')
          ..write('totalQuizzesTaken: $totalQuizzesTaken, ')
          ..write('averageScore: $averageScore, ')
          ..write('credits: $credits, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastActiveAt: $lastActiveAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    avatarUrl,
    institution,
    major,
    yearLevel,
    totalStudyMinutes,
    totalCardsReviewed,
    totalQuizzesTaken,
    averageScore,
    credits,
    createdAt,
    lastActiveAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl &&
          other.institution == this.institution &&
          other.major == this.major &&
          other.yearLevel == this.yearLevel &&
          other.totalStudyMinutes == this.totalStudyMinutes &&
          other.totalCardsReviewed == this.totalCardsReviewed &&
          other.totalQuizzesTaken == this.totalQuizzesTaken &&
          other.averageScore == this.averageScore &&
          other.credits == this.credits &&
          other.createdAt == this.createdAt &&
          other.lastActiveAt == this.lastActiveAt);
}

class UsersCompanion extends UpdateCompanion<UserEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> email;
  final Value<String?> avatarUrl;
  final Value<String?> institution;
  final Value<String?> major;
  final Value<String?> yearLevel;
  final Value<int> totalStudyMinutes;
  final Value<int> totalCardsReviewed;
  final Value<int> totalQuizzesTaken;
  final Value<double> averageScore;
  final Value<int> credits;
  final Value<int> createdAt;
  final Value<int> lastActiveAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.institution = const Value.absent(),
    this.major = const Value.absent(),
    this.yearLevel = const Value.absent(),
    this.totalStudyMinutes = const Value.absent(),
    this.totalCardsReviewed = const Value.absent(),
    this.totalQuizzesTaken = const Value.absent(),
    this.averageScore = const Value.absent(),
    this.credits = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastActiveAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.institution = const Value.absent(),
    this.major = const Value.absent(),
    this.yearLevel = const Value.absent(),
    this.totalStudyMinutes = const Value.absent(),
    this.totalCardsReviewed = const Value.absent(),
    this.totalQuizzesTaken = const Value.absent(),
    this.averageScore = const Value.absent(),
    this.credits = const Value.absent(),
    required int createdAt,
    required int lastActiveAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       lastActiveAt = Value(lastActiveAt);
  static Insertable<UserEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? avatarUrl,
    Expression<String>? institution,
    Expression<String>? major,
    Expression<String>? yearLevel,
    Expression<int>? totalStudyMinutes,
    Expression<int>? totalCardsReviewed,
    Expression<int>? totalQuizzesTaken,
    Expression<double>? averageScore,
    Expression<int>? credits,
    Expression<int>? createdAt,
    Expression<int>? lastActiveAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (institution != null) 'institution': institution,
      if (major != null) 'major': major,
      if (yearLevel != null) 'year_level': yearLevel,
      if (totalStudyMinutes != null) 'total_study_minutes': totalStudyMinutes,
      if (totalCardsReviewed != null)
        'total_cards_reviewed': totalCardsReviewed,
      if (totalQuizzesTaken != null) 'total_quizzes_taken': totalQuizzesTaken,
      if (averageScore != null) 'average_score': averageScore,
      if (credits != null) 'credits': credits,
      if (createdAt != null) 'created_at': createdAt,
      if (lastActiveAt != null) 'last_active_at': lastActiveAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? email,
    Value<String?>? avatarUrl,
    Value<String?>? institution,
    Value<String?>? major,
    Value<String?>? yearLevel,
    Value<int>? totalStudyMinutes,
    Value<int>? totalCardsReviewed,
    Value<int>? totalQuizzesTaken,
    Value<double>? averageScore,
    Value<int>? credits,
    Value<int>? createdAt,
    Value<int>? lastActiveAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      institution: institution ?? this.institution,
      major: major ?? this.major,
      yearLevel: yearLevel ?? this.yearLevel,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      totalCardsReviewed: totalCardsReviewed ?? this.totalCardsReviewed,
      totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
      averageScore: averageScore ?? this.averageScore,
      credits: credits ?? this.credits,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (major.present) {
      map['major'] = Variable<String>(major.value);
    }
    if (yearLevel.present) {
      map['year_level'] = Variable<String>(yearLevel.value);
    }
    if (totalStudyMinutes.present) {
      map['total_study_minutes'] = Variable<int>(totalStudyMinutes.value);
    }
    if (totalCardsReviewed.present) {
      map['total_cards_reviewed'] = Variable<int>(totalCardsReviewed.value);
    }
    if (totalQuizzesTaken.present) {
      map['total_quizzes_taken'] = Variable<int>(totalQuizzesTaken.value);
    }
    if (averageScore.present) {
      map['average_score'] = Variable<double>(averageScore.value);
    }
    if (credits.present) {
      map['credits'] = Variable<int>(credits.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastActiveAt.present) {
      map['last_active_at'] = Variable<int>(lastActiveAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('institution: $institution, ')
          ..write('major: $major, ')
          ..write('yearLevel: $yearLevel, ')
          ..write('totalStudyMinutes: $totalStudyMinutes, ')
          ..write('totalCardsReviewed: $totalCardsReviewed, ')
          ..write('totalQuizzesTaken: $totalQuizzesTaken, ')
          ..write('averageScore: $averageScore, ')
          ..write('credits: $credits, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastActiveAt: $lastActiveAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $FlashcardsTable flashcards = $FlashcardsTable(this);
  late final $QuizQuestionsTable quizQuestions = $QuizQuestionsTable(this);
  late final $IdentificationQuestionsTable identificationQuestions =
      $IdentificationQuestionsTable(this);
  late final $ImageOcclusionsTable imageOcclusions = $ImageOcclusionsTable(
    this,
  );
  late final $MatchingSetsTable matchingSets = $MatchingSetsTable(this);
  late final $SourceReferencesTable sourceReferences = $SourceReferencesTable(
    this,
  );
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $UsersTable users = $UsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sources,
    flashcards,
    quizQuestions,
    identificationQuestions,
    imageOcclusions,
    matchingSets,
    sourceReferences,
    reviewLogs,
    users,
  ];
}

typedef $$SourcesTableCreateCompanionBuilder =
    SourcesCompanion Function({
      required String id,
      required String title,
      required SourceType type,
      required int createdAt,
      required int lastAccessedAt,
      Value<String?> filePath,
      Value<String?> url,
      Value<String?> content,
      Value<int?> sizeBytes,
      Value<int?> durationSeconds,
      Value<String?> thumbnailPath,
      required List<String> tags,
      Value<bool> isIndexed,
      Value<int> rowid,
    });
typedef $$SourcesTableUpdateCompanionBuilder =
    SourcesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<SourceType> type,
      Value<int> createdAt,
      Value<int> lastAccessedAt,
      Value<String?> filePath,
      Value<String?> url,
      Value<String?> content,
      Value<int?> sizeBytes,
      Value<int?> durationSeconds,
      Value<String?> thumbnailPath,
      Value<List<String>> tags,
      Value<bool> isIndexed,
      Value<int> rowid,
    });

final class $$SourcesTableReferences
    extends BaseReferences<_$AppDatabase, $SourcesTable, SourceEntry> {
  $$SourcesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FlashcardsTable, List<FlashcardEntry>>
  _flashcardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flashcards,
    aliasName: $_aliasNameGenerator(db.sources.id, db.flashcards.sourceId),
  );

  $$FlashcardsTableProcessedTableManager get flashcardsRefs {
    final manager = $$FlashcardsTableTableManager(
      $_db,
      $_db.flashcards,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_flashcardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizQuestionsTable, List<QuizQuestionEntry>>
  _quizQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizQuestions,
    aliasName: $_aliasNameGenerator(db.sources.id, db.quizQuestions.sourceId),
  );

  $$QuizQuestionsTableProcessedTableManager get quizQuestionsRefs {
    final manager = $$QuizQuestionsTableTableManager(
      $_db,
      $_db.quizQuestions,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IdentificationQuestionsTable,
    List<IdentificationQuestionEntry>
  >
  _identificationQuestionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.identificationQuestions,
        aliasName: $_aliasNameGenerator(
          db.sources.id,
          db.identificationQuestions.sourceId,
        ),
      );

  $$IdentificationQuestionsTableProcessedTableManager
  get identificationQuestionsRefs {
    final manager = $$IdentificationQuestionsTableTableManager(
      $_db,
      $_db.identificationQuestions,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _identificationQuestionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImageOcclusionsTable, List<ImageOcclusionEntry>>
  _imageOcclusionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.imageOcclusions,
    aliasName: $_aliasNameGenerator(db.sources.id, db.imageOcclusions.sourceId),
  );

  $$ImageOcclusionsTableProcessedTableManager get imageOcclusionsRefs {
    final manager = $$ImageOcclusionsTableTableManager(
      $_db,
      $_db.imageOcclusions,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _imageOcclusionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchingSetsTable, List<MatchingSetEntry>>
  _matchingSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchingSets,
    aliasName: $_aliasNameGenerator(db.sources.id, db.matchingSets.sourceId),
  );

  $$MatchingSetsTableProcessedTableManager get matchingSetsRefs {
    final manager = $$MatchingSetsTableTableManager(
      $_db,
      $_db.matchingSets,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchingSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceReferencesTable, List<SourceReferenceEntry>>
  _sourceReferencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceReferences,
    aliasName: $_aliasNameGenerator(
      db.sources.id,
      db.sourceReferences.sourceId,
    ),
  );

  $$SourceReferencesTableProcessedTableManager get sourceReferencesRefs {
    final manager = $$SourceReferencesTableTableManager(
      $_db,
      $_db.sourceReferences,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sourceReferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourcesTableFilterComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SourceType, SourceType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isIndexed => $composableBuilder(
    column: $table.isIndexed,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> flashcardsRefs(
    Expression<bool> Function($$FlashcardsTableFilterComposer f) f,
  ) {
    final $$FlashcardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableFilterComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizQuestionsRefs(
    Expression<bool> Function($$QuizQuestionsTableFilterComposer f) f,
  ) {
    final $$QuizQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> identificationQuestionsRefs(
    Expression<bool> Function($$IdentificationQuestionsTableFilterComposer f) f,
  ) {
    final $$IdentificationQuestionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.identificationQuestions,
          getReferencedColumn: (t) => t.sourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IdentificationQuestionsTableFilterComposer(
                $db: $db,
                $table: $db.identificationQuestions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> imageOcclusionsRefs(
    Expression<bool> Function($$ImageOcclusionsTableFilterComposer f) f,
  ) {
    final $$ImageOcclusionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imageOcclusions,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageOcclusionsTableFilterComposer(
            $db: $db,
            $table: $db.imageOcclusions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchingSetsRefs(
    Expression<bool> Function($$MatchingSetsTableFilterComposer f) f,
  ) {
    final $$MatchingSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchingSets,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchingSetsTableFilterComposer(
            $db: $db,
            $table: $db.matchingSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceReferencesRefs(
    Expression<bool> Function($$SourceReferencesTableFilterComposer f) f,
  ) {
    final $$SourceReferencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableFilterComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIndexed => $composableBuilder(
    column: $table.isIndexed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get isIndexed =>
      $composableBuilder(column: $table.isIndexed, builder: (column) => column);

  Expression<T> flashcardsRefs<T extends Object>(
    Expression<T> Function($$FlashcardsTableAnnotationComposer a) f,
  ) {
    final $$FlashcardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizQuestionsRefs<T extends Object>(
    Expression<T> Function($$QuizQuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuizQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> identificationQuestionsRefs<T extends Object>(
    Expression<T> Function($$IdentificationQuestionsTableAnnotationComposer a)
    f,
  ) {
    final $$IdentificationQuestionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.identificationQuestions,
          getReferencedColumn: (t) => t.sourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IdentificationQuestionsTableAnnotationComposer(
                $db: $db,
                $table: $db.identificationQuestions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> imageOcclusionsRefs<T extends Object>(
    Expression<T> Function($$ImageOcclusionsTableAnnotationComposer a) f,
  ) {
    final $$ImageOcclusionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imageOcclusions,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageOcclusionsTableAnnotationComposer(
            $db: $db,
            $table: $db.imageOcclusions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> matchingSetsRefs<T extends Object>(
    Expression<T> Function($$MatchingSetsTableAnnotationComposer a) f,
  ) {
    final $$MatchingSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchingSets,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchingSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.matchingSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceReferencesRefs<T extends Object>(
    Expression<T> Function($$SourceReferencesTableAnnotationComposer a) f,
  ) {
    final $$SourceReferencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceReferences,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceReferencesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourcesTable,
          SourceEntry,
          $$SourcesTableFilterComposer,
          $$SourcesTableOrderingComposer,
          $$SourcesTableAnnotationComposer,
          $$SourcesTableCreateCompanionBuilder,
          $$SourcesTableUpdateCompanionBuilder,
          (SourceEntry, $$SourcesTableReferences),
          SourceEntry,
          PrefetchHooks Function({
            bool flashcardsRefs,
            bool quizQuestionsRefs,
            bool identificationQuestionsRefs,
            bool imageOcclusionsRefs,
            bool matchingSetsRefs,
            bool sourceReferencesRefs,
          })
        > {
  $$SourcesTableTableManager(_$AppDatabase db, $SourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<SourceType> type = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> lastAccessedAt = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<bool> isIndexed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion(
                id: id,
                title: title,
                type: type,
                createdAt: createdAt,
                lastAccessedAt: lastAccessedAt,
                filePath: filePath,
                url: url,
                content: content,
                sizeBytes: sizeBytes,
                durationSeconds: durationSeconds,
                thumbnailPath: thumbnailPath,
                tags: tags,
                isIndexed: isIndexed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required SourceType type,
                required int createdAt,
                required int lastAccessedAt,
                Value<String?> filePath = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                required List<String> tags,
                Value<bool> isIndexed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcesCompanion.insert(
                id: id,
                title: title,
                type: type,
                createdAt: createdAt,
                lastAccessedAt: lastAccessedAt,
                filePath: filePath,
                url: url,
                content: content,
                sizeBytes: sizeBytes,
                durationSeconds: durationSeconds,
                thumbnailPath: thumbnailPath,
                tags: tags,
                isIndexed: isIndexed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                flashcardsRefs = false,
                quizQuestionsRefs = false,
                identificationQuestionsRefs = false,
                imageOcclusionsRefs = false,
                matchingSetsRefs = false,
                sourceReferencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (flashcardsRefs) db.flashcards,
                    if (quizQuestionsRefs) db.quizQuestions,
                    if (identificationQuestionsRefs) db.identificationQuestions,
                    if (imageOcclusionsRefs) db.imageOcclusions,
                    if (matchingSetsRefs) db.matchingSets,
                    if (sourceReferencesRefs) db.sourceReferences,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (flashcardsRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourcesTable,
                          FlashcardEntry
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._flashcardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).flashcardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizQuestionsRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourcesTable,
                          QuizQuestionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._quizQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (identificationQuestionsRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourcesTable,
                          IdentificationQuestionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._identificationQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).identificationQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (imageOcclusionsRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourcesTable,
                          ImageOcclusionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._imageOcclusionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).imageOcclusionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchingSetsRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourcesTable,
                          MatchingSetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._matchingSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).matchingSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceReferencesRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourcesTable,
                          SourceReferenceEntry
                        >(
                          currentTable: table,
                          referencedTable: $$SourcesTableReferences
                              ._sourceReferencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceReferencesRefs,
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

typedef $$SourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourcesTable,
      SourceEntry,
      $$SourcesTableFilterComposer,
      $$SourcesTableOrderingComposer,
      $$SourcesTableAnnotationComposer,
      $$SourcesTableCreateCompanionBuilder,
      $$SourcesTableUpdateCompanionBuilder,
      (SourceEntry, $$SourcesTableReferences),
      SourceEntry,
      PrefetchHooks Function({
        bool flashcardsRefs,
        bool quizQuestionsRefs,
        bool identificationQuestionsRefs,
        bool imageOcclusionsRefs,
        bool matchingSetsRefs,
        bool sourceReferencesRefs,
      })
    >;
typedef $$FlashcardsTableCreateCompanionBuilder =
    FlashcardsCompanion Function({
      required String id,
      required String sourceId,
      required String front,
      required String back,
      Value<String?> frontImagePath,
      Value<String?> backImagePath,
      Value<String?> sourceReferenceId,
      required List<String> tags,
      required int createdAt,
      required int updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });
typedef $$FlashcardsTableUpdateCompanionBuilder =
    FlashcardsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> front,
      Value<String> back,
      Value<String?> frontImagePath,
      Value<String?> backImagePath,
      Value<String?> sourceReferenceId,
      Value<List<String>> tags,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });

final class $$FlashcardsTableReferences
    extends BaseReferences<_$AppDatabase, $FlashcardsTable, FlashcardEntry> {
  $$FlashcardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourcesTable _sourceIdTable(_$AppDatabase db) => db.sources
      .createAlias($_aliasNameGenerator(db.flashcards.sourceId, db.sources.id));

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FlashcardsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableFilterComposer({
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

  ColumnFilters<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frontImagePath => $composableBuilder(
    column: $table.frontImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backImagePath => $composableBuilder(
    column: $table.backImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableOrderingComposer({
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

  ColumnOrderings<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frontImagePath => $composableBuilder(
    column: $table.frontImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backImagePath => $composableBuilder(
    column: $table.backImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get front =>
      $composableBuilder(column: $table.front, builder: (column) => column);

  GeneratedColumn<String> get back =>
      $composableBuilder(column: $table.back, builder: (column) => column);

  GeneratedColumn<String> get frontImagePath => $composableBuilder(
    column: $table.frontImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backImagePath => $composableBuilder(
    column: $table.backImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get fsrsData =>
      $composableBuilder(column: $table.fsrsData, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardsTable,
          FlashcardEntry,
          $$FlashcardsTableFilterComposer,
          $$FlashcardsTableOrderingComposer,
          $$FlashcardsTableAnnotationComposer,
          $$FlashcardsTableCreateCompanionBuilder,
          $$FlashcardsTableUpdateCompanionBuilder,
          (FlashcardEntry, $$FlashcardsTableReferences),
          FlashcardEntry,
          PrefetchHooks Function({bool sourceId})
        > {
  $$FlashcardsTableTableManager(_$AppDatabase db, $FlashcardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> front = const Value.absent(),
                Value<String> back = const Value.absent(),
                Value<String?> frontImagePath = const Value.absent(),
                Value<String?> backImagePath = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlashcardsCompanion(
                id: id,
                sourceId: sourceId,
                front: front,
                back: back,
                frontImagePath: frontImagePath,
                backImagePath: backImagePath,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String front,
                required String back,
                Value<String?> frontImagePath = const Value.absent(),
                Value<String?> backImagePath = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                required List<String> tags,
                required int createdAt,
                required int updatedAt,
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlashcardsCompanion.insert(
                id: id,
                sourceId: sourceId,
                front: front,
                back: back,
                frontImagePath: frontImagePath,
                backImagePath: backImagePath,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlashcardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
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
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable: $$FlashcardsTableReferences
                                    ._sourceIdTable(db),
                                referencedColumn: $$FlashcardsTableReferences
                                    ._sourceIdTable(db)
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

typedef $$FlashcardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardsTable,
      FlashcardEntry,
      $$FlashcardsTableFilterComposer,
      $$FlashcardsTableOrderingComposer,
      $$FlashcardsTableAnnotationComposer,
      $$FlashcardsTableCreateCompanionBuilder,
      $$FlashcardsTableUpdateCompanionBuilder,
      (FlashcardEntry, $$FlashcardsTableReferences),
      FlashcardEntry,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$QuizQuestionsTableCreateCompanionBuilder =
    QuizQuestionsCompanion Function({
      required String id,
      required String sourceId,
      required String question,
      required List<String> options,
      required int correctOptionIndex,
      Value<String?> explanation,
      Value<String?> imagePath,
      Value<String?> sourceReferenceId,
      required List<String> tags,
      Value<int> difficulty,
      required int createdAt,
      required int updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });
typedef $$QuizQuestionsTableUpdateCompanionBuilder =
    QuizQuestionsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> question,
      Value<List<String>> options,
      Value<int> correctOptionIndex,
      Value<String?> explanation,
      Value<String?> imagePath,
      Value<String?> sourceReferenceId,
      Value<List<String>> tags,
      Value<int> difficulty,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });

final class $$QuizQuestionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuizQuestionsTable, QuizQuestionEntry> {
  $$QuizQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias(
        $_aliasNameGenerator(db.quizQuestions.sourceId, db.sources.id),
      );

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableFilterComposer({
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

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get correctOptionIndex => $composableBuilder(
    column: $table.correctOptionIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableOrderingComposer({
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

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctOptionIndex => $composableBuilder(
    column: $table.correctOptionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<int> get correctOptionIndex => $composableBuilder(
    column: $table.correctOptionIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get fsrsData =>
      $composableBuilder(column: $table.fsrsData, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizQuestionsTable,
          QuizQuestionEntry,
          $$QuizQuestionsTableFilterComposer,
          $$QuizQuestionsTableOrderingComposer,
          $$QuizQuestionsTableAnnotationComposer,
          $$QuizQuestionsTableCreateCompanionBuilder,
          $$QuizQuestionsTableUpdateCompanionBuilder,
          (QuizQuestionEntry, $$QuizQuestionsTableReferences),
          QuizQuestionEntry,
          PrefetchHooks Function({bool sourceId})
        > {
  $$QuizQuestionsTableTableManager(_$AppDatabase db, $QuizQuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<List<String>> options = const Value.absent(),
                Value<int> correctOptionIndex = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion(
                id: id,
                sourceId: sourceId,
                question: question,
                options: options,
                correctOptionIndex: correctOptionIndex,
                explanation: explanation,
                imagePath: imagePath,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                difficulty: difficulty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String question,
                required List<String> options,
                required int correctOptionIndex,
                Value<String?> explanation = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                required List<String> tags,
                Value<int> difficulty = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion.insert(
                id: id,
                sourceId: sourceId,
                question: question,
                options: options,
                correctOptionIndex: correctOptionIndex,
                explanation: explanation,
                imagePath: imagePath,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                difficulty: difficulty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
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
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable: $$QuizQuestionsTableReferences
                                    ._sourceIdTable(db),
                                referencedColumn: $$QuizQuestionsTableReferences
                                    ._sourceIdTable(db)
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

typedef $$QuizQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizQuestionsTable,
      QuizQuestionEntry,
      $$QuizQuestionsTableFilterComposer,
      $$QuizQuestionsTableOrderingComposer,
      $$QuizQuestionsTableAnnotationComposer,
      $$QuizQuestionsTableCreateCompanionBuilder,
      $$QuizQuestionsTableUpdateCompanionBuilder,
      (QuizQuestionEntry, $$QuizQuestionsTableReferences),
      QuizQuestionEntry,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$IdentificationQuestionsTableCreateCompanionBuilder =
    IdentificationQuestionsCompanion Function({
      required String id,
      required String sourceId,
      required String question,
      required String modelAnswer,
      required List<String> hints,
      required List<String> keywords,
      Value<String?> sourceReferenceId,
      required List<String> tags,
      Value<int> difficulty,
      required int createdAt,
      required int updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });
typedef $$IdentificationQuestionsTableUpdateCompanionBuilder =
    IdentificationQuestionsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> question,
      Value<String> modelAnswer,
      Value<List<String>> hints,
      Value<List<String>> keywords,
      Value<String?> sourceReferenceId,
      Value<List<String>> tags,
      Value<int> difficulty,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });

final class $$IdentificationQuestionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IdentificationQuestionsTable,
          IdentificationQuestionEntry
        > {
  $$IdentificationQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias(
        $_aliasNameGenerator(
          db.identificationQuestions.sourceId,
          db.sources.id,
        ),
      );

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IdentificationQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $IdentificationQuestionsTable> {
  $$IdentificationQuestionsTableFilterComposer({
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

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelAnswer => $composableBuilder(
    column: $table.modelAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get hints => $composableBuilder(
    column: $table.hints,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentificationQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdentificationQuestionsTable> {
  $$IdentificationQuestionsTableOrderingComposer({
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

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelAnswer => $composableBuilder(
    column: $table.modelAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hints => $composableBuilder(
    column: $table.hints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentificationQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdentificationQuestionsTable> {
  $$IdentificationQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get modelAnswer => $composableBuilder(
    column: $table.modelAnswer,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get hints =>
      $composableBuilder(column: $table.hints, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get fsrsData =>
      $composableBuilder(column: $table.fsrsData, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentificationQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdentificationQuestionsTable,
          IdentificationQuestionEntry,
          $$IdentificationQuestionsTableFilterComposer,
          $$IdentificationQuestionsTableOrderingComposer,
          $$IdentificationQuestionsTableAnnotationComposer,
          $$IdentificationQuestionsTableCreateCompanionBuilder,
          $$IdentificationQuestionsTableUpdateCompanionBuilder,
          (
            IdentificationQuestionEntry,
            $$IdentificationQuestionsTableReferences,
          ),
          IdentificationQuestionEntry,
          PrefetchHooks Function({bool sourceId})
        > {
  $$IdentificationQuestionsTableTableManager(
    _$AppDatabase db,
    $IdentificationQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdentificationQuestionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IdentificationQuestionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IdentificationQuestionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String> modelAnswer = const Value.absent(),
                Value<List<String>> hints = const Value.absent(),
                Value<List<String>> keywords = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdentificationQuestionsCompanion(
                id: id,
                sourceId: sourceId,
                question: question,
                modelAnswer: modelAnswer,
                hints: hints,
                keywords: keywords,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                difficulty: difficulty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String question,
                required String modelAnswer,
                required List<String> hints,
                required List<String> keywords,
                Value<String?> sourceReferenceId = const Value.absent(),
                required List<String> tags,
                Value<int> difficulty = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdentificationQuestionsCompanion.insert(
                id: id,
                sourceId: sourceId,
                question: question,
                modelAnswer: modelAnswer,
                hints: hints,
                keywords: keywords,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                difficulty: difficulty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IdentificationQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
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
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable:
                                    $$IdentificationQuestionsTableReferences
                                        ._sourceIdTable(db),
                                referencedColumn:
                                    $$IdentificationQuestionsTableReferences
                                        ._sourceIdTable(db)
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

typedef $$IdentificationQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdentificationQuestionsTable,
      IdentificationQuestionEntry,
      $$IdentificationQuestionsTableFilterComposer,
      $$IdentificationQuestionsTableOrderingComposer,
      $$IdentificationQuestionsTableAnnotationComposer,
      $$IdentificationQuestionsTableCreateCompanionBuilder,
      $$IdentificationQuestionsTableUpdateCompanionBuilder,
      (IdentificationQuestionEntry, $$IdentificationQuestionsTableReferences),
      IdentificationQuestionEntry,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$ImageOcclusionsTableCreateCompanionBuilder =
    ImageOcclusionsCompanion Function({
      required String id,
      required String sourceId,
      required String title,
      required String imagePath,
      Value<String> regions,
      Value<String?> sourceReferenceId,
      required List<String> tags,
      required int createdAt,
      required int updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });
typedef $$ImageOcclusionsTableUpdateCompanionBuilder =
    ImageOcclusionsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> title,
      Value<String> imagePath,
      Value<String> regions,
      Value<String?> sourceReferenceId,
      Value<List<String>> tags,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });

final class $$ImageOcclusionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ImageOcclusionsTable,
          ImageOcclusionEntry
        > {
  $$ImageOcclusionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias(
        $_aliasNameGenerator(db.imageOcclusions.sourceId, db.sources.id),
      );

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImageOcclusionsTableFilterComposer
    extends Composer<_$AppDatabase, $ImageOcclusionsTable> {
  $$ImageOcclusionsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regions => $composableBuilder(
    column: $table.regions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageOcclusionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImageOcclusionsTable> {
  $$ImageOcclusionsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regions => $composableBuilder(
    column: $table.regions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageOcclusionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImageOcclusionsTable> {
  $$ImageOcclusionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get regions =>
      $composableBuilder(column: $table.regions, builder: (column) => column);

  GeneratedColumn<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get fsrsData =>
      $composableBuilder(column: $table.fsrsData, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageOcclusionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImageOcclusionsTable,
          ImageOcclusionEntry,
          $$ImageOcclusionsTableFilterComposer,
          $$ImageOcclusionsTableOrderingComposer,
          $$ImageOcclusionsTableAnnotationComposer,
          $$ImageOcclusionsTableCreateCompanionBuilder,
          $$ImageOcclusionsTableUpdateCompanionBuilder,
          (ImageOcclusionEntry, $$ImageOcclusionsTableReferences),
          ImageOcclusionEntry,
          PrefetchHooks Function({bool sourceId})
        > {
  $$ImageOcclusionsTableTableManager(
    _$AppDatabase db,
    $ImageOcclusionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImageOcclusionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImageOcclusionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImageOcclusionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> regions = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImageOcclusionsCompanion(
                id: id,
                sourceId: sourceId,
                title: title,
                imagePath: imagePath,
                regions: regions,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String title,
                required String imagePath,
                Value<String> regions = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                required List<String> tags,
                required int createdAt,
                required int updatedAt,
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImageOcclusionsCompanion.insert(
                id: id,
                sourceId: sourceId,
                title: title,
                imagePath: imagePath,
                regions: regions,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ImageOcclusionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
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
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable:
                                    $$ImageOcclusionsTableReferences
                                        ._sourceIdTable(db),
                                referencedColumn:
                                    $$ImageOcclusionsTableReferences
                                        ._sourceIdTable(db)
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

typedef $$ImageOcclusionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImageOcclusionsTable,
      ImageOcclusionEntry,
      $$ImageOcclusionsTableFilterComposer,
      $$ImageOcclusionsTableOrderingComposer,
      $$ImageOcclusionsTableAnnotationComposer,
      $$ImageOcclusionsTableCreateCompanionBuilder,
      $$ImageOcclusionsTableUpdateCompanionBuilder,
      (ImageOcclusionEntry, $$ImageOcclusionsTableReferences),
      ImageOcclusionEntry,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$MatchingSetsTableCreateCompanionBuilder =
    MatchingSetsCompanion Function({
      required String id,
      required String sourceId,
      required String title,
      Value<String?> instructions,
      Value<String> pairs,
      Value<String?> sourceReferenceId,
      required List<String> tags,
      required int createdAt,
      required int updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });
typedef $$MatchingSetsTableUpdateCompanionBuilder =
    MatchingSetsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> title,
      Value<String?> instructions,
      Value<String> pairs,
      Value<String?> sourceReferenceId,
      Value<List<String>> tags,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> fsrsData,
      Value<int> rowid,
    });

final class $$MatchingSetsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MatchingSetsTable, MatchingSetEntry> {
  $$MatchingSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias(
        $_aliasNameGenerator(db.matchingSets.sourceId, db.sources.id),
      );

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MatchingSetsTableFilterComposer
    extends Composer<_$AppDatabase, $MatchingSetsTable> {
  $$MatchingSetsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pairs => $composableBuilder(
    column: $table.pairs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchingSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchingSetsTable> {
  $$MatchingSetsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pairs => $composableBuilder(
    column: $table.pairs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fsrsData => $composableBuilder(
    column: $table.fsrsData,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchingSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchingSetsTable> {
  $$MatchingSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pairs =>
      $composableBuilder(column: $table.pairs, builder: (column) => column);

  GeneratedColumn<String> get sourceReferenceId => $composableBuilder(
    column: $table.sourceReferenceId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get fsrsData =>
      $composableBuilder(column: $table.fsrsData, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchingSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchingSetsTable,
          MatchingSetEntry,
          $$MatchingSetsTableFilterComposer,
          $$MatchingSetsTableOrderingComposer,
          $$MatchingSetsTableAnnotationComposer,
          $$MatchingSetsTableCreateCompanionBuilder,
          $$MatchingSetsTableUpdateCompanionBuilder,
          (MatchingSetEntry, $$MatchingSetsTableReferences),
          MatchingSetEntry,
          PrefetchHooks Function({bool sourceId})
        > {
  $$MatchingSetsTableTableManager(_$AppDatabase db, $MatchingSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchingSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchingSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchingSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String> pairs = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchingSetsCompanion(
                id: id,
                sourceId: sourceId,
                title: title,
                instructions: instructions,
                pairs: pairs,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String title,
                Value<String?> instructions = const Value.absent(),
                Value<String> pairs = const Value.absent(),
                Value<String?> sourceReferenceId = const Value.absent(),
                required List<String> tags,
                required int createdAt,
                required int updatedAt,
                Value<String> fsrsData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchingSetsCompanion.insert(
                id: id,
                sourceId: sourceId,
                title: title,
                instructions: instructions,
                pairs: pairs,
                sourceReferenceId: sourceReferenceId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fsrsData: fsrsData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchingSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
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
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable: $$MatchingSetsTableReferences
                                    ._sourceIdTable(db),
                                referencedColumn: $$MatchingSetsTableReferences
                                    ._sourceIdTable(db)
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

typedef $$MatchingSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchingSetsTable,
      MatchingSetEntry,
      $$MatchingSetsTableFilterComposer,
      $$MatchingSetsTableOrderingComposer,
      $$MatchingSetsTableAnnotationComposer,
      $$MatchingSetsTableCreateCompanionBuilder,
      $$MatchingSetsTableUpdateCompanionBuilder,
      (MatchingSetEntry, $$MatchingSetsTableReferences),
      MatchingSetEntry,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$SourceReferencesTableCreateCompanionBuilder =
    SourceReferencesCompanion Function({
      required String id,
      required String sourceId,
      required ReferenceType type,
      Value<int?> pageNumber,
      Value<int?> startOffset,
      Value<int?> endOffset,
      Value<String?> matchedText,
      Value<double?> startTimestamp,
      Value<double?> endTimestamp,
      Value<double?> regionX,
      Value<double?> regionY,
      Value<double?> regionWidth,
      Value<double?> regionHeight,
      Value<String?> anchor,
      Value<int> rowid,
    });
typedef $$SourceReferencesTableUpdateCompanionBuilder =
    SourceReferencesCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<ReferenceType> type,
      Value<int?> pageNumber,
      Value<int?> startOffset,
      Value<int?> endOffset,
      Value<String?> matchedText,
      Value<double?> startTimestamp,
      Value<double?> endTimestamp,
      Value<double?> regionX,
      Value<double?> regionY,
      Value<double?> regionWidth,
      Value<double?> regionHeight,
      Value<String?> anchor,
      Value<int> rowid,
    });

final class $$SourceReferencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SourceReferencesTable,
          SourceReferenceEntry
        > {
  $$SourceReferencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.sources.createAlias(
        $_aliasNameGenerator(db.sourceReferences.sourceId, db.sources.id),
      );

  $$SourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$SourcesTableTableManager(
      $_db,
      $_db.sources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SourceReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $SourceReferencesTable> {
  $$SourceReferencesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ReferenceType, ReferenceType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchedText => $composableBuilder(
    column: $table.matchedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startTimestamp => $composableBuilder(
    column: $table.startTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endTimestamp => $composableBuilder(
    column: $table.endTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get regionX => $composableBuilder(
    column: $table.regionX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get regionY => $composableBuilder(
    column: $table.regionY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get regionWidth => $composableBuilder(
    column: $table.regionWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get regionHeight => $composableBuilder(
    column: $table.regionHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchor => $composableBuilder(
    column: $table.anchor,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcesTableFilterComposer get sourceId {
    final $$SourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableFilterComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceReferencesTable> {
  $$SourceReferencesTableOrderingComposer({
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

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchedText => $composableBuilder(
    column: $table.matchedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startTimestamp => $composableBuilder(
    column: $table.startTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endTimestamp => $composableBuilder(
    column: $table.endTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get regionX => $composableBuilder(
    column: $table.regionX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get regionY => $composableBuilder(
    column: $table.regionY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get regionWidth => $composableBuilder(
    column: $table.regionWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get regionHeight => $composableBuilder(
    column: $table.regionHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchor => $composableBuilder(
    column: $table.anchor,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcesTableOrderingComposer get sourceId {
    final $$SourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableOrderingComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceReferencesTable> {
  $$SourceReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReferenceType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<String> get matchedText => $composableBuilder(
    column: $table.matchedText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startTimestamp => $composableBuilder(
    column: $table.startTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<double> get endTimestamp => $composableBuilder(
    column: $table.endTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<double> get regionX =>
      $composableBuilder(column: $table.regionX, builder: (column) => column);

  GeneratedColumn<double> get regionY =>
      $composableBuilder(column: $table.regionY, builder: (column) => column);

  GeneratedColumn<double> get regionWidth => $composableBuilder(
    column: $table.regionWidth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get regionHeight => $composableBuilder(
    column: $table.regionHeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anchor =>
      $composableBuilder(column: $table.anchor, builder: (column) => column);

  $$SourcesTableAnnotationComposer get sourceId {
    final $$SourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.sources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.sources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceReferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceReferencesTable,
          SourceReferenceEntry,
          $$SourceReferencesTableFilterComposer,
          $$SourceReferencesTableOrderingComposer,
          $$SourceReferencesTableAnnotationComposer,
          $$SourceReferencesTableCreateCompanionBuilder,
          $$SourceReferencesTableUpdateCompanionBuilder,
          (SourceReferenceEntry, $$SourceReferencesTableReferences),
          SourceReferenceEntry,
          PrefetchHooks Function({bool sourceId})
        > {
  $$SourceReferencesTableTableManager(
    _$AppDatabase db,
    $SourceReferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceReferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceReferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<ReferenceType> type = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> startOffset = const Value.absent(),
                Value<int?> endOffset = const Value.absent(),
                Value<String?> matchedText = const Value.absent(),
                Value<double?> startTimestamp = const Value.absent(),
                Value<double?> endTimestamp = const Value.absent(),
                Value<double?> regionX = const Value.absent(),
                Value<double?> regionY = const Value.absent(),
                Value<double?> regionWidth = const Value.absent(),
                Value<double?> regionHeight = const Value.absent(),
                Value<String?> anchor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceReferencesCompanion(
                id: id,
                sourceId: sourceId,
                type: type,
                pageNumber: pageNumber,
                startOffset: startOffset,
                endOffset: endOffset,
                matchedText: matchedText,
                startTimestamp: startTimestamp,
                endTimestamp: endTimestamp,
                regionX: regionX,
                regionY: regionY,
                regionWidth: regionWidth,
                regionHeight: regionHeight,
                anchor: anchor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required ReferenceType type,
                Value<int?> pageNumber = const Value.absent(),
                Value<int?> startOffset = const Value.absent(),
                Value<int?> endOffset = const Value.absent(),
                Value<String?> matchedText = const Value.absent(),
                Value<double?> startTimestamp = const Value.absent(),
                Value<double?> endTimestamp = const Value.absent(),
                Value<double?> regionX = const Value.absent(),
                Value<double?> regionY = const Value.absent(),
                Value<double?> regionWidth = const Value.absent(),
                Value<double?> regionHeight = const Value.absent(),
                Value<String?> anchor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceReferencesCompanion.insert(
                id: id,
                sourceId: sourceId,
                type: type,
                pageNumber: pageNumber,
                startOffset: startOffset,
                endOffset: endOffset,
                matchedText: matchedText,
                startTimestamp: startTimestamp,
                endTimestamp: endTimestamp,
                regionX: regionX,
                regionY: regionY,
                regionWidth: regionWidth,
                regionHeight: regionHeight,
                anchor: anchor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourceReferencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
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
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable:
                                    $$SourceReferencesTableReferences
                                        ._sourceIdTable(db),
                                referencedColumn:
                                    $$SourceReferencesTableReferences
                                        ._sourceIdTable(db)
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

typedef $$SourceReferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceReferencesTable,
      SourceReferenceEntry,
      $$SourceReferencesTableFilterComposer,
      $$SourceReferencesTableOrderingComposer,
      $$SourceReferencesTableAnnotationComposer,
      $$SourceReferencesTableCreateCompanionBuilder,
      $$SourceReferencesTableUpdateCompanionBuilder,
      (SourceReferenceEntry, $$SourceReferencesTableReferences),
      SourceReferenceEntry,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$ReviewLogsTableCreateCompanionBuilder =
    ReviewLogsCompanion Function({
      required String id,
      required String cardType,
      required String cardId,
      required int reviewDateTime,
      required int rating,
      required int scheduledDays,
      required int elapsedDays,
      required int state,
      Value<int> rowid,
    });
typedef $$ReviewLogsTableUpdateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<String> id,
      Value<String> cardType,
      Value<String> cardId,
      Value<int> reviewDateTime,
      Value<int> rating,
      Value<int> scheduledDays,
      Value<int> elapsedDays,
      Value<int> state,
      Value<int> rowid,
    });

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
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

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewDateTime => $composableBuilder(
    column: $table.reviewDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
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

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewDateTime => $composableBuilder(
    column: $table.reviewDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get reviewDateTime => $composableBuilder(
    column: $table.reviewDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogsTable,
          ReviewLogEntry,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (
            ReviewLogEntry,
            BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLogEntry>,
          ),
          ReviewLogEntry,
          PrefetchHooks Function()
        > {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardType = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<int> reviewDateTime = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<int> scheduledDays = const Value.absent(),
                Value<int> elapsedDays = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewLogsCompanion(
                id: id,
                cardType: cardType,
                cardId: cardId,
                reviewDateTime: reviewDateTime,
                rating: rating,
                scheduledDays: scheduledDays,
                elapsedDays: elapsedDays,
                state: state,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardType,
                required String cardId,
                required int reviewDateTime,
                required int rating,
                required int scheduledDays,
                required int elapsedDays,
                required int state,
                Value<int> rowid = const Value.absent(),
              }) => ReviewLogsCompanion.insert(
                id: id,
                cardType: cardType,
                cardId: cardId,
                reviewDateTime: reviewDateTime,
                rating: rating,
                scheduledDays: scheduledDays,
                elapsedDays: elapsedDays,
                state: state,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogsTable,
      ReviewLogEntry,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (
        ReviewLogEntry,
        BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLogEntry>,
      ),
      ReviewLogEntry,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String name,
      Value<String?> email,
      Value<String?> avatarUrl,
      Value<String?> institution,
      Value<String?> major,
      Value<String?> yearLevel,
      Value<int> totalStudyMinutes,
      Value<int> totalCardsReviewed,
      Value<int> totalQuizzesTaken,
      Value<double> averageScore,
      Value<int> credits,
      required int createdAt,
      required int lastActiveAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> email,
      Value<String?> avatarUrl,
      Value<String?> institution,
      Value<String?> major,
      Value<String?> yearLevel,
      Value<int> totalStudyMinutes,
      Value<int> totalCardsReviewed,
      Value<int> totalQuizzesTaken,
      Value<double> averageScore,
      Value<int> credits,
      Value<int> createdAt,
      Value<int> lastActiveAt,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get major => $composableBuilder(
    column: $table.major,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearLevel => $composableBuilder(
    column: $table.yearLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalStudyMinutes => $composableBuilder(
    column: $table.totalStudyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCardsReviewed => $composableBuilder(
    column: $table.totalCardsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuizzesTaken => $composableBuilder(
    column: $table.totalQuizzesTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageScore => $composableBuilder(
    column: $table.averageScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastActiveAt => $composableBuilder(
    column: $table.lastActiveAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get major => $composableBuilder(
    column: $table.major,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearLevel => $composableBuilder(
    column: $table.yearLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalStudyMinutes => $composableBuilder(
    column: $table.totalStudyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCardsReviewed => $composableBuilder(
    column: $table.totalCardsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuizzesTaken => $composableBuilder(
    column: $table.totalQuizzesTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageScore => $composableBuilder(
    column: $table.averageScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastActiveAt => $composableBuilder(
    column: $table.lastActiveAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get major =>
      $composableBuilder(column: $table.major, builder: (column) => column);

  GeneratedColumn<String> get yearLevel =>
      $composableBuilder(column: $table.yearLevel, builder: (column) => column);

  GeneratedColumn<int> get totalStudyMinutes => $composableBuilder(
    column: $table.totalStudyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCardsReviewed => $composableBuilder(
    column: $table.totalCardsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuizzesTaken => $composableBuilder(
    column: $table.totalQuizzesTaken,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageScore => $composableBuilder(
    column: $table.averageScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastActiveAt => $composableBuilder(
    column: $table.lastActiveAt,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserEntry,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserEntry, BaseReferences<_$AppDatabase, $UsersTable, UserEntry>),
          UserEntry,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<String?> major = const Value.absent(),
                Value<String?> yearLevel = const Value.absent(),
                Value<int> totalStudyMinutes = const Value.absent(),
                Value<int> totalCardsReviewed = const Value.absent(),
                Value<int> totalQuizzesTaken = const Value.absent(),
                Value<double> averageScore = const Value.absent(),
                Value<int> credits = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> lastActiveAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                avatarUrl: avatarUrl,
                institution: institution,
                major: major,
                yearLevel: yearLevel,
                totalStudyMinutes: totalStudyMinutes,
                totalCardsReviewed: totalCardsReviewed,
                totalQuizzesTaken: totalQuizzesTaken,
                averageScore: averageScore,
                credits: credits,
                createdAt: createdAt,
                lastActiveAt: lastActiveAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> email = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<String?> major = const Value.absent(),
                Value<String?> yearLevel = const Value.absent(),
                Value<int> totalStudyMinutes = const Value.absent(),
                Value<int> totalCardsReviewed = const Value.absent(),
                Value<int> totalQuizzesTaken = const Value.absent(),
                Value<double> averageScore = const Value.absent(),
                Value<int> credits = const Value.absent(),
                required int createdAt,
                required int lastActiveAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                avatarUrl: avatarUrl,
                institution: institution,
                major: major,
                yearLevel: yearLevel,
                totalStudyMinutes: totalStudyMinutes,
                totalCardsReviewed: totalCardsReviewed,
                totalQuizzesTaken: totalQuizzesTaken,
                averageScore: averageScore,
                credits: credits,
                createdAt: createdAt,
                lastActiveAt: lastActiveAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserEntry,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserEntry, BaseReferences<_$AppDatabase, $UsersTable, UserEntry>),
      UserEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SourcesTableTableManager get sources =>
      $$SourcesTableTableManager(_db, _db.sources);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db, _db.flashcards);
  $$QuizQuestionsTableTableManager get quizQuestions =>
      $$QuizQuestionsTableTableManager(_db, _db.quizQuestions);
  $$IdentificationQuestionsTableTableManager get identificationQuestions =>
      $$IdentificationQuestionsTableTableManager(
        _db,
        _db.identificationQuestions,
      );
  $$ImageOcclusionsTableTableManager get imageOcclusions =>
      $$ImageOcclusionsTableTableManager(_db, _db.imageOcclusions);
  $$MatchingSetsTableTableManager get matchingSets =>
      $$MatchingSetsTableTableManager(_db, _db.matchingSets);
  $$SourceReferencesTableTableManager get sourceReferences =>
      $$SourceReferencesTableTableManager(_db, _db.sourceReferences);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
