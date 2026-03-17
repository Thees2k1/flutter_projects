import 'package:json_annotation/json_annotation.dart';

part 'poke_list_dto.g.dart';

@JsonSerializable()
class PokeGetListDTO {
  final int count;
  final String? next;
  final String? previous;
  @JsonKey(name: 'results')
  final List<PokeNormalized> pokemons;

  const PokeGetListDTO({
    required this.count,
    required this.pokemons,
    this.next,
    this.previous,
  });

  factory PokeGetListDTO.fromJson(Map<String, dynamic> json) =>
      _$PokeGetListDTOFromJson(json);
}

@JsonSerializable()
class PokeNormalized {
  final String name;
  @JsonKey(name: 'url')
  final String detailUrl;

  const PokeNormalized({required this.name, required this.detailUrl});

  factory PokeNormalized.fromJson(Map<String, dynamic> json) =>
      _$PokeNormalizedFromJson(json);
}
