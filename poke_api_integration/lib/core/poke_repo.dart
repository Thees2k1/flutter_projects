import '../pokelist/models/poke_list_dto.dart';
import 'api_client.dart';
import 'database/app_database.dart';
import 'models/poke_detail_dto.dart';
import 'models/pokemon.dart';
import 'result.dart';

class PokeRepo {
  PokeRepo({required ApiClient apiClient, required AppDatabase db})
    : _apiClient = apiClient,
      _db = db;

  final ApiClient _apiClient;
  final AppDatabase _db;

  String? _nextPageUrl;
  bool _hasMore = true;
  final List<int> _loadedIds = <int>[];

  bool get hasMore => _hasMore;

  Future<Result<List<Pokemon>>> fetchInitialPage() async {
    _nextPageUrl = null;
    _hasMore = true;
    _loadedIds.clear();
    return _fetchPage(path: '/pokemon');
  }

  Future<Result<List<Pokemon>>> fetchNextPage() async {
    if (!_hasMore) {
      return const Success<List<Pokemon>>(<Pokemon>[]);
    }

    final nextUrl = _nextPageUrl;
    if (nextUrl == null) {
      _hasMore = false;
      return const Success<List<Pokemon>>(<Pokemon>[]);
    }

    return _fetchPage(url: nextUrl);
  }

  Future<Result<Pokemon>> getDetail(int id) async {
    try {
      final cached = await _db.getPokemonById(id);
      if (cached != null) {
        return Success<Pokemon>(Pokemon.fromDbEntry(cached));
      }

      final detail = await _apiClient.get<PokeDetailDTO>(
        '/pokemon/$id',
        fromJson: PokeDetailDTO.fromJson,
      );
      final pokemon = Pokemon.fromDetailDTO(detail);
      await _db.upsertPokemon(pokemon.toDbEntry());
      return Success<Pokemon>(pokemon);
    } on ApiException catch (e) {
      return Failure<Pokemon>(e.message, statusCode: e.statusCode);
    } catch (_) {
      return const Failure<Pokemon>('Unexpected error');
    }
  }

  Future<Result<List<Pokemon>>> _fetchPage({String? path, String? url}) async {
    try {
      final pageResult = await _getPage(path: path, url: url);
      _nextPageUrl = pageResult.next;
      _hasMore = pageResult.next != null;

      final ids = pageResult.pokemons
          .map((item) => _extractPokemonId(item.detailUrl))
          .whereType<int>()
          .toList(growable: false);

      if (ids.isEmpty) {
        return const Success<List<Pokemon>>(<Pokemon>[]);
      }

      final cachedEntries = await _db.getPokemonByIds(ids);
      final cachedById = <int, Pokemon>{
        for (final entry in cachedEntries) entry.id: Pokemon.fromDbEntry(entry),
      };

      final missingIds = ids
          .where((id) => !cachedById.containsKey(id))
          .toList();
      if (missingIds.isNotEmpty) {
        final fetched = await Future.wait(
          missingIds.map(_fetchAndCachePokemon),
        );
        for (final pokemon in fetched) {
          cachedById[pokemon.id] = pokemon;
        }
      }

      final pagePokemons = ids
          .map((id) => cachedById[id])
          .whereType<Pokemon>()
          .toList(growable: false);

      _loadedIds.addAll(ids.where((id) => !_loadedIds.contains(id)));

      return Success<List<Pokemon>>(pagePokemons);
    } on ApiException catch (e) {
      return Failure<List<Pokemon>>(e.message, statusCode: e.statusCode);
    } catch (_) {
      return const Failure<List<Pokemon>>('Unexpected error');
    }
  }

  Future<PokeGetListDTO> _getPage({String? path, String? url}) {
    if (url != null) {
      return _apiClient.getByUrl<PokeGetListDTO>(
        url,
        fromJson: PokeGetListDTO.fromJson,
      );
    }

    return _apiClient.get<PokeGetListDTO>(
      path ?? '/pokemon',
      fromJson: PokeGetListDTO.fromJson,
    );
  }

  Future<Pokemon> _fetchAndCachePokemon(int id) async {
    final detail = await _apiClient.get<PokeDetailDTO>(
      '/pokemon/$id',
      fromJson: PokeDetailDTO.fromJson,
    );
    final pokemon = Pokemon.fromDetailDTO(detail);
    await _db.upsertPokemon(pokemon.toDbEntry());
    return pokemon;
  }

  int? _extractPokemonId(String detailUrl) {
    final uri = Uri.tryParse(detailUrl);
    if (uri == null) {
      return null;
    }

    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty);
    final idSegment = segments.isEmpty ? null : segments.last;
    return idSegment == null ? null : int.tryParse(idSegment);
  }
}
