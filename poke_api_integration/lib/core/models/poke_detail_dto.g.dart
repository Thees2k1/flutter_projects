// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poke_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokeDetailDTO _$PokeDetailDTOFromJson(Map<String, dynamic> json) =>
    PokeDetailDTO(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sprites: PokeSpritesDTO.fromJson(json['sprites'] as Map<String, dynamic>),
      types: (json['types'] as List<dynamic>)
          .map((e) => PokeTypeSlotDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: (json['stats'] as List<dynamic>)
          .map((e) => PokeStatDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      abilities: (json['abilities'] as List<dynamic>)
          .map((e) => PokeAbilitySlotDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokeDetailDTOToJson(PokeDetailDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sprites': instance.sprites,
      'types': instance.types,
      'stats': instance.stats,
      'abilities': instance.abilities,
    };

PokeSpritesDTO _$PokeSpritesDTOFromJson(Map<String, dynamic> json) =>
    PokeSpritesDTO(
      frontDefault: json['front_default'] as String?,
      other: json['other'] == null
          ? null
          : PokeSpritesOtherDTO.fromJson(json['other'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PokeSpritesDTOToJson(PokeSpritesDTO instance) =>
    <String, dynamic>{
      'front_default': instance.frontDefault,
      'other': instance.other,
    };

PokeSpritesOtherDTO _$PokeSpritesOtherDTOFromJson(Map<String, dynamic> json) =>
    PokeSpritesOtherDTO(
      officialArtwork: json['official-artwork'] == null
          ? null
          : PokeOfficialArtworkDTO.fromJson(
              json['official-artwork'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PokeSpritesOtherDTOToJson(
  PokeSpritesOtherDTO instance,
) => <String, dynamic>{'official-artwork': instance.officialArtwork};

PokeOfficialArtworkDTO _$PokeOfficialArtworkDTOFromJson(
  Map<String, dynamic> json,
) => PokeOfficialArtworkDTO(frontDefault: json['front_default'] as String?);

Map<String, dynamic> _$PokeOfficialArtworkDTOToJson(
  PokeOfficialArtworkDTO instance,
) => <String, dynamic>{'front_default': instance.frontDefault};

PokeTypeSlotDTO _$PokeTypeSlotDTOFromJson(Map<String, dynamic> json) =>
    PokeTypeSlotDTO(
      type: PokeNamedResourceDTO.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PokeTypeSlotDTOToJson(PokeTypeSlotDTO instance) =>
    <String, dynamic>{'type': instance.type};

PokeNamedResourceDTO _$PokeNamedResourceDTOFromJson(
  Map<String, dynamic> json,
) => PokeNamedResourceDTO(name: json['name'] as String);

Map<String, dynamic> _$PokeNamedResourceDTOToJson(
  PokeNamedResourceDTO instance,
) => <String, dynamic>{'name': instance.name};

PokeStatDTO _$PokeStatDTOFromJson(Map<String, dynamic> json) => PokeStatDTO(
  baseStat: (json['base_stat'] as num).toInt(),
  stat: PokeNamedResourceDTO.fromJson(json['stat'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PokeStatDTOToJson(PokeStatDTO instance) =>
    <String, dynamic>{'base_stat': instance.baseStat, 'stat': instance.stat};

PokeAbilitySlotDTO _$PokeAbilitySlotDTOFromJson(Map<String, dynamic> json) =>
    PokeAbilitySlotDTO(
      ability: PokeNamedResourceDTO.fromJson(
        json['ability'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PokeAbilitySlotDTOToJson(PokeAbilitySlotDTO instance) =>
    <String, dynamic>{'ability': instance.ability};
