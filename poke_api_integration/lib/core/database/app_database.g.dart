// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PokemonEntriesTable extends PokemonEntries
    with TableInfo<$PokemonEntriesTable, PokemonEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PokemonEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typesJsonMeta = const VerificationMeta(
    'typesJson',
  );
  @override
  late final GeneratedColumn<String> typesJson = GeneratedColumn<String>(
    'types_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _statsJsonMeta = const VerificationMeta(
    'statsJson',
  );
  @override
  late final GeneratedColumn<String> statsJson = GeneratedColumn<String>(
    'stats_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _abilitiesJsonMeta = const VerificationMeta(
    'abilitiesJson',
  );
  @override
  late final GeneratedColumn<String> abilitiesJson = GeneratedColumn<String>(
    'abilities_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imageUrl,
    typesJson,
    statsJson,
    abilitiesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pokemon_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PokemonEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('types_json')) {
      context.handle(
        _typesJsonMeta,
        typesJson.isAcceptableOrUnknown(data['types_json']!, _typesJsonMeta),
      );
    }
    if (data.containsKey('stats_json')) {
      context.handle(
        _statsJsonMeta,
        statsJson.isAcceptableOrUnknown(data['stats_json']!, _statsJsonMeta),
      );
    }
    if (data.containsKey('abilities_json')) {
      context.handle(
        _abilitiesJsonMeta,
        abilitiesJson.isAcceptableOrUnknown(
          data['abilities_json']!,
          _abilitiesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PokemonEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PokemonEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      typesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}types_json'],
      )!,
      statsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stats_json'],
      )!,
      abilitiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abilities_json'],
      )!,
    );
  }

  @override
  $PokemonEntriesTable createAlias(String alias) {
    return $PokemonEntriesTable(attachedDatabase, alias);
  }
}

class PokemonEntry extends DataClass implements Insertable<PokemonEntry> {
  final int id;
  final String name;
  final String imageUrl;
  final String typesJson;
  final String statsJson;
  final String abilitiesJson;
  const PokemonEntry({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.typesJson,
    required this.statsJson,
    required this.abilitiesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['image_url'] = Variable<String>(imageUrl);
    map['types_json'] = Variable<String>(typesJson);
    map['stats_json'] = Variable<String>(statsJson);
    map['abilities_json'] = Variable<String>(abilitiesJson);
    return map;
  }

  PokemonEntriesCompanion toCompanion(bool nullToAbsent) {
    return PokemonEntriesCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: Value(imageUrl),
      typesJson: Value(typesJson),
      statsJson: Value(statsJson),
      abilitiesJson: Value(abilitiesJson),
    );
  }

  factory PokemonEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PokemonEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      typesJson: serializer.fromJson<String>(json['typesJson']),
      statsJson: serializer.fromJson<String>(json['statsJson']),
      abilitiesJson: serializer.fromJson<String>(json['abilitiesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'typesJson': serializer.toJson<String>(typesJson),
      'statsJson': serializer.toJson<String>(statsJson),
      'abilitiesJson': serializer.toJson<String>(abilitiesJson),
    };
  }

  PokemonEntry copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? typesJson,
    String? statsJson,
    String? abilitiesJson,
  }) => PokemonEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    imageUrl: imageUrl ?? this.imageUrl,
    typesJson: typesJson ?? this.typesJson,
    statsJson: statsJson ?? this.statsJson,
    abilitiesJson: abilitiesJson ?? this.abilitiesJson,
  );
  PokemonEntry copyWithCompanion(PokemonEntriesCompanion data) {
    return PokemonEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      typesJson: data.typesJson.present ? data.typesJson.value : this.typesJson,
      statsJson: data.statsJson.present ? data.statsJson.value : this.statsJson,
      abilitiesJson: data.abilitiesJson.present
          ? data.abilitiesJson.value
          : this.abilitiesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PokemonEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('typesJson: $typesJson, ')
          ..write('statsJson: $statsJson, ')
          ..write('abilitiesJson: $abilitiesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, imageUrl, typesJson, statsJson, abilitiesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PokemonEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.typesJson == this.typesJson &&
          other.statsJson == this.statsJson &&
          other.abilitiesJson == this.abilitiesJson);
}

class PokemonEntriesCompanion extends UpdateCompanion<PokemonEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> imageUrl;
  final Value<String> typesJson;
  final Value<String> statsJson;
  final Value<String> abilitiesJson;
  const PokemonEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.typesJson = const Value.absent(),
    this.statsJson = const Value.absent(),
    this.abilitiesJson = const Value.absent(),
  });
  PokemonEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.imageUrl = const Value.absent(),
    this.typesJson = const Value.absent(),
    this.statsJson = const Value.absent(),
    this.abilitiesJson = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PokemonEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<String>? typesJson,
    Expression<String>? statsJson,
    Expression<String>? abilitiesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (typesJson != null) 'types_json': typesJson,
      if (statsJson != null) 'stats_json': statsJson,
      if (abilitiesJson != null) 'abilities_json': abilitiesJson,
    });
  }

  PokemonEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? imageUrl,
    Value<String>? typesJson,
    Value<String>? statsJson,
    Value<String>? abilitiesJson,
  }) {
    return PokemonEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      typesJson: typesJson ?? this.typesJson,
      statsJson: statsJson ?? this.statsJson,
      abilitiesJson: abilitiesJson ?? this.abilitiesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (typesJson.present) {
      map['types_json'] = Variable<String>(typesJson.value);
    }
    if (statsJson.present) {
      map['stats_json'] = Variable<String>(statsJson.value);
    }
    if (abilitiesJson.present) {
      map['abilities_json'] = Variable<String>(abilitiesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PokemonEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('typesJson: $typesJson, ')
          ..write('statsJson: $statsJson, ')
          ..write('abilitiesJson: $abilitiesJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PokemonEntriesTable pokemonEntries = $PokemonEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pokemonEntries];
}

typedef $$PokemonEntriesTableCreateCompanionBuilder =
    PokemonEntriesCompanion Function({
      Value<int> id,
      required String name,
      Value<String> imageUrl,
      Value<String> typesJson,
      Value<String> statsJson,
      Value<String> abilitiesJson,
    });
typedef $$PokemonEntriesTableUpdateCompanionBuilder =
    PokemonEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> imageUrl,
      Value<String> typesJson,
      Value<String> statsJson,
      Value<String> abilitiesJson,
    });

class $$PokemonEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PokemonEntriesTable> {
  $$PokemonEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typesJson => $composableBuilder(
    column: $table.typesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statsJson => $composableBuilder(
    column: $table.statsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilitiesJson => $composableBuilder(
    column: $table.abilitiesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PokemonEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PokemonEntriesTable> {
  $$PokemonEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typesJson => $composableBuilder(
    column: $table.typesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statsJson => $composableBuilder(
    column: $table.statsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilitiesJson => $composableBuilder(
    column: $table.abilitiesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PokemonEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PokemonEntriesTable> {
  $$PokemonEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get typesJson =>
      $composableBuilder(column: $table.typesJson, builder: (column) => column);

  GeneratedColumn<String> get statsJson =>
      $composableBuilder(column: $table.statsJson, builder: (column) => column);

  GeneratedColumn<String> get abilitiesJson => $composableBuilder(
    column: $table.abilitiesJson,
    builder: (column) => column,
  );
}

class $$PokemonEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PokemonEntriesTable,
          PokemonEntry,
          $$PokemonEntriesTableFilterComposer,
          $$PokemonEntriesTableOrderingComposer,
          $$PokemonEntriesTableAnnotationComposer,
          $$PokemonEntriesTableCreateCompanionBuilder,
          $$PokemonEntriesTableUpdateCompanionBuilder,
          (
            PokemonEntry,
            BaseReferences<_$AppDatabase, $PokemonEntriesTable, PokemonEntry>,
          ),
          PokemonEntry,
          PrefetchHooks Function()
        > {
  $$PokemonEntriesTableTableManager(
    _$AppDatabase db,
    $PokemonEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PokemonEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PokemonEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PokemonEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> typesJson = const Value.absent(),
                Value<String> statsJson = const Value.absent(),
                Value<String> abilitiesJson = const Value.absent(),
              }) => PokemonEntriesCompanion(
                id: id,
                name: name,
                imageUrl: imageUrl,
                typesJson: typesJson,
                statsJson: statsJson,
                abilitiesJson: abilitiesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> imageUrl = const Value.absent(),
                Value<String> typesJson = const Value.absent(),
                Value<String> statsJson = const Value.absent(),
                Value<String> abilitiesJson = const Value.absent(),
              }) => PokemonEntriesCompanion.insert(
                id: id,
                name: name,
                imageUrl: imageUrl,
                typesJson: typesJson,
                statsJson: statsJson,
                abilitiesJson: abilitiesJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PokemonEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PokemonEntriesTable,
      PokemonEntry,
      $$PokemonEntriesTableFilterComposer,
      $$PokemonEntriesTableOrderingComposer,
      $$PokemonEntriesTableAnnotationComposer,
      $$PokemonEntriesTableCreateCompanionBuilder,
      $$PokemonEntriesTableUpdateCompanionBuilder,
      (
        PokemonEntry,
        BaseReferences<_$AppDatabase, $PokemonEntriesTable, PokemonEntry>,
      ),
      PokemonEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PokemonEntriesTableTableManager get pokemonEntries =>
      $$PokemonEntriesTableTableManager(_db, _db.pokemonEntries);
}
