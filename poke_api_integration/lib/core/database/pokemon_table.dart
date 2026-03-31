import 'package:drift/drift.dart';

class PokemonEntries extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get imageUrl => text().withDefault(const Constant(''))();

  TextColumn get typesJson => text().withDefault(const Constant('[]'))();

  TextColumn get statsJson => text().withDefault(const Constant('[]'))();

  TextColumn get abilitiesJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
