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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SourceItemsTable sourceItems = $SourceItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sourceItems];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SourceItemsTableTableManager get sourceItems =>
      $$SourceItemsTableTableManager(_db, _db.sourceItems);
}
