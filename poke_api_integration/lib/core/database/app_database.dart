import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'pokemon_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PokemonEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> upsertPokemon(PokemonEntriesCompanion entry) {
    return into(pokemonEntries).insertOnConflictUpdate(entry);
  }

  Future<PokemonEntry?> getPokemonById(int id) {
    return (select(
      pokemonEntries,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<PokemonEntry>> getPokemonByIds(List<int> ids) {
    if (ids.isEmpty) {
      return Future.value(<PokemonEntry>[]);
    }

    return (select(pokemonEntries)..where((table) => table.id.isIn(ids))).get();
  }

  Future<List<PokemonEntry>> getAllPokemon() {
    return (select(
      pokemonEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'poke_cache');
}
