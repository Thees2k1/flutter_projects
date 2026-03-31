import 'package:json_annotation/json_annotation.dart';

part 'poke_detail_dto.g.dart';

@JsonSerializable()
class PokeDetailDTO {
  const PokeDetailDTO({
    required this.id,
    required this.name,
    required this.sprites,
    required this.types,
    required this.stats,
    required this.abilities,
  });

  final int id;
  final String name;
  final PokeSpritesDTO sprites;
  final List<PokeTypeSlotDTO> types;
  final List<PokeStatDTO> stats;
  final List<PokeAbilitySlotDTO> abilities;

  factory PokeDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeDetailDTOFromJson(json);
}

@JsonSerializable()
class PokeSpritesDTO {
  const PokeSpritesDTO({this.frontDefault, this.other});

  @JsonKey(name: 'front_default')
  final String? frontDefault;
  final PokeSpritesOtherDTO? other;

  factory PokeSpritesDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeSpritesDTOFromJson(json);
}

@JsonSerializable()
class PokeSpritesOtherDTO {
  const PokeSpritesOtherDTO({this.officialArtwork});

  @JsonKey(name: 'official-artwork')
  final PokeOfficialArtworkDTO? officialArtwork;

  factory PokeSpritesOtherDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeSpritesOtherDTOFromJson(json);
}

@JsonSerializable()
class PokeOfficialArtworkDTO {
  const PokeOfficialArtworkDTO({this.frontDefault});

  @JsonKey(name: 'front_default')
  final String? frontDefault;

  factory PokeOfficialArtworkDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeOfficialArtworkDTOFromJson(json);
}

@JsonSerializable()
class PokeTypeSlotDTO {
  const PokeTypeSlotDTO({required this.type});

  final PokeNamedResourceDTO type;

  factory PokeTypeSlotDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeTypeSlotDTOFromJson(json);
}

@JsonSerializable()
class PokeNamedResourceDTO {
  const PokeNamedResourceDTO({required this.name});

  final String name;

  factory PokeNamedResourceDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeNamedResourceDTOFromJson(json);
}

@JsonSerializable()
class PokeStatDTO {
  const PokeStatDTO({required this.baseStat, required this.stat});

  @JsonKey(name: 'base_stat')
  final int baseStat;
  final PokeNamedResourceDTO stat;

  factory PokeStatDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeStatDTOFromJson(json);
}

@JsonSerializable()
class PokeAbilitySlotDTO {
  const PokeAbilitySlotDTO({required this.ability});

  final PokeNamedResourceDTO ability;

  factory PokeAbilitySlotDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeAbilitySlotDTOFromJson(json);
}
