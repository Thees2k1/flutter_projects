// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poke_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokeGetListDTO _$PokeGetListDTOFromJson(Map<String, dynamic> json) =>
    PokeGetListDTO(
      count: (json['count'] as num).toInt(),
      pokemons: (json['results'] as List<dynamic>)
          .map((e) => PokeNormalized.fromJson(e as Map<String, dynamic>))
          .toList(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );

Map<String, dynamic> _$PokeGetListDTOToJson(PokeGetListDTO instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.pokemons,
    };

PokeNormalized _$PokeNormalizedFromJson(Map<String, dynamic> json) =>
    PokeNormalized(
      name: json['name'] as String,
      detailUrl: json['url'] as String,
    );

Map<String, dynamic> _$PokeNormalizedToJson(PokeNormalized instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.detailUrl};
