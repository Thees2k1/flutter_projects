import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'poke_detail_dto.dart';

class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.abilities,
  });

  final int id;
  final String name;
  final String imageUrl;
  final List<PokeType> types;
  final List<PokeStat> stats;
  final List<String> abilities;

  factory Pokemon.fromDetailDTO(PokeDetailDTO dto) {
    final imageUrl =
        dto.sprites.other?.officialArtwork?.frontDefault ??
        dto.sprites.frontDefault ??
        '';

    return Pokemon(
      id: dto.id,
      name: dto.name,
      imageUrl: imageUrl,
      types: dto.types
          .map((slot) => PokeTypeX.fromString(slot.type.name))
          .whereType<PokeType>()
          .toList(),
      stats: dto.stats
          .map((item) => PokeStat(name: item.stat.name, value: item.baseStat))
          .toList(),
      abilities: dto.abilities.map((item) => item.ability.name).toList(),
    );
  }

  factory Pokemon.fromDbEntry(PokemonEntry entry) {
    final typesRaw = (jsonDecode(entry.typesJson) as List<dynamic>)
        .whereType<String>();
    final types = typesRaw
        .map(PokeTypeX.fromString)
        .whereType<PokeType>()
        .toList();

    final statsRaw = (jsonDecode(entry.statsJson) as List<dynamic>)
        .whereType<Map<String, dynamic>>();
    final stats = statsRaw
        .map((json) => PokeStat.fromJson(json))
        .toList(growable: false);

    final abilitiesRaw = (jsonDecode(entry.abilitiesJson) as List<dynamic>)
        .whereType<String>()
        .toList(growable: false);

    return Pokemon(
      id: entry.id,
      name: entry.name,
      imageUrl: entry.imageUrl,
      types: types,
      stats: stats,
      abilities: abilitiesRaw,
    );
  }

  PokemonEntriesCompanion toDbEntry() {
    return PokemonEntriesCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: Value(imageUrl),
      typesJson: Value(jsonEncode(types.map((type) => type.name).toList())),
      statsJson: Value(
        jsonEncode(stats.map((stat) => stat.toJson()).toList(growable: false)),
      ),
      abilitiesJson: Value(jsonEncode(abilities)),
    );
  }
}

class PokeStat {
  const PokeStat({required this.name, required this.value});

  final String name;
  final int value;

  factory PokeStat.fromJson(Map<String, dynamic> json) {
    return PokeStat(name: json['name'] as String, value: json['value'] as int);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'value': value};
  }
}

enum PokeType {
  fire,
  water,
  grass,
  electric,
  psychic,
  ice,
  dragon,
  dark,
  fairy,
  normal,
  fighting,
  flying,
  poison,
  ground,
  rock,
  bug,
  ghost,
  steel,
}

extension PokeTypeX on PokeType {
  static PokeType? fromString(String value) {
    for (final type in PokeType.values) {
      if (type.name == value) {
        return type;
      }
    }
    return null;
  }
}
